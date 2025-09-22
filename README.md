# P2P Tic-Tac-Toe with Flutter  బోర్

A fully functional, peer-to-peer multiplayer Tic-Tac-Toe game built with Flutter for Android. This project demonstrates how to create a local, server-less multiplayer experience using the `nearby_connections` package.



## ✨ Features

- ✅ **Real-time P2P Gameplay:** Moves on one device are reflected instantly on the other.
- ✅ **Server-less Connection:** Uses the Google Nearby Connections API (via a Flutter package) to connect devices directly using a combination of Wi-Fi and Bluetooth.
- ✅ **Device Discovery & Auto-Connection:** One player hosts ("advertises") a game, and the other discovers and connects automatically.
- ✅ **Clean Architecture:** The project separates UI (`screens`), business logic (`services`), and game state management for clarity and scalability.
- ✅ **Full Game Logic:** Includes turn management, win/loss detection, and a draw condition.

---

## 🛠️ Tech Stack

- **Framework:** Flutter 3.x
- **Language:** Dart
- **P2P Networking:** [`nearby_connections`](https://pub.dev/packages/nearby_connections) package
- **Permissions:** [`permission_handler`](https://pub.dev/packages/permission_handler) package

---

## 🚀 Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

- You must have the Flutter SDK installed on your machine.
- You will need two Android devices (or two Android Emulators) to test the P2P functionality.

### Installation & Running

1.  **Clone the repo**
    ```sh
    git clone [https://github.com/YOUR_USERNAME/tictactoe_p2p.git](https://github.com/YOUR_USERNAME/tictactoe_p2p.git)
    ```
2.  **Navigate to the project directory**
    ```sh
    cd tictactoe_p2p
    ```
3.  **Install dependencies**
    ```sh
    flutter pub get
    ```
4.  **Run the app**
    - Connect two Android devices or start two emulators.
    - Run the app on the first device:
      ```sh
      flutter run
      ```
    - Select the second device in your IDE (VS Code / Android Studio) and run the app on it as well.

---

## 🎮 How to Play

For the P2P connection to work, both devices must have **Wi-Fi or Bluetooth enabled**.

1.  **Open the App:** Both players open the app on their devices.
2.  **Player 1 (Host):** Taps the **Create Game** button.
    - They must **Allow** all the permissions requested by the app (Location, Nearby Devices, etc.).
    - Their screen will show a loading indicator as they wait for the other player.
3.  **Player 2 (Client):** Taps the **Join Game** button.
    - They must also **Allow** all the same permissions.
    - Their device will now search for Player 1's game.
4.  **Game Start!**
    - After a few moments, the devices will connect, and both will automatically be taken to the game screen.
    - Player 1 is **'X'** and gets the first turn. Player 2 is **'O'**.

---

## 📂 Project Structure

The project code is organized into a few key directories inside `lib/`:

```
lib/
├── main.dart               # App entry point
├── screens/                # UI for each screen
│   ├── game_screen.dart    # The Tic-Tac-Toe board and game UI
│   └── home_screen.dart    # The "Create/Join Game" menu
└── services/
    └── networking_service.dart # Handles all P2P logic
```

---

## 📜 License

This project is licensed under the MIT License - see the `LICENSE` file for details.
