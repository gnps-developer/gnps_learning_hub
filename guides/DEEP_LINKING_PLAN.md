# 🗺️ Scalable Navigation & Deep Linking Plan

This document outlines the architectural transition from imperative navigation (`Navigator.push`) to a declarative, scalable routing system using **`go_router`**. This approach is the industry standard for production-grade Flutter apps, especially those targeting Web and mobile deep linking.

## 1. Core Objectives
*   **Declarative State**: The URL becomes a direct reflection of the app's current state.
*   **Deep Link Ready**: Support direct access to specific games (e.g., `/game/crossword_punjabi`) across Web, iOS, and Android.
*   **Safe Progression**: Use "Guards" to ensure users cannot skip curriculum rules via direct links.
*   **State-Aware**: The router integrates with Riverpod to wait for Hive and JSON data to load before deciding on the landing page.

---

## 2. Technical Stack
| Component | Technology | Role |
| :--- | :--- | :--- |
| **Routing Engine** | `go_router` | Manages the URL, page stack, and transitions. |
| **State Management** | `flutter_riverpod` | Provides the router with real-time user progress and data loading status. |
| **Platform Integration** | OS Native Config | Connects physical web URLs to the installed mobile application. |

---

## 3. Implementation Phases

### Phase 1: Infrastructure Setup
1.  **Add Dependency**: Add `go_router` to `pubspec.yaml`.
2.  **Define Route Map**: Create `lib/config/router.dart` to house the centralized route definitions.
    *   `/splash`: Initial loading screen.
    *   `/intro`: Onboarding flow.
    *   `/`: Main Journey Map.
    *   `/shop`: Avatar customization and item shop.
    *   `/profile`: User stats and settings.
    *   `/game/:id`: Dynamic route handling all arcade and crossword modules via their unique IDs.

### Phase 2: Reactive Redirection (Guards)
The system will use a global `redirect` function that listens to Riverpod providers to enforce app logic:
*   **Bootstrap Guard**: If `journeyProvider` is loading, stay on `/splash`.
*   **Onboarding Guard**: If user hasn't finished the intro, force redirect to `/intro`.
*   **Security Guard**: If a user hits `/game/crossword_punjabi` but `progressProvider` shows it is locked, automatically redirect them back to the Map (`/`) with a "Locked" notification.

### Phase 3: main.dart Refactor
Transition the app entry point to the `MaterialApp.router` constructor:
```dart
return MaterialApp.router(
  routerConfig: ref.watch(routerProvider),
  // ... themes and localization ...
);
```

---

## 4. Platform-Specific Activation

### Web (Automatic)
GoRouter handles browser URL synchronization out of the box. Ensure the build command includes the correct base path:
```bash
flutter build web --release --base-href /gurmukhi-sikho-webapp/
```

### Mobile (Manual Config)
To enable "App Links" (Android) and "Universal Links" (iOS), the following OS-level configurations are required:

#### Android (`AndroidManifest.xml`)
Add an Intent Filter to `MainActivity` to capture specific URLs:
```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="https" android:host="gnps-developer.github.io" />
    <data android:pathPrefix="/gurmukhi-sikho-webapp" />
</intent-filter>
```

#### iOS (`Runner.entitlements`)
Enable **Associated Domains** in Xcode and add your hosting domain:
*   `applinks:gnps-developer.github.io`

#### The Digital Handshake
Host the mandatory verification files on your GitHub Pages site:
*   **Android**: `/.well-known/assetlinks.json`
*   **iOS**: `/.well-known/apple-app-site-association`

---

## 5. Maintenance & Future Use Cases
*   **Modular Expansion**: Adding new games requires only a JSON update; the dynamic `/game/:id` route will handle them automatically.
*   **Classroom Sharing**: Teachers can generate and share links that take students directly to a specific learning module.
*   **Analytics**: Better tracking of which parts of the app are most popular based on URL entry points.

---

> [!TIP]
> This plan ensures that **Gurmukhi Sikho** remains scalable as the curriculum grows, providing a seamless experience whether a user is on a desktop browser or a mobile device.
