# 📱 Task List (CRUD) Flutter App

A minimal Flutter application for **creating, viewing, editing, and deleting tasks (CRUD)**. This project is suitable as a learning example to understand basic state management and list handling in Flutter.

---

## ✨ Features

* ➕ Add a task (via **Add** button or Enter)
* 📖 Display a list of tasks
* ✏️ Edit a task through a dialog window
* ❌ Delete a task with confirmation

---

## 🧱 Components Used

* `StatefulWidget` — state management
* `TextField` — task input
* `ListView.builder` — display list of tasks

---

## 📂 Project Structure

```
lib/
 └── main.dart   # main application code
pubspec.yaml     # dependencies
```

---

## 🚀 How to Run

> Flutter SDK must be installed

### 1. Clone the project

```bash
git clone https://github.com/Pavel-Zinkevich/crud_flutter.git
cd crud_flutter
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run the app

```bash
flutter run
```

---

## 🎯 Purpose of the Project

This project was created to:

* Practice Flutter development
* Understand CRUD operations
* Work with user input and lists

---

## ⚠️ Limitations

* Data **is saved** between app launches using `shared_preferences` (local key-value storage).

💡 Possible improvements:

* Migrate to a structured local DB (e.g., SQLite / `sqflite`) for richer queries and relations.
* Add export/import or cloud sync for cross-device persistence.

---

## 📸 Screenshots

<img width="413" height="901" alt="App Screenshot 1" src="https://github.com/user-attachments/assets/b691b962-7bc4-44b8-b2ac-33691ef297b6" />
<img width="999" height="710" alt="App Screenshot 2" src="https://github.com/user-attachments/assets/2d4fe55d-f309-4c0b-9fb5-c126e26e10aa" />

---

## 👨‍💻 Author

**Pavel Zinkevich**
[https://github.com/Pavel-Zinkevich](https://github.com/Pavel-Zinkevich)

---

⭐ If this project was helpful — give it a star!
