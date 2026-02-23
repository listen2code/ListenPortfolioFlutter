# listen_portfolio_flutter

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## rules

* The current flutter version is 3.38.3, please use the latest API.
* Use English comments
* Only modify the relevant code; formatting changes are not needed.
* When drawing the screen, you can use the common components from the lib/shared/widgets directory.
* The core architecture code is in the lib/core directory. no business relevant code, that can be publish to pub, can be used for
  another app
* Business-related screens are under the lib/features directory
* Business-related common code are under the lib/shared directory
* If there are new string resources, please add them to both file below
    * [translations_key.dart](lib/core/i18n/translations_key.dart)
    * [en.dart](lib/core/i18n/languages/en.dart)
    * [ja.dart](lib/core/i18n/languages/ja.dart)
    * [zh.dart](lib/core/i18n/languages/zh.dart).

## todo

* base
    * base use case; view modelMVI
    * core -> shared
    * publish core
    * publish widget
* function
    * notification
    * other pages, use
    * common_switch
    * switch env: input url; mock api; config each api; separate mock
    * apm: layout check; lag check; app launch; apk size; net inspector
    * app review
    * finger auth
    * auto login
    * CustomPainter show skills graph
    * ai intro assistant
    * pdf show, download resume
    * unit test
    * pwd Encryption
    * session timeout; auto login;
    * profile image upload
    * markdown resume, download pdf
    * channel plugin
    * jni
    * safe mode
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