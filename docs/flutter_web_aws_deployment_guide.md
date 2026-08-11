# 🌐 Flutter Web 打包构建、AWS EC2 部署发布与全流程踩坑指南

本文档全面总结了 ListenPortfolio Flutter Web 项目从本地/CI 打包构建、发布部署至 AWS EC2 服务器的完整流程，以及在多平台兼容、网络跨域、环境切换和服务器托管过程中遇到的全部典型问题与解决方案。

---

## 🛠️ 1. 本地与 CI 打包构建指南

### 1.1 构建命令
在 Flutter 前端项目根目录下执行以下标准发布构建命令：

```bash
flutter build web --release --dart-define=APP_ENV=prod
```

### 1.2 关键构建参数解析
| 构建参数 | 作用与必要性 |
| :--- | :--- |
| `--release` | 开启 release 模式优化。触发 Dart2JS 编译器极致压缩，启动图标 Tree-shaking 剔除未使用的 Font 资产，显著提升 Web 加载速度。 |
| `--dart-define=APP_ENV=prod` | **必传参数**。向 Dart 编译器注入环境变量，指定全局 `AppEnv` 使用生产环境 (`prod`) 配置（绑定 `http://13.218.192.181/api` 基准地址），防止自动降级为 `mock` 环境。 |

---

## 🚀 2. AWS EC2 部署发布流程

### 2.1 极速压包部署方案 (推荐)
为避免在 Windows/CI 环境下通过 SCP 传输成百上千个前端散落文件导致 `Connection reset` 掉线，强烈推荐使用 `tar.gz` 打包后单文件传输：

```bash
# 1. 在本地将 build/web 产物打包压缩
tar -czf web.tar.gz -C build/web .

# 2. 将单个压缩包上传至 EC2 /tmp 目录
scp -i tool/listen.pem -o StrictHostKeyChecking=no web.tar.gz ec2-user@13.218.192.181:/tmp/web.tar.gz

# 3. 登录服务器解压覆盖并赋予 755 权限
ssh -i tool/listen.pem -o StrictHostKeyChecking=no ec2-user@13.218.192.181 "
  sudo mkdir -p /var/www/listen_portfolio_web && \
  sudo tar -xzf /tmp/web.tar.gz -C /var/www/listen_portfolio_web/ && \
  sudo chmod -R 755 /var/www/listen_portfolio_web && \
  sudo rm -f /tmp/web.tar.gz
"
```

### 2.2 GitHub Actions CI/CD 自动化部署
在 [`.github/workflows/ci.yml`](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/.github/workflows/ci.yml) 中配置了独立部署 Job `deploy-to-aws-web`：
- **版本校验**：与 `deploy-to-google-play` 平级，共享 `tools/get_play_version.js` 的构建触发逻辑。
- **自动编译**：自动执行 `flutter build web --release --dart-define=APP_ENV=prod`。
- **自动上云**：通过 SSH Key 一键上传并应用 Linux 755 权限。

---

## 💥 3. 部署踩坑全记录与解决方案

在 Web 部署过程中，我们共排查并解决了 **5 个导致白屏或网络失败的深层隐患**：

### 📌 问题一：原生移动端插件导致网页首帧白屏 (`UnimplementedError`)
- **现象**：浏览器打开网页后屏幕一片空白，控制台没有挂载任何 DOM Canvas。
- **根因**：应用启动时 [`app_initializer.dart`](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/lib/shared/utils/app_initializer.dart) 在 `runApp()` 之前无条件调用了移动端原生插件（如 `QuickActionsManager.init()`、`ReviewService`、`iapService` 应用内购买、`shorebirdService` 热更新）。这些插件在 Web 端未实现，抛出 `UnimplementedError`，中断了 `main()` 函数。
- **解决**：在 `AppInitializer` 中使用 `if (!kIsWeb)` 将所有原生平台服务妥善隔离防护，并加入 Try-Catch 兜底保护。

