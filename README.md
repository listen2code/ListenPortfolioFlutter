# ListenPortfolioFlutter

A sophisticated personal portfolio application built with Flutter, demonstrating enterprise-level mobile development practices and architectural excellence. This project serves as both a professional portfolio showcase and a comprehensive example of modern Flutter application architecture.

## 🌟 Project Overview

ListenPortfolioFlutter is a production-ready mobile application that showcases a personal portfolio with advanced features including authentication, project management, multi-language support, and comprehensive monitoring capabilities. The application follows industry best practices and implements a robust, scalable architecture suitable for enterprise-level projects.

## 🏗️ Architecture Design

### Clean Architecture Implementation

The project strictly adheres to Clean Architecture principles, implementing a clear separation of concerns across multiple layers:

```
lib/
├── core/                    # Core business logic and utilities
├── features/               # Feature-based modular architecture
│   ├── auth/              # Authentication feature module
│   ├── home/              # Home and portfolio feature module
│   └── settings/           # Settings and configuration module
└── shared/                # Shared components and utilities
```

### Layer Architecture

#### 1. Presentation Layer
- **MVI Pattern**: Implements Model-View-Intent architecture with clear separation
- **State Management**: Utilizes Riverpod for reactive state management
- **UI Components**: Custom widgets with consistent design system
- **Navigation**: Custom AppNav + centralized Routes registry (MaterialPageRoute), with login interception support

#### 2. Domain Layer
- **Use Cases**: Business logic encapsulation with single responsibility
- **Repositories**: Abstract interfaces for data access
- **Entities**: Core business models with validation logic
- **Business Rules**: Domain-specific validation and transformation

#### 3. Data Layer
- **Repository Implementation**: Concrete data access implementations
- **Data Sources**: Remote (API) and local (cache) data sources
- **Models**: Data transfer objects with serialization
- **Caching Strategy**: Intelligent cache management with expiration

### Core Architecture Components

#### Base Classes (`core/base/`)
- **BaseViewModel**: Foundation for all ViewModels with common functionality
- **BaseLifecyclePage**: Lifecycle-aware page management
- **BaseMaterialApp**: Custom MaterialApp with global configurations
- **BaseScaffoldPage**: Standardized page layout with common features

#### Network Layer (`core/network/`)
- **ApiClient**: Centralized HTTP client with interceptors
- **BaseRepository**: Abstract repository with common CRUD operations
- **BaseResponseModel**: Standardized API response handling
- **LocalMockServer**: Development mock server for offline testing

#### Utility Layer (`core/utils/`)
- **CacheManager**: Intelligent caching with TTL support
- **CrashManager**: Comprehensive crash reporting and logging
- **SecureStorage**: Encrypted storage for sensitive data
- **Validators**: Input validation utilities

## 🚀 Key Features

### Authentication System
- **Login & Signup**: Token-based authentication with guest mode support
- **Password Management**: Change password, forgot password
- **Session Management**: Automatic token refresh on 401 with queued retry
- **Account Management**: Account deletion flow and related policy pages

### Portfolio Management
- **Project Showcase**: Dynamic project display with rich media support
- **About Me**: Personal info module (login-gated)
- **Architecture Showcase**: Dedicated page to demonstrate architecture/engineering highlights

### User Experience
- **Multi-language Support**: i18n implementation with English, Japanese, and Chinese
- **Theme Customization**: Light/Dark/System modes and runtime switching
- **Responsive Design**: Adaptive layouts for different screen sizes

### Developer Features
- **Environment Switching**: Development, testing, staging, and production environments
- **Mock API Server**: Local mock server for development without backend dependency
- **Crash Reporting**: Automatic crash log persistence + safe mode reset capability
- **Diagnostics**: Log overlay, traceId-based logging, and Zone-based performance marks

## 🛠️ Technical Stack

### Core Technologies
- **Flutter**: Cross-platform mobile development framework
- **Dart**: Modern programming language with null safety
- **Riverpod**: Advanced state management solution
- **Dio**: Powerful HTTP client for networking
- **Retrofit**: Type-safe HTTP client generator

