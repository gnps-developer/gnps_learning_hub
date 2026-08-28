# GNPS Learning Hub 🌲🦁

Learn Punjabi through engaging, gamified lessons. Earn gems, build streaks, unlock arcade games, and customize your own avatar as you master Gurmukhi!

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Material 3](https://img.shields.io/badge/Material--3-6750A4?style=for-the-badge&logo=materialdesign&logoColor=white)](https://m3.material.io/)

---

## ✨ Key Features

### 🗺️ Learning Journey
- **Interactive Map**: A visual roadmap through a lush forest guiding students from letters to complex sentences.
- **Task Types**: Tracing (with checkpoint verification), Letter Matching, Spelling (drag-and-drop), Picture/Word matching, and Sentence Building.

### 🎮 Arcade Games
- **3D Bubble Pop Engine**: Immersive physics-based gameplay to reinforce recognition.
- **Difficulty Tiers**: Easy, Medium, and Hard modes with dynamic speed and spawn scaling.

### 🏆 Achievement & Personalization
- **Trophy Room**: Earn Bronze, Silver, and Gold trophies for mastering challenges.
- **Avatar Customizer**: High-quality SVG-based system for Turbans, clothes, and accessories.
- **In-App Shop**: Use "Gems" earned through learning to unlock premium cosmetics.

### 🔥 Engagement & UX
- **Daily Streaks**: Habit-forming tracking with "Streak Freeze" protection.
- **Immersive Audio**: Integrated Text-to-Speech for authentic Punjabi pronunciation.
- **Tactile Feedback**: Haptics and dynamic theming for a premium feel.

👉 **[View Full Features Specification](guides/FEATURES.md)**

---

## 📂 Project Structure

The project follows a modular architecture using **Riverpod** for state management and **Hive** for fast local persistence.

```text
lib/
├── config/       # App constants, UI strings, and debug configurations.
├── games/        # Physics-based game engines (Bubble Pop, Word Games).
├── models/       # Type-safe data models (Journey, Lesson, Progress, Avatar).
├── providers/    # Riverpod providers for State and Logic orchestration.
├── repositories/ # Data persistence layer and JSON content loading.
├── screens/      # High-level UI screens (Splash, Intro, Journey, Settings).
├── services/     # Cross-cutting concerns (Audio, Haptics, Navigation).
├── tools/        # Admin utilities, Tracing Recorders, and Content Debuggers.
├── utils/        # Global helper functions and extensions.
└── widgets/      # Atomic UI components, Animations, and Themed Layouts.

guides/           # Project documentation, specifications, and release guides.
```

---

## 📄 Documentation & Marketing Generation

This repository includes a suite of command-line tools to maintain the curriculum and generate high-fidelity marketing materials.

### 📊 Curriculum Overview
The `guides/CURRICULUM.md` file tracks all lessons and tasks. To refresh it based on the current JSON content:
```bash
dart tools/generate_curriculum.dart
```

### 🔊 Content Audio Generation
To ensure 100% reliability across all devices, the app can use pre-recorded audio snippets instead of relying on the system TTS engine. To generate audio for all current lessons:
```bash
dart tools/generate_audio.dart
```
To generate audio for specific lessons only, provide the lesson IDs as arguments:
```bash
dart tools/generate_audio.dart lesson_tracing lesson_spelling
```
This script will scan your JSON content and download missing `.mp3` files to `assets/audio/lessons/`, organized by lesson and shared common folders for efficient reuse.

### 📄 Brochure PDF Generation
Generate professional, multi-page brochures and one-pagers that highlight the app features and curriculum.

#### Requirements
- **Google Chrome** (or Chromium): The tool uses a headless Chrome instance to render HTML/CSS templates into high-quality PDFs.
- **Data Dependencies**: Ensure `assets/data/brochure_content.json` and the stylesheet `tools/style.css` are present.

#### Usage
- **Generate Full Brochure & Flyer**:
  ```bash
  dart tools/generate_brochure.dart
  ```
- **Generate Specific Items**:
  ```bash
  dart tools/generate_brochure.dart --full   # Just the premium brochure
  dart tools/generate_brochure.dart --flyer  # Just the one-page flyer
  ```
The generated PDFs will be located in the `exports/` directory.

---

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**: [Install Flutter](https://docs.flutter.dev/get-started/install) (latest stable version).
- **Environment**: Android Studio (with Flutter plugin) or VS Code.
- **Chrome**: Required for generating PDF marketing materials.

### Installation & Setup

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd gnps_learning_hub
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Generate Type-safe Adapters**:
   The project uses Hive for persistence. If you have modified any models, generate the required TypeAdapters:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Prepare Curriculum Data**:
   Ensure the curriculum manifest and documentation are up-to-date with the latest content:
   ```bash
   dart tools/generate_curriculum.dart
   ```

### Running the App

1. **Start an Emulator or Connect a Device**:
   - Launch an Android Emulator via Android Studio.
   - Or connect a physical Android/iOS device.

2. **Launch the app**:
   ```bash
   flutter run
   ```
   *Note: Use `flutter run --release` for a smoother experience when testing the 3D physics bubble pop engine.*


### 🛠 Developer Tools
To unlock developer mode in the app, navigate to **Settings**, tap the **App Version** 10 times, and enter the secret unlock code.

---

## 🎨 Assets
- **Logo**: `assets/logo/logo.jpg`
- **Avatars**: `assets/avatars/`
- **Audio**: `assets/audio/` (Lessons)
- **Sounds**: `assets/sounds/` (SFX)

---

Developed with ❤️ for GNPS.