### 📌 问题二：底层依赖库 `ListenCore` 未做平台防护导致崩溃
- **现象**：隔离 UI 插件后，网页仍然白屏。
- **根因**：
  1. `ListenCore` 的 `DeviceInfoImpl.create()` 直接调用了 `Platform.isAndroid` 和 `Platform.isIOS`。Web Dart 运行时不支持 `dart:io` 的 `Platform` 对象，触发 `UnsupportedError: Platform._operatingSystem` 异常。
  2. `FrameMonitor` APM 性能监控调用了 `Platform.environment`，在浏览器运行时同样触发 `UnsupportedError`。
- **解决**：
  1. 在 `ListenCore` (`device_info.dart`) 中引入 `kIsWeb`，增加 `WebDeviceInfoImpl`（通过 `plugin.webBrowserInfo` 提取浏览器元数据）与 `FallbackDeviceInfoImpl`。
  2. 在 `FrameMonitor` (`frame_monitor.dart`) 中将环境变量检测改为 `!kIsWeb && Platform.environment.containsKey(...)`。

### 📌 问题三：浏览器 CORS 跨域与 Preflight (OPTIONS) 拦截报错
- **现象**：API 请求报错：`The connection errored: The XMLHttpRequest onError callback was called... not a CORS "simple request"`。
- **根因**：网页从 80 端口向 8080 端口发送 `application/json` 异步请求，浏览器判定为跨域 (Cross-Origin) 并自动发出 `OPTIONS` 预检请求。
- **解决**：
  1. **同源映射**：修改 [`env_config.dart`](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/lib/shared/constants/env_config.dart)，将 `prod` 环境 `baseUrl` 统一定义为同源相对路径 `http://13.218.192.181/api`。通过 80 端口同源访问，浏览器彻底不再触发任何 CORS 检查。
  2. **Nginx 兜底**：在 EC2 的 Nginx `/api/` 代理层添加 `if ($request_method = 'OPTIONS')`，自动响应 `204 No Content` 并带上 `Access-Control-Allow-*` 头部。

### 📌 问题四：默认环境硬编码为 `mock` (`localhost:9999`)
- **现象**：前端在 AWS Web 正常展示，但点登录/发 API 时连向了用户本地电脑的 `http://localhost:9999`。
- **根因**：`ListenCore` (`AppEnv`) 在未识别到 `--dart-define=APP_ENV=prod` 时，默认将环境降级为 `"mock"`，导致 `apiBaseUrl` 返回了 `http://localhost:9999`。
- **解决**：
  1. 在 `AppEnv` 中增加 `kReleaseMode` 默认兜底：Release 模式下若未保存过环境，默认强切至 `prod` 环境。
  2. CI/CD 和本地编译命令中显式带上 `--dart-define=APP_ENV=prod`。

### 📌 问题五：批量文件 SCP 传输中断与 Nginx 403 Forbidden
- **现象**：直接 SCP `build/web/*` 报 `Connection reset`；访问网页字体/脚本报 HTTP 403。
- **根因**：Linux 下 Nginx 进程用户为 `nginx`，若部署目录或解压出来的文件没有全局 `755` 权限，Nginx 会拒绝读取。
- **解决**：打包为单文件 `web.tar.gz` 传输，并在解压后统一执行 `sudo chmod -R 755 /var/www/listen_portfolio_web`。

---

## 📋 4. 部署验证 Checklist

部署完成后，可以通过以下标准命令与动作进行上线验证：

```bash
# 1. 验证 Web 首页 HTTP 200
curl -I http://13.218.192.181/

# 2. 验证 API 代理透传 (80 -> 8080)
curl -I http://13.218.192.181/api/v1/test

# 3. 验证 CORS OPTIONS 预检 204
curl -I -X OPTIONS http://13.218.192.181/api/v1/test \
  -H "Origin: http://13.218.192.181" \
  -H "Access-Control-Request-Method: POST"

# 4. 浏览器强刷验证 (Ctrl + Shift + R)
# 访问 http://13.218.192.181，打开 F12 Console，确保无 JavaScript 未捕获异常和网络报错。
```
