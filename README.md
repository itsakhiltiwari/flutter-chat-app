# Flutter Firebase Chat App

A real-time, production-grade chat application built with Flutter and Firebase. This project demonstrates modern app development practices, including Clean Architecture, state management with Provider, and a full suite of real-time chat features.

## ✨ Features

- **User Authentication**: Secure sign-up and login using Firebase Authentication (Email/Password).
- **Real-time Messaging**: Send and receive messages instantly, powered by Cloud Firestore.
- **User Discovery**: View a list of all registered users to initiate conversations.
- **Classic Chat UI**: Messages are displayed in colored chat bubbles, aligned left for received and right for sent messages.
- **Message Management (CRUD)**:
  - **Create**: Send new text messages.
  - **Read**: View conversation history in real-time.
  - **Update**: Long-press a message to edit it.
  - **Delete**: Long-press a message to delete it.
- **State Management**: Efficiently manages app state using the `provider` package.
- **Error Handling**: Gracefully handles common issues like network errors and failed server requests.

## 🏛️ App Architecture

This project is built using the principles of **Clean Architecture**. This approach separates the code into distinct layers, making it easier to manage, scale, and test.

```bash
+---------------------------------------------------+
| Presentation Layer |
| (UI: Widgets, Pages, State Management: Provider) |
+---------------------------------------------------+
^
| (Depends on Domain)
v
+---------------------------------------------------+
| Domain Layer |
| (Business Logic: Entities, Repositories, Usecases)|
+---------------------------------------------------+
^
| (Depends on Data)
v
+---------------------------------------------------+
| Data Layer |
| (Data Sources: Firebase API, Caching, Models) |
+---------------------------------------------------+
```

- **Presentation Layer**: Contains all the UI elements (Widgets, Pages) and state management logic (Providers). It is responsible for displaying data and handling user interactions.
- **Domain Layer**: This is the core of the application. It contains the business logic, defining entities (like `UserEntity`) and repository contracts (abstract classes). This layer is independent of any framework.
- **Data Layer**: Responsible for all data operations. It implements the repository contracts from the Domain layer and handles communication with data sources like Firebase.

## 🚀 Tech Stack & Packages

- **Framework**: Flutter
- **Backend**: Firebase (Authentication, Cloud Firestore)
- **State Management**: `provider`
- **Functional Programming**: `dartz` for handling failures and exceptions.
- **Value Equality**: `equatable`
- **Dependency Injection (Bonus)**: `get_it`
- **Date Formatting**: `intl`

## ⚙️ Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.0.0 or higher)
- [Android Studio](https://developer.android.com/studio) or [Visual Studio Code](https://code.visualstudio.com/)
- An Android Emulator or a physical device

### Firebase Setup

1.  **Create a Firebase Project**: Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project.
2.  **Register Your App**:
    - Inside your project, click the Android icon to add an Android app.
    - Use `com.example.flutter_chat_app` as the package name (or update it in `android/app/build.gradle` if you use a different one).
    - Download the `google-services.json` file and place it in the `android/app/` directory.
3.  **Enable Authentication**:
    - In the Firebase console, navigate to **Authentication** -> **Sign-in method**.
    - Click on **Email/Password** and enable it.
4.  **Set up Firestore**:
    - Navigate to **Cloud Firestore** and create a database in **Test Mode** for initial setup.
    - Go to the **Rules** tab and paste the following rules for basic security:
      ```json
      rules_version = '2';
      service cloud.firestore {
        match /databases/{database}/documents {
          match /{document=**} {
            allow read, write: if request.auth != null;
          }
        }
      }
      ```

### Installation & Running

1.  **Clone the repository**:
    ```sh
    git clone <YOUR_REPOSITORY_URL>
    cd flutter_chat_app
    ```
2.  **Install dependencies**:
    ```sh
    flutter pub get
    ```
3.  **Run the app**:
    - Make sure an emulator is running or a device is connected.
    - Run the application using the command:
    ```sh
    flutter run
    ```

## 📁 Project Structure

The code is organized within the `lib` folder, following a feature-first approach with Clean Architecture layers.

```bash
/lib
|-- core/ # Shared logic, error handling, usecases
|-- features/
| |-- auth/ # Authentication feature
| | |-- data/
| | |-- domain/
| | `-- presentation/
|   |
|   `-- chat/ # Chat feature
| |-- data/
| |-- domain/
| `-- presentation/
|
|-- main.dart # App entry point
```
