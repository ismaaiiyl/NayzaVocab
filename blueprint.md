# Blueprint: Nayza Vocab (v1.0 - Perfect)

## 1. Loyiha Haqida Umumiy Ma'lumot

**Maqsad:** Foydalanuvchilarga o'zlari uchun lug'at to'plamlarini ("Vocabulary Sets") yaratish, ularga so'zlar qo'shish va ularni o'rganish uchun qulay, zamonaviy va "perfect" mobil ilova yaratish. Ilova lokal ma'lumotlar bazasi (`Hive`) yordamida ishlaydi va barcha ma'lumotlarni qurilmaning o'zida saqlaydi.

## 2. Amalga Oshirilgan Ishlar va Dizayn Qarorlari

### Arxitektura va Texnologiyalar:
- **Platforma:** Flutter
- **Lokal baza:** `Hive` (tezkor va offline ishlash uchun)
- **Holat boshqaruvi (State Management):** `Provider` (samarali va tushunarli)
- **Noyob ID generatsiyasi:** `uuid`
- **Shriftlar:** `google_fonts` (professional tipografika uchun)
- **Ikonkalar:** `lucide_icons` (zamonaviy va toza ikonografiya uchun)
- **Formatlash:** `intl` (sanalarni chiroyli formatda ko'rsatish uchun)

### Asosiy Funksionallik (CRUD - Hammasi "Perfect"):
- **So'z va To'plam Yaratish (Create):** `CreateSetScreen` orqali yangi to'plam va unga tegishli so'zlar yaratiladi.
- **Ma'lumotlarni O'qish (Read):** `HistoryScreen`da barcha to'plamlar, `SetDetailsScreen`da esa tanlangan to'plamning barcha so'zlari aks ettiriladi.
- **Ma'lumotlarni Yangilash (Update):**
  - `SetDetailsScreen`da, "Edit" rejimida, so'zlarni tahrirlash uchun qulay dialog oynasi (`_showEditOrAddWordDialog`) ochiladi.
  - Bu metod universal bo'lib, ham tahrirlash, ham yangi so'z qo'shish uchun ishlatiladi (DRY prinsipi).
- **Ma'lumotlarni O'chirish (Delete):**
  - `SetDetailsScreen`da, "Edit" rejimida, so'zni o'chirishdan oldin foydalanuvchidan tasdiq so'raydigan xavfsizlik dialogi (`_showDeleteConfirmationDialog`) chiqariladi.

### Dizayn va UX ("Bold Definition")
- **Dizayn Sistemasi (`ThemeData`):**
  - Barcha dizayn qoidalari (`ranglar`, `shriftlar`, `tugmalar`, `kartalar` uslubi) `main.dart` ichidagi yagona `ThemeData` orqali boshqariladi. Bu "senior level" yondashuv bo'lib, ilova bo'ylab dizaynning bir xilligini ta'minlaydi.
- **Tipografika:**
  - **Sarlavhalar:** `Bebas Neue` - kuchli, diqqatni tortuvchi shrift.
  - **Asosiy matn:** `Roboto` - o'qishga oson, zamonaviy va universal shrift.
  - Matnlar orasida vizual ierarxiya yaratilgan (kattaroq sarlavhalar, kichikroq tavsiflar).
- **Ranglar Palitrasi:**
  - **Asosiy rang:** `Electric Gold` (#FFD700) - tugmalar, aktiv elementlar va diqqatni tortuvchi qismlar uchun.
  - **Fon:** `Clean White-ish` (#F5F5F7) - ko'zga yoqimli va toza ko'rinish uchun.
  - **Matn:** Qora va kulrangning turli tuslari - o'qilishi oson va ierarxik.
- **Komponentlar Stili:**
  - **Kartalar (`Card`):** Yumshoq, ko'tarilgan effekt beruvchi soyalar va yumaloq burchaklar bilan zamonaviy ko'rinishga keltirilgan.
  - **Tugmalar (`Button`):** `Electric Gold` rangi va aniq shakllar bilan foydalanuvchini harakatga undaydi.
  - **Dialog Oynalari:** Uslubi umumiy temaga moslashtirilgan.
- **Ikonografiya:**
  - Standart `Material Icons` o'rniga zamonaviy va minimalist `LucideIcons` to'plami ishlatildi.
- **Bo'sh Holat (Empty State):**
  - `HistoryScreen`da hali hech qanday to'plam yaratilmagan bo'lsa, foydalanuvchiga nima qilish kerakligini tushuntiruvchi chiroyli va informativ ekran ko'rsatiladi.

## 4. Yakuniy Natija

Ilova sizning talablaringizga binoan to'liq **"perfect"** holatga keltirildi. U nafaqat funksional jihatdan to'liq, balki zamonaviy dizayn tamoyillariga javob beradigan, toza va kengaytirishga oson bo'lgan kod bazasiga ega.

**Loyihaning keyingi mumkin bo'lgan rivojlanish yo'nalishlari:**
- Ovozli talaffuz (TTS) funksiyasini qo'shish.
- To'plamlarni "swipe" qilib o'chirish.
- Bulutli sinxronizatsiya (masalan, Firebase orqali).
- Testlar va o'yinlar (Quiz/Flashcards).