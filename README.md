# ListenPortfolioFlutter

This is a personal portfolio project built with Flutter, showcasing a modern and robust mobile application architecture. The project demonstrates best practices in Flutter development, including Clean Architecture, Riverpod for state management, and a comprehensive set of tools for building scalable and maintainable applications.

## Features

*   **Clean Architecture:** The project follows a strict Clean Architecture pattern, separating the codebase into `core`, `features`, `data`, `domain`, and `presentation` layers.
*   **State Management:** Utilizes `flutter_riverpod` for efficient and scalable state management.
*   **Networking:** Implements a robust networking layer using `dio` and `retrofit` for type-safe API calls, with a built-in `AuthInterceptor` for handling authentication.
*   **Code Generation:** Leverages code generation tools like `freezed`, `json_serializable`, and `riverpod_generator` to minimize boilerplate code.
*   **Routing:** Uses `go_router` for declarative and flexible navigation.
*   **Local Mock Server:** Includes a local mock server for development and testing, allowing the frontend to be developed independently of the backend.
*   **Comprehensive Core Layer:** A well-defined `core` layer provides common functionalities such as error handling, dependency injection, internationalization, and utility services.

## todo

* base
    * base use case; view modelMVI
    * state roaming
    * all code can be config in core
    * BaseResponseModel serverError
* function
    * other pages, use
    * switch env: input url; mock api; config each api; separate mock
    * apm: layout check; lag check; app launch; apk size; net inspector; FPS; Cpu usage; memory; 
    * app review
    * finger auth
    * CustomPainter show skills graph
    * ai intro assistant
    * markdown show, download pdf resume
    * unit test
    * profile image upload
    * channel plugin
    * jni
    * AuthInterceptor: token, refreshToken, session timeout; auto login;
    * Third login: google
    * Material You: Dynamic Color
    * accessibility a11y
    * CI CD：upload to S3
    * if (!widget.useScaffold); onBackInvoked
    * merge _effectController and eventBus in baseModel
* ide plugin
    * assets
* server
    * db data design
    * api
    * i18
    * build web
* doc: screen capture, architect, tech stack
* issue
    * ndk bundle;
    * pixel icon cache