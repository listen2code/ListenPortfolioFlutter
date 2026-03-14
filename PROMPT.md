* This is an app that introduces personal technical skills and resume.
* The current flutter version is 3.38.3, please use the latest API.
* Base on Clean + MVI architecture
* answer me in chinese, add code with English comments
* Do not delete my comments casually; you can modify them.
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