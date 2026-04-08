# 🔱 Blueprint: Nayza Vocab v2.0 (Collection-Based Ecosystem)

## 1. Loyiha Haqida Umumiy Ma'lumot
**Maqsad:** Nayza Vocab-ni oddiy lug'at ilovasidan mukammal "Set-based" (to'plamlarga asoslangan) o'rganish platformasiga aylantirish. Bu versiyada asosiy e'tibor ma'lumotlarni ommaviy kiritish (Bulk Input), samarali takrorlash (Shuffle Engine) va premium UI/UX-ga qaratiladi.

## 2. Arxitektura va Dizayn Qarorlari
- **Pattern:** Clean Feature-First Architecture.
- **State Management:** `Provider` (VocabSetProvider, TrainingProvider).
- **Storage:** `Hive` (NoSQL) - tezkor va lokal.
- **Theme:** "Deep Navy & Electric Gold" (#0A192F & #FFD700). Premium qorong'u rejim.
- **Typography:** `Bebas Neue` (display) va `Roboto/Inter` (body).

## 3. Yangi Sahifalar va Funksionallik

### A. Bosh Sahifa (HomePage)
- Ilova markaziy nuqtasi.
- Katta yorqin **"Testni Boshlash"** tugmasi.
- Yuqori burchakda **"Tarix"** (History) ikonka-tugmasi.
- Oxirgi o'rganilgan setlar haqida qisqacha ma'lumot.

### B. To'plamlar Tarixi (HistoryScreen)
- Barcha to'plamlar kartalar (Cards) ko'rinishida.
- Har bir kartada: Sarlavha, so'zlar soni, yaratilgan sana.
- **Quick Play:** Har bir kartada "Play" tugmasi bo'lib, u darhol shu set bo'yicha quizni boshlaydi.
- **Hero Animation:** Karta bosilganda tafsilotlar sahifasiga silliq o'tish.

### C. Ommaviy Kiritish (CreateSetScreen)
- "Environment Variable" uslubidagi UI.
- Foydalanuvchi bir vaqtning o'zida 10-20-tacha so'zni bitta sahifada kiritishi mumkin.
- Dinamik qatorlar: "+" tugmasi yangi Word/Translation juftligini qo'shadi.

### D. Interaktiv Test (QuizScreen)
- **Shuffle Logic:** Savollar aralashtiriladi.
- **Error Persistence:** Noto'g'ri javob berilgan so'zlar "failedQueue"-ga tushadi va sessiya oxirida qayta so'raladi.
- **Visual Feedback:** To'g'ri/noto'g'ri javoblar uchun haptic va vizual effektlar.

## 4. Amalga Oshirish Bosqichlari (Roadmap)

### 1-Bosqich: Data & Models
- `WordModel`-ga `isLearned` va `wrongAttempts` maydonlarini qo'shish.
- Hive adapterlarini yangilash.

### 2-Bosqich: Premium Theme & Core
- `AppTheme` yaratish (Navy & Gold).
- `main.dart`-dagi global theme-ni yangilash.

### 3-Bosqich: Presentation (CRUD & Bulk)
- `CreateSetScreen` (Dinamik qatorlar bilan).
- `HistoryScreen` (Set Cards).
- `SetDetailsScreen` (Edit mode).

### 4-Bosqich: Quiz Engine
- `TrainingProvider` yaratish.
- `QuizScreen` (Multiple choice va Input rejimlari).
- TTS (Text-to-Speech) integratsiyasi.

### 5-Bosqich: Polishing
- Hero animations.
- Lints & Code cleanup.
- Performance optimization.
