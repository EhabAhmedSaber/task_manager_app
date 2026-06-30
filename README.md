# 📝 Task Manager Mobile Application

A professional, high-performance, and minimalist Task Manager mobile application built with **Flutter**. The app follows production-ready standards, featuring clean architecture, offline first capability, and full unit/bloc testing.

---

## ✨ Features
- **Task & Project Management:** Create, read, update, and delete (CRUD) tasks and projects efficiently.
- **Interactive Onboarding:** Smooth dynamic onboarding experience that tracks first-time users using SharedPreferences.
- **Dark Mode Aesthetic:** Premium high-quality user interface supporting system theme adaptation with a sleek dark mode.
- **Offline Support (Caching):** Full offline functionality and local persistence using Hive database and SharedPreferences.
- **Secure Networking:** Pre-configured with Dio for robust REST API requests and automated interceptors.
- **Robust State Management:** Clean separation of business logic from UI using Bloc/Cubit.

---

## 📸 Screenshots
| Onboarding1 Screen | Onboarding2 Screen |  Login Screen | Projects Dashboard |
| :---: | :---: | :---: |
| <img src="assets\images\onboarding1.jpg" width="200"/> | <img src="assets\images\signin.jpg" width="200"/> | <img src="assets\images\projects.jpg" width="200"/> |

---

## 🏗️ Architecture & Project Structure
The project strictly adheres to **Clean Architecture** combined with **Feature-first pattern** to ensure scalability, maintainability, and testability.

### Layers:
1. **Data Layer:** Responsible for local storage management (Hive), data models, and repository implementations.
2. **Domain Layer:** Contains the core business rules (Entities, Repository Interfaces, and Use Cases).
3. **Presentation Layer:** Handles UI rendering and state management using the **Bloc/Cubit** pattern.

---

## 🛠️ Tech Stack & Libraries
- **State Management:** flutter_bloc / bloc for predictable state changes.
- **Local Database:** Hive & Hive_flutter for ultra-fast, lightweight local caching.
- **Dependency Injection:** get_it for clean service location.
- **App Icon Generator:** flutter_launcher_icons.
- **Testing:** bloc_test and mocktail for robust testing behavior.

---

## 🧪 Testing
The application includes comprehensive tests to verify the core business logic and state transitions:
- **Bloc Tests:** Verified using bloc_test to ensure precise state flows upon user events.
- **Unit Tests:** Mocked data layers using mocktail to guarantee repository reliability.

To run all tests and verify the code health, use the command: flutter test

---

## 📦 Deployment and APK Generation

The release build has been optimized utilizing the split-per-abi feature to dramatically reduce the APK size and optimize performance across different CPU architectures.

### Build Command:
flutter build apk --split-per-abi

### Output Artifacts:
You can locate the production-ready APK in the following path: build/app/outputs/flutter-apk/

- **app-arm64-v8a-release.apk (Recommended):** Highly optimized and extremely lightweight (approx. 10-15 MB), targeting 95% of modern Android devices.
- **app-armeabi-v7a-release.apk:** Tailored for older legacy Android devices.
## 🚀 How To Run the Project
Follow these simple steps to set up and run the application locally:

- **Clone the repository:**
   ```bash
   git clone [https://github.com/EhabAhmedSaber/task_manager_app](https://github.com/EhabAhmedSaber/task_manager_app)
 