### Code Generation & Tooling
- **Freezed**: Immutable data classes with pattern matching
- **Json Serializable**: Automatic JSON serialization/deserialization
- **Riverpod Generator**: Code generation for providers
- **Build Runner**: Dart code generation framework

### Development Tools
- **Flutter Launcher Icons**: Automated app icon generation
- **Flutter Native Splash**: Native splash screen implementation
- **Shared Preferences**: Local key-value storage
- **Secure Storage**: Encrypted storage for sensitive data

## 📱 Application Structure

### Feature Modules

#### Authentication Module (`features/auth/`)
```
auth/
├── data/
│   ├── datasources/       # Local and remote data sources
│   ├── models/           # Request/response models
│   └── repositories/     # Repository implementations
├── domain/
│   ├── repositories/     # Repository interfaces
│   └── usecases/        # Business logic use cases
└── presentation/
    ├── pages/           # Login, signup, password pages
    └── provider/        # Authentication state providers
```

#### Home Module (`features/home/`)
```
home/
├── data/
│   ├── datasources/     # About me and projects data sources
│   ├── models/         # Data models
│   └── repositories/   # Repository implementations
├── domain/
│   ├── repositories/    # Repository interfaces
│   └── usecases/      # Get about me, get projects use cases
└── presentation/
    ├── pages/
    │   ├── about_me/    # Personal information page
    │   ├── architecture/ # Architecture showcase
    │   ├── overview/     # Main overview page
    │   └── projects/    # Projects showcase
    └── provider/       # State providers
```

#### Settings Module (`features/settings/`)
```
settings/
└── presentation/
    └── pages/
        ├── appearance/   # Theme and appearance settings
        ├── crash_log_list/ # Crash report management
        ├── delete_account/ # Account deletion flow
        ├── privacy_policy/ # Privacy policy page
        ├── terms_of_service/ # Terms of service page
        └── settings_page.dart # Entry page (env/lang/log overlay/cache tools)
```

## 🌍 Internationalization (i18n)

### Supported Languages
- **English (en)**: Primary development language
- **Japanese (ja)**: 日本語 - Full localization
- **Chinese (zh)**: 简体中文 - Full localization

### i18n Architecture (`core/i18n/`)
- **Translation Keys**: Centralized string key definitions
- **Language Files**: Separate files for each supported language
- **Dynamic Switching**: Runtime language switching without app restart
- **Complete Coverage**: All user-facing text is localized

## 🎨 Theme System

### Theme Architecture
- **Light/Dark Modes**: Complete theme support
- **Custom Colors**: User-selectable accent colors
- **Font Size**: Standard and large font options

### Theme Components
- **Color Scheme**: Primary, secondary, tertiary colors
- **Typography**: Consistent font scaling
- **Shape System**: Rounded corners and elevation
- **Icon Theme**: Consistent icon styling

## 🔧 Development Environment

### Environment Management (`core/env/`)
- **Development**: Local development with mock server
- **Testing**: Integration testing environment
- **Staging**: Pre-production testing
- **Production**: Live production environment

### Environment Features
- **Runtime Switching**: Change environments without rebuild
- **Independent Configs**: Separate configurations per environment
- **API Management**: Different API endpoints per environment
- **Mock Integration**: Seamless mock data integration

## 📊 Error Handling & Monitoring

### Error Architecture (`core/errors/`)
- **Exception Hierarchy**: Structured exception types
- **Failure Models**: Business logic failure encapsulation
- **Global Error Handler**: Centralized error processing
- **User-Friendly Messages**: Localized error descriptions

### Crash Reporting (`core/utils/crash_manager.dart`)
- **Automatic Capture**: Unhandled exception capture
- **Detailed Logging**: Stack traces and device information
- **Upload System**: Automatic crash report upload
- **Developer Tools**: Manual crash injection for testing

## 🧪 Testing Strategy

### Testing Architecture
- **Unit Tests**: Business logic validation
- **Widget Tests**: UI component testing
- **Mock Strategy**: Comprehensive mocking with Mocktail

### Testing Tools
- **Mocktail**: Modern mocking library
- **Http Mock Adapter**: Network request mocking
- **Flutter Test**: Official testing framework
- **Build Runner**: Test automation

