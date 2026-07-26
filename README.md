# GNPS Learning Hub

**GNPS Learning Hub** is a gamified Punjabi learning application designed specifically for kids. It combines a structured curriculum with engaging game mechanics like streaks, gems, and avatar customization to make language learning an adventure.

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com/)

---

## ✨ Key Features

- **Interactive Punjabi Lessons**: Short, engaging lessons covering vocabulary, spelling, and sentence structure.
- **Gamified Progress**: Earn gems, build daily streaks, and unlock achievements.
- **Customizable Avatars**: Create and personalize your own character in the shop.
- **Goal Setting**: Choose your own learning pace with customizable daily goals.
- **Audio Support**: Integrated Text-to-Speech for correct Punjabi pronunciation.

👉 **[View Detailed Features List](FEATURES.md)**

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Android Studio / VS Code
- Firebase account (optional for local development)

### Installation

1.  **Clone the repository:**
    ```bash
    git clone <repository-url>
    cd gnps_learning_hub
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the app:**
    ```bash
    flutter run
    ```

---

## 🛠 Tech Stack

- **Framework**: [Flutter](https://flutter.dev)
- **State Management**: [Riverpod](https://riverpod.dev)
- **Local Database**: [Hive](https://docs.hivedb.dev/)
- **Backend**: [Firebase Firestore](https://firebase.google.com/docs/firestore) (Optional)
- **Audio**: `audioplayers` & `flutter_tts`
- **Graphics**: `flutter_svg`

---

## 📂 Project Structure

```text
lib/
├── config/       # App configurations and constants
├── data/         # Mock data and initial assets
├── models/       # Data models (Lesson, Task, Progress, etc.)
├── providers/    # Riverpod state providers
├── repositories/ # Data access layer (Hive/Firestore)
├── screens/      # UI Screens (Journey, Shop, Profile, etc.)
├── services/     # External services (Audio, TTS)
└── widgets/      # Reusable UI components
```

---

## 🔧 Configuration

### Firebase (Optional)
The app is designed to work with mock data if Firebase is not configured. To enable Firebase:
1.  Run `flutterfire configure`.
2.  Uncomment the import and options in `lib/main.dart`.

### Local Storage
User progress and shop items are stored locally using Hive for a seamless offline experience.

---

## 🎨 Assets
- **Logo**: `assets/logo/logo.jpg`
- **Avatars**: `assets/avatars/`
- **Sounds**: `assets/sounds/`

---

Developed with ❤️ for GNPS.
