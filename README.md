# 🎉 EvenHub — your event companion

<div align="center">

🔔 **Discover, explore and save the best events around you.**  
One app — from onboarding to sharing with friends.

</div>

---

## ✨ Features

<div align="center">

| 👋 **Onboarding** | 🔑 **Sign In / Sign Up** | 🗺️ **Explore** | 📌 **Event Details** |
|:---:|:---:|:---:|:---:|
| First-time intro | Email & Google login | Search & filter | Time, place, description |
| Shown only once | "Remember me" option | City selector | Add to favorites / share |
| Smooth UX | Password reset flow | Nearby events | Rich media content |

| ⭐ **Favorites** | 🗂️ **Categories** | 📅 **Events List** | 👤 **Profile** |
|:---:|:---:|:---:|:---:|
| Save & organize | From API with icons | Upcoming & past | Avatar, edit, logout |
| Filter & search | Dynamic loading | Explore all events | Clean UI |

</div>

---

## 🛠 Technologies

<div align="center">

<a href="https://swift.org">
<img src="https://img.shields.io/badge/Swift-5-orange?style=for-the-badge&logo=swift" alt="Swift 5"/></a>
<a href="https://developer.apple.com/ios/">
<img src="https://img.shields.io/badge/iOS-16+-black?style=for-the-badge&logo=apple" alt="iOS 16+"/></a>
<img src="https://img.shields.io/badge/UIKit-blue?style=for-the-badge" alt="UIKit"/>
<img src="https://img.shields.io/badge/MVVM-ff69b4?style=for-the-badge" alt="MVVM"/>
<img src="https://img.shields.io/badge/FirebaseAuth-red?style=for-the-badge" alt="Firebase Auth"/>
<img src="https://img.shields.io/badge/URLSession-green?style=for-the-badge" alt="URLSession"/>
<img src="https://img.shields.io/badge/JSONDecoder-yellow?style=for-the-badge" alt="JSONDecoder"/>
<img src="https://img.shields.io/badge/UserDefaults-gray?style=for-the-badge" alt="UserDefaults"/>

</div>

---

## 🚀 Getting started

### Requirements
- Xcode 15.0+
- iOS 16.0+
- macOS 13.0+

### Installation

    # Clone the repository
    git clone https://github.com/00giemensch/EvenHub.git

    # Open the project
    cd EvenHub
    open EvenHub.xcodeproj

(Запусти в симуляторе или на устройстве через Xcode)

### Configuration
- Подключите Firebase (Google Sign-In) — добавьте `GoogleService-Info.plist` в проект.
- Укажите URL и ключи API в `Config` или используйте xcconfig/.env по вашему выбору.
- Иконки категорий добавляются в `Assets` и сопоставляются с id категорий из API.

---

## 📡 API

<div align="center">
<a href="https://docs.kudago.com/api/#">
<img src="https://img.shields.io/badge/KudaGO_API-lightblue?style=for-the-badge&logo=api" alt="KudaGO API"/>
</a>
</div>

Рекомендуется добавить в `docs/` пример ответов API (endpoints, схемы), чтобы было проще интегрировать.

---

## 📁 App Flow (short)

- Onboarding — показывается при первом запуске.
- Sign In — Email/Password или Google (Firebase). "Remember me" — сохраняет состояние.
- Main (Tab Bar): Map (placeholder), Explore, Events, Favorites, Profile.
- Explore — поиск, фильтры, выбор города (API).
- Event Details — подробности события, добавление в избранное, шаринг.
- Share — модальное окно с кнопками популярных соцсетей/мессенджеров.
- Events — список ближайших 7 дней; фильтры: актуальные / прошедшие.
- Favorites — управление избранными событиями.
- Profile — редактирование и выход.

---

## 📸 Screens

Добавь GIF/PNG превью в `docs/screens/` и вставь так:

    ![Explore demo](docs/screens/ExploreDemo.gif)

---

## 👨‍💻 Contributors

<div align="center">
<a href="https://github.com/vasilev-evgeny"><img src="https://img.shields.io/badge/vasilev--evgeny-orange?style=for-the-badge" alt="vasilev-evgeny"/></a>
<a href="https://github.com/dr4gons1ayer01"><img src="https://img.shields.io/badge/dr4gons1ayer01-green?style=for-the-badge" alt="dr4gons1ayer01"/></a>
<a href="https://github.com/Ankor45"><img src="https://img.shields.io/badge/Ankor45-blue?style=for-the-badge" alt="Ankor45"/></a>
<a href="https://github.com/00giemensch"><img src="https://img.shields.io/badge/00giemensch-purple?style=for-the-badge" alt="00giemensch"/></a>
<a href="https://github.com/PilotBro"><img src="https://img.shields.io/badge/Nikita-cyan?style=for-the-badge" alt="PilotBro"/></a>
</div>

---

## 📄 License & Notes

© 2025 EvenHub — for educational / demo purposes.  
Репозиторий демонстрирует структуру приложения и основные потоки (onboarding, auth, explore, share). Для продакшн-использования обновите интеграции и дизайн.

---