## 🚀 Build & Deployment

### Build Configuration
- **Multi-Platform**: Android, iOS, Web support
- **Architecture Support**: ARM64, ARM, x64
- **Code Signing**: Secure app signing
- **Version Management**: Automated versioning

### Deployment Pipeline
- **Automated Testing**: Pre-deployment testing
- **Code Quality**: Linting and formatting
- **Release Management**: Automated release notes

## 📈 Performance Optimization

### Performance Features
- **Lazy Loading**: On-demand feature loading
- **Image Caching**: Intelligent image caching with CachedNetworkImage
- **State Optimization**: Efficient state management
- **Memory Management**: Proper resource cleanup

### Monitoring Capabilities
- **Performance Metrics**: FPS, CPU usage, memory monitoring
- **Network Inspection**: Request/response logging
- **Layout Performance**: Layout boundary detection
- **App Launch Metrics**: Startup time tracking

## 🔮 Future Roadmap

### Upcoming Features
- **AI Assistant**: Intelligent portfolio introduction
- **PDF Export**: Resume PDF generation and download
- **Skill Analytics**: Advanced skill visualization
- **Social Integration**: LinkedIn/GitHub integration

### Technical Enhancements
- **Accessibility**: Enhanced a11y features
- **Performance**: Advanced optimization techniques
- **Security**: Enhanced security measures

## 📌 Implementation Notes (Code References)

This section describes the current implementation in code (not only the roadmap).

### App Entry & Composition Root

- App entry: `lib/main.dart` uses `Core.run(...)` to centralize crash capture and delegate UI behavior on crash.
- Composition Root: `lib/shared/utils/app_initializer.dart` wires core interfaces to shared implementations:
  - Storage prefix
  - Initial Effect providers (Loading/Message/Navigation/Logout/Share)
  - API auth bridge (`IApiInterceptorDelegate`) for header injection + refresh token
  - Safe mode reset behavior
  - Env configs registration (`EnvConfigs.values`)
  - i18n registration (zh/ja)
  - Route registry (`Routes.routes`) + login interception callbacks

### Navigation

- Central route registry: `lib/shared/utils/routes.dart`
- Navigation API + login interception: `lib/core/route/app_nav.dart`

### Network & Error Mapping

- Dio client and interceptors: `lib/core/network/api_client.dart`
- Standard API envelope: `lib/core/network/base_response_model.dart`
- Unified call wrapper with cache fallback: `lib/core/network/base_repository.dart`

### Environment & Mock Server

- Environment switching: `lib/core/env/app_env.dart`
- Project env configs: `lib/shared/constants/env_config.dart`
- In-app mock server: `lib/core/network/local_mock_server.dart`
- Mock assets:
  - JSON: `assets/mock/v1/*`
  - Images: `assets/mock/images/*` (served via `/v1/resource/...`)

### Crash & Diagnostics

- Crash logs + safe mode: `lib/core/utils/crash_manager.dart`
- Zone-based tracing/performance: `lib/core/utils/zone_manager.dart`
- Log overlay: `lib/shared/utils/log_overlay_manager.dart`

## 🏃 Getting Started

```bash
# Install dependencies
flutter pub get

# Generate code (Freezed/Json/Riverpod/Retrofit)
dart run build_runner build --delete-conflicting-outputs

# Run with mock env (starts LocalMockServer at http://localhost:9999)
flutter run --dart-define=APP_ENV=mock
```

## 🧪 Run Tests

```bash
flutter test
```

## 🎯 Conclusion

ListenPortfolioFlutter represents a comprehensive example of modern Flutter application development, combining architectural excellence with practical functionality. The project demonstrates how to build scalable, maintainable, and feature-rich mobile applications using industry best practices.

Whether you're a Flutter developer seeking architectural guidance, a company looking for development standards, or an individual wanting to showcase your skills, this project provides valuable insights and practical implementations for building production-ready Flutter applications.

The modular architecture, comprehensive feature set, and attention to detail make this project an excellent foundation for both learning and production deployment, setting a high standard for Flutter application development.
