# Nayza Vocab 🔱

[![Flutter](https://img.shields.io/badge/Flutter-v3.22+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-v3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-FDD835?style=for-the-badge&logo=opensourceinitiative&logoColor=black)](https://opensource.org/licenses/MIT)

**Nayza Vocab** — Xorijiy tillarni (Ingliz, Arab, Rus va boshqa) o'rganuvchilar uchun yaratilgan, Spaced Repetition (interval takrorlash) va Cloud kutubxonasiga ega zamonaviy lug'at platformasi. Nayzadek o'tkir xotira va tezkor so'z yodlash! 🔱🚀

---

## ✨ Asosiy Imkoniyatlar (Key Features)

- ☁️ **Nayza Cloud Kutubxonasi**: Supabase orqali tayyor kitoblar, mavzulashtirilgan to'plamlar va unitlarni to'g'ridan-to'g'ri qurilmaga yuklab olish.
- 🚀 **Native In-App Updater (OTA)**: GitHub Releases bilan to'liq integratsiya qilingan avtomatik yangilanish tizimi. Ilovadan chiqmasdan yangi versiyalarni yuklab o'rnatish.
- 🔊 **Moslashuvchan Talaffuz (TTS & Speed Control)**: So'zlarning to'g'ri talaffuzini tinglash va talaffuz tezligini sozlash (Sekin 0.35x, O'rtacha 0.5x, Tez 0.65x).
- 🧠 **Smart Spaced Repetition & Virtual Units**: Katta hajmdagi lug'atlarni avtomatik 15 talik qulay darslarga (Virtual Sets) ajratish va qiyin so'zlarni aqlli takrorlash.
- 🎓 **Interaktiv Testlar (Smart Quizzes)**: Unikal variantlar, chalg'ituvchi distraktorlar va natijalar statistikasi.
- 🌍 **Ko'p tillilik (Internationalization - i18n)**: 6 ta tilda to'liq interfeys (O'zbek, English, Русский, Deutsch, العربية, 한국어).
- 🛠️ **Offline-First**: Barcha ma'lumotlar Hive (NoSQL) bazasida mahalliy xavfsiz saqlanadi, internet bo'lmaganda ham 100% ishlaydi.
- 💎 **Premium Dark Theme**: Ergonomik Navy & Gold ranglar palitrasi, micro-animatsiyalar va haptik aloqa (vibratsiya).

---

## 🛠 Texnologiyalar (Tech Stack)

| Yo'nalish | Texnologiya |
| :--- | :--- |
| **Framework** | Flutter (Material 3, Clean Architecture) |
| **Dasturlash tili** | Dart |
| **State Management** | Provider |
| **Lokal Baza** | Hive (NoSQL, Typed Adapters) |
| **Cloud Backend** | Supabase (PostgreSQL & Storage) |
| **Audio & TTS** | Audioplayers & Flutter TTS |
| **Routing** | GoRouter (Deep-linking & Preserved Navigation Stack) |
| **Lokalizatsiya** | Flutter Gen-l10n (ARB) |

---

## 🏛️ Arxitektura (Clean Architecture)

Loyiha qat'iy modulli arxitektura va kod tozaligi qoidalariga rioya qiladi:
- Har bir `.dart` fayli maksimal 200 qatordan oshmaydi.
- UI, Data va Domain qatlamlari to'liq ajratilgan:
```text
lib/
├── core/                        # Umumiy xizmatlar (OTA, Theme, Audio, Localization)
└── features/
    ├── vocabulary/              # Lug'at, testlar va kitoblar
    ├── settings/                # Sozlamalar va audio tezligi
    └── navigation/              # Asosiy ekran va marshrutlash
```

---

## 🚀 O'rnatish va Ishga Tushirish (Getting Started)

1. **Repozitoriyani klonlang:**
   ```bash
   git clone https://github.com/ismaaiiyl/NayzaVocab.git
   cd NayzaVocab
   ```

2. **Bog'liqliklarni yuklang:**
   ```bash
   flutter pub get
   ```

3. **Muhit sozlamalarini tayyorlang:**
   `.env.example` dan `.env` fayl nusxasini yarating va Supabase ma'lumotlarini kiriting:
   ```bash
   cp .env.example .env
   ```

4. **Testlarni tekshirish:**
   ```bash
   flutter analyze
   flutter test
   ```

5. **Ilovani ishga tushirish:**
   ```bash
   flutter run
   ```

---

## 🔱 Muallif (Author)

**Ismoil** ([@ismaaiiyl](https://github.com/ismaaiiyl))  
*Flutter Developer & Creator of NayzaVocab* 🔱  
- GitHub: [github.com/ismaaiiyl](https://github.com/ismaaiiyl)  
- Aloqa / Email: [ismaaiiyl@gmail.com](mailto:ismaaiiyl@gmail.com)

---

## 📄 Litsenziya (License)

Ushbu loyiha [MIT License](LICENSE) ostida tarqatiladi. Shaxsiy va ochiq loyihalarda erkin foydalanishingiz mumkin.
