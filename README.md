# 🐦 Kaigin Pet

A virtual self-care companion app inspired by [Finch](https://finchcare.com/). Take care of your bird by completing daily goals, journaling your mood, and leveling up together.

Built with Flutter using **Clean Architecture** and **BLoC** state management.

---

## ✨ Features

- **Pet Home** — Your bird companion reacts to your daily progress. Its mood and appearance change based on how many goals you've completed.
- **Daily Goals** — Set and complete personal goals across 5 categories: Health, Mind, Social, Creative, and Learning. Each goal rewards XP.
- **XP & Leveling** — Earn XP by completing goals. Your bird levels up as you grow.
- **Journal** — Write daily entries and track your mood over time.
- **Profile & Stats** — View your total XP, completed goals, and current level.
- **Theme** — Light, Dark, and System theme support.
- **Localization** — 8 languages: English, Vietnamese, Japanese, Chinese, Korean, French, Spanish, Portuguese.

---

## 📦 Tech Stack

| Category | Package | Version |
|---|---|---|
| State Management | [flutter_bloc](https://pub.dev/packages/flutter_bloc) | ^9.1.1 |
| Navigation | [go_router](https://pub.dev/packages/go_router) | ^17.0.1 |
| Local Storage | [shared_preferences](https://pub.dev/packages/shared_preferences) | ^2.3.2 |
| Localization | [easy_localization](https://pub.dev/packages/easy_localization) | ^3.0.7 |
| Dependency Injection | [get_it](https://pub.dev/packages/get_it) + [injectable](https://pub.dev/packages/injectable) | ^9.2.0 / ^2.7.1 |
| Fonts | [google_fonts](https://pub.dev/packages/google_fonts) | ^6.3.3 |
| Code Generation | [json_serializable](https://pub.dev/packages/json_serializable) + [build_runner](https://pub.dev/packages/build_runner) | ^6.9.0 / ^2.6.0 |

---

## 🏗 Architecture

Clean Architecture with 3 layers:

```
lib/
├── domain/             # Business logic (no Flutter dependencies)
│   ├── entities/       # Pet, Goal, JournalEntry
│   ├── repositories/   # Abstract interfaces
│   └── use_cases/      # One use case per action
│
├── data/               # Data sources and repository implementations
│   ├── datasources/    # SharedPreferences local storage
│   ├── models/         # JSON-serializable DTOs
│   └── repositories/   # Concrete repository implementations
│
├── presentation/       # UI layer
│   ├── features/       # Screens grouped by feature
│   │   ├── pet/        # Pet home screen + PetCubit
│   │   ├── goals/      # Goals screen + GoalsCubit
│   │   ├── journal/    # Journal screen + JournalCubit
│   │   └── profile/    # Profile + settings
│   ├── router/         # GoRouter configuration
│   └── theme/          # App theme + ThemeCubit
│
└── infrastructure/     # DI setup, constants, app-wide config
```

State is managed with Cubits (`PetCubit`, `GoalsCubit`, `JournalCubit`, `ThemeCubit`). Both `PetCubit` and `GoalsCubit` are provided at the shell level (`MainHomeScreen`) so that completing a goal immediately updates the bird's mood and XP bar on the Home tab.

---

## 🚀 Getting Started

> **Prerequisite:** This project uses [FVM](https://fvm.app/). Install FVM or replace `fvm flutter` with `flutter` in all commands.

### Setup

```bash
# Install dependencies, generate code (DI, JSON, localization)
make

# Or step by step:
make pub_get       # flutter pub get
make build_runner  # json_serializable + injectable
make l10n          # easy_localization codegen
```

### Run

```bash
fvm flutter run
```

### Build

```bash
fvm flutter build apk --release      # Android
fvm flutter build ipa --release      # iOS
```

---

## 🌍 Localization

Translation files live in `assets/translations/`. To add a new language:

1. Copy `en-US.json` and rename it (e.g. `de-DE.json`)
2. Translate all values
3. Add the locale to `LocaleConstants.all` in `lib/infrastructure/constants/locale_constants.dart`
4. Run `make l10n` to regenerate codegen files

---

## 🧪 Testing

```bash
fvm flutter test
```

---

## 📱 Supported Platforms

- iOS 12+
- Android 5.0+ (API 21)
