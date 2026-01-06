# 🌿 Eco Mobile Project

A Flutter-based mobile application designed to raise awareness about environmental issues through interactive games, educational content, and eco-friendly challenges. This project combines gamification with education to encourage sustainable habits.

## 🚀 Features

### 🎮 Educational Games
Engage in distinct mini-games built with the **Flame** engine to learn about environmental protection:
- **Level 1: City Challenge:** Sort trash into correct bins (Plastic, Paper, Glass, Metal) to keep the city clean.
- **Level 2: Climate Combat:** Fight pollution clouds to protect the atmosphere.
- **Level 3: Eco Hero:** Complete daily environmental tasks.
- **Level 4: Water Cleanup:** Navigate a boat to clean up the ocean, collect trash, and save wildlife!

### 📊 Dashboard & Progress
- Track your scores and progress across different games.
- View your impact and achievements.

### 💬 Smart Eco Chat
- **Simulated AI Chatbot:** Talk to a smart, bilingual (English/Arabic) bot.
- **No API Key Required:** Runs 100% locally on your device.
- **Knowledgeable:** Ask about recycling, climate change, energy tips, and more!

### 🔐 Multi-Language Support
- Fully localized in **English** and **Arabic** (العربية).
- Seamless language switching to cater to a broader audience.

### 🔑 Authentication
- Secure user authentication powered by **Firebase Auth**.
- Save your game progress and preferences across sessions.

---

## 🛠️ Technologies Used

*   **[Flutter](https://flutter.dev/)** - UI Toolkit for building beautiful, natively compiled applications.
*   **[Flame](https://flame-engine.org/)** - Game engine for Flutter.
*   **[Firebase](https://firebase.google.com/)** - Backend-as-a-Service for Auth and Database.
    *   Firebase Auth
    *   Cloud Firestore
*   **Provider** - State management.
*   **Intl** - Internationalization and localization.
*   **Google Fonts** - Typography.

---

## 📂 Project Structure

```
lib/
├── core/            # Core utilities, theme configurations
├── features/        # Feature-based modules
│   ├── auth/        # Authentication screens and logic
│   ├── chat/        # Chat functionality
│   ├── dashboard/   # Main dashboard UI
│   └── games/       # Game modules (Eco Hero, Climate Combat, etc.)
├── l10n/            # Localization files (.arb)
└── main.dart        # App entry point
```

---

## 🏁 Getting Started

### Prerequisites
- **Flutter SDK** (Version 3.9.2 or higher)
- **Dart SDK**
- An active **Firebase Project**

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/yourusername/projet_mobile.git
    cd projet_mobile
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Firebase Setup:**
    - Create a project on the [Firebase Console](https://console.firebase.google.com/).
    - Add an Android/iOS app to your project.
    - Download the `google-services.json` (for Android) or `GoogleService-Info.plist` (for iOS).
    - Place the configuration files in `android/app/` or `ios/Runner/`, respectively.

4.  **Run the app:**
    ```bash
    flutter run
    ```

---

## 📸 Screenshots

| Dashboard | Game Play | Chat Screen |
|:---:|:---:|:---:|
| ![Dashboard](assets/images/dashboard_placeholder.png) | ![Game](assets/images/game_placeholder.png) | ![Chat](assets/images/chat_placeholder.png) |

*(Note: Add your actual screenshots in the `assets/images` folder)*

---

## 🤝 Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any improvements or bug fixes.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
