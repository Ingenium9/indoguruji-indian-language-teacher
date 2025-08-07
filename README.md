# 🧠 IndoGuruji – Indian Language Teacher

**IndoGuruji** is a cross-platform, AI-powered language learning application designed to teach Indian regional languages through a highly interactive, gamified, and audio-visual based curriculum. Built using **Flutter** for the mobile frontend and **Python (Django REST Framework)** for the backend API, the application supports multilingual learning with features such as OTP authentication, speech recognition, and text-to-speech.

---

## 🌟 Features

- 🔤 Learn Indian languages via characters → words → sentences
- 📢 Text-to-speech for native pronunciation and speech practice
- 🧠 Interactive lessons with quizzes, audio matching, translations
- 🔐 OTP-based authentication using Firebase
- 📈 Streaks and gamified learning modules for motivation
- 🧠 Speech-to-text and reverse translation exercises
- 💾 Local DB storage using SQLite
- 🎯 Multilingual: Hindi, Marathi, Tamil, Telugu, Kannada, etc.

---

## 🧰 Tech Stack

| Layer     | Technology                      |
| --------- | ------------------------------- |
| Frontend  | Flutter (Dart)                  |
| Backend   | Django REST Framework (Python)  |
| Database  | SQLite                          |
| Auth      | Firebase OTP                    |
| NLP/TTS   | Google Text-to-Speech, STT APIs |
| Dev Tools | Android Studio, VS Code, Figma  |

---

## 📂 Project Directory Structure

```
indoguruji-indian-language-teacher/
├── indian-language-teacher-client/         # Flutter frontend app
│   ├── android/
│   ├── ios/
│   ├── lib/
│   ├── assets/
│   ├── test/
│   ├── web/
│   ├── pubspec.yaml
│   └── README.md
│
├── indian-language-teacher-server/         # Django backend API
│   ├── ILT/
│   ├── myproject/
│   ├── requirements.txt
│   └── README.md
```

---

## 🚀 Getting Started

### 🔧 1. Clone the Repository

```bash
git clone https://github.com/your-username/indoguruji-indian-language-teacher.git
cd indoguruji-indian-language-teacher
```

---

## 📱 Setting Up Flutter Frontend

### 🛠 Prerequisites

- Flutter SDK installed
- Android Studio / VS Code

### ▶️ Run the App

```bash
cd indian-language-teacher-client
flutter pub get
flutter run
```

---

## 🖥️ Setting Up Django Backend

### 🛠 Prerequisites

- Python 3.10+
- pip, virtualenv

### ▶️ Run the Server

```bash
cd indian-language-teacher-server
python -m venv venv
source venv/bin/activate  # On Windows use `venv\\Scripts\\activate`
pip install -r requirements.txt
python manage.py runserver
```

---

## 📚 Research Paper Insights

### 🔎 Review of Language Learning Applications

This paper presents a detailed critique of leading commercial language learning apps like Duolingo, Mondly, and Memrise. It identifies core gaps in current applications:

- Focus mostly on **vocabulary drills** instead of real-life conversational context
- Minimal **adaptive learning** or customization to user proficiency levels
- Rarely provide **explanatory corrective feedback**
- Heavy use of **behaviorist methods** (repetition, memorization) with limited communicative language learning

The paper argues for the need for apps that are **contextual**, **communicative**, and **adaptive**, especially to better support Indian language learning.

---

### 🔬 IndoGuruji Research Paper

The **ILT Research Paper** introduces IndoGuruji, a custom-built mobile-first solution to teach Indian regional languages with the following innovations:

- Structured learning path from **characters → words → sentences**
- Support for **speech-to-text**, **text-to-speech**, and **voice-based quizzes**
- Developed using **Flutter (UI)** and **Django REST API (Backend)**
- OTP-based login via Firebase
- Built-in **gamification modules** to enhance engagement and retention

The paper outlines the pedagogical motivation behind IndoGuruji and highlights its ability to fill the gap left by current global language learning tools, particularly for underrepresented Indian languages.

---

## 📌 Future Improvements

- User profiles & history tracking
- Progress sync to cloud
- Real-time pronunciation feedback via AI
- Localization & UI translation for multi-language support
