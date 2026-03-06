# listen_portfolio_flutter

A new Flutter project.

## Get
ting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## rules

* The current flutter version is 3.38.3, please use the latest API.
* Base on Clean + MVI architecture
* answer me in chinese, add code with English comments
* Only modify the relevant code; formatting changes are not needed.
* Dependency, lib/core <- lib/shared, lib/uikit <- lib/shared, lib/core <- lib/uikit
* When drawing the screen, you can use the common components from the lib/uikit directory.
* The core architecture code is in the lib/core directory. no business relevant code, that can be publish to pub, can be used for
  another app
* Business-related screens are under the lib/features directory
* Business-related common code are under the lib/shared directory
* If there are new string resources, please add them to both file below
  * [ja.dart](lib/shared/i18n/languages/ja.dart)
  * [zh.dart](lib/shared/i18n/languages/zh.dart)
  * [translations_key.dart](lib/shared/i18n/translations_key.dart)
* move key of SharedPreferences to [app_constants.dart](lib/shared/constants/app_constants.dart)
* read these core code first
  * [base_view_model.dart](lib/core/base/base_view_model.dart)
  * [base_lifecycle_page.dart](lib/core/base/base_lifecycle_page.dart)
  * [base_scaffold_page.dart](lib/core/base/base_scaffold_page.dart)
  * [base_effect.dart](lib/core/base/base_effect.dart)
  * [base_provider.dart](lib/core/base/base_provider.dart)
  * [api_client.dart](lib/core/network/api_client.dart)
  * [app_nav.dart](lib/core/route/app_nav.dart)
  * [route_interceptor.dart](lib/core/route/route_interceptor.dart)
  * [zone_manager.dart](lib/core/utils/zone_manager.dart)
  * [base_page.dart](lib/shared/base/base_refresh_page.dart)

## todo

* base
    * base use case; view modelMVI
* function
    * notification
    * other pages, use
    * switch env: input url; mock api; config each api; separate mock
    * apm: layout check; lag check; app launch; apk size; net inspector
    * app review
    * finger auth
    * CustomPainter show skills graph
    * ai intro assistant
    * pdf show, download resume
    * unit test
    * session timeout; auto login;
    * profile image upload
    * markdown resume, download pdf
    * channel plugin
    * jni
    * AuthInterceptor: token, refreshToken 
* ide plugin
    * assets
* framework
    * library
        * package_base: only dart
            * package_libs: basic third util, network, sp, event_bus, theme, globalization
                * package_widget: base widgets, button, text, image, dialog, toast, loading, refreshList, tabView,
                    * package_biz: base biz
                        * package_webView: webView
                        * package_splash: splash module
                        * package_login: login module
                        * package_share: share module
                        * plugin_native: plugin for native basic info
* server/
    * db data design
    * api
    * i18
    * build web
* readme: screen capture, architect, tech stack
* issue
    * ndk bundle;
    * pixel icon cache