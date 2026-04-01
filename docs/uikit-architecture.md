# Listen UI Kit

A professional, consistent, and highly customizable UI component library for Flutter. Designed to accelerate development by providing a set of standardized widgets that follow Material Design 3 specifications with built-in support for internationalization and themes.

---

## 🎨 Design Philosophy

### Core Principles
- **Consistency**: Unified visual style and interaction patterns across all components.
- **Customizability**: Flexible theming and style configurations for every widget.
- **Internationalization (i18n)**: Built-in support for dynamic text management.
- **Modern Design**: Adheres to Material Design 3.0 guidelines.
- **Developer Friendly**: Clean APIs with comprehensive configuration options.

---

## 🧩 Component Categories

### 1. Basic Components
- **CommonText**: Standardized text with auto-scaling (`FittedBox`) and theme-aware coloring.
- **CommonImage**: Unified image handling for Assets, Network (cached), Local files, SVG, and GIF.
- **CommonButton**: Versatile buttons (Filled, Outlined, Text) with built-in loading states and icon support.

### 2. Input Components
- **CommonTextField**: Form input with labels, validation, and custom styling.
- **CommonSwitch**: Clean, labeled toggle switches with haptic feedback.

### 3. Container & Presentation
- **CommonCard**: Standardized containers with shadow, border, and gesture support.
- **CommonBadge**: Notification badges for counts or status indicators.
- **CommonChip**: Selectable and deletable tags for filters or labels.
- **CommonListItem**: Standardized row layouts for settings or data lists.

### 4. Feedback & Loading
- **CommonToast**: Global message alerts (Success, Error, Info) with smooth animations.
- **CommonLoading**: Global and inline loading indicators with custom messaging.
- **CommonDialog**: Centralized dialog utility for confirmations, selections, and custom content.
- **CommonSkeleton**: Placeholder animations for content loading states.
- **CommonEmptyView**: Standardized views for "No Data", "Network Error", or "No Results".

---

## 📦 Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  listen_uikit:
    path: ../ListenUiKit
  listen_core:
    path: ../ListenCore
```

---

## 🚀 Getting Started

### 1. Initialization & Internationalization
Set up the global configuration and inject your translation logic via `UIKitConfig`.

```dart
void main() {
  UIKitConfig.init(
    stringProvider: (key) {
      final map = {
        UIKitConfig.kOk: 'OK',
        UIKitConfig.kCancel: 'Cancel',
        UIKitConfig.kRetry: 'Retry',
      };
      return map[key] ?? key;
    },
  );
  runApp(const MyApp());
}
```

### 2. Basic Usage

#### Button & Toast
```dart
CommonButton.filled(
text: 'Submit',
onPressed: () => CommonToast.success('Action Completed'),
isLoading: false,
)
```

#### Dialogs
```dart
final confirmed = await CommonDialog.showConfirm(
  title: 'Delete Item',
  message: 'Are you sure you want to proceed?',
);
```

#### Images
```dart
CommonImage.url(
'https://example.com/image.jpg',
borderRadius: 8.0,
fit: BoxFit.cover,
)
```

---

## 📊 Component Statistics

| Category | Count | Primary Purpose |
|----------|-------|-----------------|
| Basic | 3 | Text, Image, Button |
| Input | 2 | Forms, Toggles |
| Container | 4 | Layout, Cards, Lists |
| Feedback | 6 | Dialogs, Loading, Toasts |
| **Total** | **15** | **Complete UI Solution** |

---

## 🔮 Roadmap
- [ ] Support for advanced charts and data tables.
- [ ] Enhanced animation library for transitions.
- [ ] Theme preset templates (Dark, Light, High Contrast).
- [ ] Visual documentation and component gallery app.

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
