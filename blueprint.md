# Blueprint: Nayza Vocab (v2.0 - Interaktiv Testlar)

## 1. Loyiha Haqida Umumiy Ma'lumot

**Maqsad:** Ilovaning asosiy funksiyasini kengaytirib, foydalanuvchilarga o'zlari yaratgan so'z to'plamlari asosida interaktiv testlar ishlash imkoniyatini qo'shish. Ilovaning navigatsiyasi va foydalanuvchi tajribasi (UX) to'liq qayta ko'rib chiqiladi.

## 2. Amalga Oshirilgan Ishlar va Dizayn Qarorlari (v1.0 dan)

- **Arxitektura va Texnologiyalar:** `Flutter`, `Hive`, `Provider`, `uuid`, `google_fonts`, `lucide_icons`, `intl` o'zgarishsiz qoladi.
- **CRUD Funksionalligi:** Mavjud to'plam yaratish, tahrirlash va o'chirish logikasi saqlab qolinadi, ammo yangi sahifalarga moslashtiriladi.
- **Dizayn va UX ("Bold Definition"):** `Bebas Neue` va `Roboto` shriftlari, `Electric Gold` ranglar palitrasi va umumiy dizayn sistemasi saqlanib qoladi.

## 3. Yangi Reja (v2.0)

### Navigatsiya va Sahifalar Arxitekturasi

1.  **Bosh Sahifa (`HomePage`):**
    *   **Vazifasi:** Ilovaning asosiy kirish nuqtasi.
    *   **Tarkibi:**
        *   Ilova nomi va qisqacha ko'rsatma matni.
        *   Markazda katta, yorqin **"Testni Boshlash"** tugmasi.
        *   `AppBar`da **"Tarix" (`History`) ikonka-tugmasi** bo'ladi, u `HistoryScreen`ga olib boradi.

2.  **To'plamlarni Tanlash Sahifasi (`SelectCollectionsScreen`):**
    *   **Vazifasi:** Test uchun bir yoki bir nechta to'plamni tanlash imkonini berish.
    *   **Ochilishi:** `HomePage`dagi "Testni Boshlash" tugmasi bosilganda.
    *   **Tarkibi:**
        *   Barcha mavjud to'plamlarning ro'yxati (`ListView`).
        *   Har bir to'plam elementi yonida `Checkbox`.
        *   Yuqorida **"Barchasini Tanlash / Barchasini O'chirish"** (`Select/Deselect All`) funksiyasi.
        *   Pastda tanlangan to'plamlar bilan **"Testni Boshlash"** tugmasi.

3.  **To'plamlar Tarixi Sahifasi (`HistoryScreen`):**
    *   **Vazifasi:** To'plamlarni boshqarish (yaratish, tahrirlash, o'chirish).
    *   **Ochilishi:** `HomePage`dagi "Tarix" ikonka-tugmasi bosilganda.
    *   **Tarkibi:**
        *   Mavjud to'plamlar ro'yxati.
        *   Yangi to'plam qo'shish uchun `FloatingActionButton`.
        *   **YANGILIK:** Har bir to'plam kartasida kichik **"Play" ikonka-tugmasi** bo'ladi. Bu tugma bosilganda, faqat o'sha bitta to'plam bo'yicha `QuizScreen` darhol ochiladi.

4.  **Test Sahifasi (`QuizScreen`):**
    *   **Vazifasi:** Tanlangan so'zlar bo'yicha foydalanuvchini sinovdan o'tkazish.
    *   **Ochilishi:** `SelectCollectionsScreen` yoki `HistoryScreen`dan.
    *   **Tarkibi:**
        *   Savol: So'zning tarjimasi ko'rsatiladi.
        *   Javob: Foydalanuvchi asl so'zni kiritishi uchun `TextField`.
        *   "Tekshirish" tugmasi.
        *   To'g'ri/noto'g'ri javoblar hisobi.
        *   So'zlar "shuffle" qilinadi (aralashtiriladi).

### Vazifalar Ketma-ketligi:

1.  **Mavjud `HomePage`ni (`HistoryScreen`) `HistoryScreen.dart` fayliga ko'chirish.**
2.  **Yangi `HomePage.dart` faylini yaratish** va yuqorida tasvirlangan tarkib bilan to'ldirish.
3.  Ilova navigatsiyasini yangilash (`MaterialApp`da `home` propertisini yangi `HomePage`ga o'zgartirish).
4.  `SelectCollectionsScreen.dart` faylini yaratish va logikasini qurish.
5.  `HistoryScreen`ga "Play" ikonkasini qo'shish.
6.  `QuizScreen.dart` faylini yaratish va test logikasini (shuffle, tekshirish, natija) qurish.
7.  Barcha sahifalar orasidagi navigatsiyani `Provider` yordamida bog'lash.
