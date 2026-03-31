# Listen Portfolio Flutter - Development Guide

## Project Overview
* This is an app that introduces personal technical skills and resume.
* The current flutter version is 3.38.3, please use the latest API.
* Base on Clean + MVI architecture

## Development Standards
* Answer in Chinese, add code with English comments
* Do not delete my comments casually; you can modify them.
* Only modify the relevant code; formatting changes are not needed.

## Architecture Design
* Dependency hierarchy: lib/core <- lib/shared, lib/uikit <- lib/shared, lib/core <- lib/uikit
* When drawing the screen, you can use the common components from the lib/uikit directory.
* The core architecture code is in the lib/core directory. no business relevant code, that can be publish to pub, can be used for another app
* Business-related screens are under the lib/features directory
* Business-related common code are under the lib/shared directory

## Internationalization (i18n)
* If there are new string resources, please add them to both file below
  * [ja.dart](../lib/shared/i18n/languages/ja.dart)
  * [zh.dart](../lib/shared/i18n/languages/zh.dart)
  * [translations_key.dart](../lib/shared/i18n/translations_key.dart)
* All user-facing text must support multiple languages
* Use I18nKeys constants instead of hardcoded strings

## Data Storage
* Move key of SharedPreferences to [app_constants.dart](../lib/shared/constants/app_constants.dart)
* Sensitive data (tokens, passwords) must use FlutterSecureStorage
* Use constants for all storage keys to avoid typos

## Core Architecture - Must Read Files
*Before starting development, read these core code first:*
* [base_view_model.dart](../lib/core/base/base_view_model.dart) - MVI architecture ViewModel base class
* [base_lifecycle_page.dart](../lib/core/base/base_lifecycle_page.dart) - Page lifecycle management
* [base_scaffold_page.dart](../lib/core/base/base_scaffold_page.dart) - Unified page structure
* [base_effect.dart](../lib/core/base/base_effect.dart) - Side effect handling
* [base_provider.dart](../lib/core/base/base_provider.dart) - State management provider
* [api_client.dart](../lib/core/network/api_client.dart) - Network request client
* [app_nav.dart](../lib/core/route/app_nav.dart) - Route management
* [route_interceptor.dart](../lib/core/route/route_interceptor.dart) - Route interceptor
* [zone_manager.dart](../lib/core/utils/zone_manager.dart) - Zone context management
* [base_page.dart](../lib/shared/base/base_refresh_page.dart) - Refresh page base class

## Quality Assurance
* After completing each feature, add an MD documentation file in the docs directory and add related unit tests, ensuring 100% test pass rate
* All new features must include unit tests with 100% pass rate
* Documentation must be added to docs/ directory for each completed feature
* Follow existing code style and naming conventions
* Use functional programming patterns (fpdart) for error handling

## Testing Strategy
* Unit tests for ViewModels, Repositories, and UseCases
* Widget tests for UI components
* Integration tests for complete user flows
* Mock all external dependencies using mocktail
* Test coverage should be maintained above 60%

## Network Layer Standards
* Use ApiClient.dio for all HTTP requests
* Follow Retrofit annotation patterns for API endpoints
* Handle errors using Either<Failure, T> pattern
* Implement proper caching with BaseRepository.safeCall
* All API responses must use BaseResponseModel wrapper

## State Management
* Use Riverpod for dependency injection and state management
* Follow MVI pattern: Intent -> ViewModel -> State -> UI
* Use freezed for immutable state classes
* Handle side effects with BaseEffect pattern

## Security Standards
* Never hardcode API keys or sensitive data
* Use secure storage for authentication tokens
* Implement proper certificate pinning for production
* Validate all user inputs on both client and server side

## Performance Optimization
* Use const constructors wherever possible
* Implement proper image caching with cached_network_image
* Optimize widget rebuilds using appropriate keys
* Use ListView.builder for long lists
* Monitor performance with ZoneManager.mark() calls

## Environment Configuration
* Support multiple environments: mock, dev, test, prod
* Use AppEnv for environment-specific configurations
* Mock server runs on localhost:9999 for development
* All API endpoints should be environment-aware