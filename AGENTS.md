# NayzaVocab — AI Agent Development & Code Standards

Ushbu qoidalar to'plami har qanday AI agenti (Antigravity, Gemini, Cursor, Claude va boshqalar) uchun **majburiy** hisoblanadi. Har bir yangi kod yozish, o'zgartirish yoki refaktoringda quyidagi standartlarga 100% amal qilinishi shart.

---

## 1. 📏 Qat'iy Fayl Hajmi Chegarasi (Maksimal 200 qator)
* **Qoida:** Hech qaysi `.dart` fayli **200 qatordan uzun bo'lishi mumkin emas**.
* **Erta Ogohlantirish (150 qator):** Fayl 150 qatorga yetganda, darhol uni bo'laklash boshlanadi:
  - Ichki widgetlar (masalan, card'lar, list tile'lar) -> `widgets/` papkasiga.
  - Dialoglar (masalan, add/edit, rename, delete) -> `dialogs/` papkasiga.
  - Biznes hisob-kitoblar, mantiq -> `controllers/` yoki `services/` ga.
* Bitta fayl ichiga bir nechta `class` yoki `StatefulWidget` tiqib yuborish **qat'iyan taqiqlanadi**.

---

## 2. 🏛️ Clean Architecture & Feature-First Papkalar Tuzilmasi

Har bir funksionallik (feature) quyidagi qatlamlarga ega bo'lishi lozim:

```
lib/features/<feature_name>/
├── domain/                      # Sof biznes mantiq (Frameworkdan mustaqil)
│   ├── entities/                # Sof Dart modellar
│   ├── repositories/            # Abstrakt interfeyslar
│   └── usecases/                # Bitta amalni bajaruvchi use case'lar
├── data/                        # Ma'lumotlar bilan ishlash
│   ├── datasources/             # Local (Hive) va Remote (Supabase) manbalari
│   ├── models/                  # Hive va JSON adapterli modellar
│   └── repositories/            # Domain interfeyslari realizatsiyasi
└── presentation/                # UI va State
    ├── pages/                   # Faqat ekranning skeleti va Scaffold (<= 200 qator)
    ├── widgets/                 # Ushbu sahifaga tegishli mayda widgetlar
    ├── dialogs/                 # Dialoglar va BottomSheet'lar
    └── provider/                # ChangeNotifier / State boshqaruvi
```

---

## 3. 🧩 Kod Sifati & Dasturlash Qoidalari

### A. DRY (Don't Repeat Yourself)
* Bir xil nomli sinflar (masalan, ikkita `NayzaButton`) yaratilishi qat'iyan taqiqlanadi.
* Umumiy widgetlar faqat `lib/core/widgets/` da joylashadi va qayta foydalaniladi.
* Sahifalararo nusxalangan dialoglar (masalan, `_EditTitleDialog`) alohida umumiy faylga chiqariladi.

### B. Guard Clauses & If-Else Qoidalari
* Chuqur ichma-ich ketgan `if-else` yozish taqiqlanadi (maksimal 2 daraja).
* Har doim **erta qaytish (Early Return / Guard Clause)** usulidan foydalaning:
  ```dart
  // ❌ Noto'g'ri
  if (user != null) {
    if (user.isActive) {
      doAction();
    }
  }

  // ✅ To'g'ri
  if (user == null || !user.isActive) return;
  doAction();
  ```

### C. Qat'iy Tipizatsiya (Strict Typing)
* `dynamic` tipidan to'g'ridan-to'g'ri UI'da foydalanish qat'iyan man etiladi.
* Supabase yoki API'dan kelgan har qanday JSON ma'lumot darhol Model yoki Entity'ga o'girilishi shart (`as String`, `as int` xavfsiz null-fallback bilan).

### D. Xatoliklarni Boshqarish (Try-Catch & Failures)
* Hech qachon xatolikni jimgina yutib yubormang:
  ```dart
  // ❌ Qat'iyan man etiladi
  } catch (e) {
    return null;
  }

  // ✅ To'g'ri
  } catch (e, stack) {
    debugPrint('Xatolik: $e\n$stack');
    // Loglash va foydalanuvchiga tushunarli xabar berish
  }
  ```
* Barcha xatoliklar `lib/core/error/failures.dart` dagi typed `Failure` sinflari orqali uzatiladi.
* Dastur ichida o'zbekcha yoki boshqa tildagi qattiq matnli `throw Exception("...")` yozilmaydi.

---

## 4. 🌍 Ko'p Tillilik (i18n) va Matnlar
* UI'dagi **hech qanday matn qattiq kodlanmasligi (hardcoded string) shart**.
* Barcha ko'rinadigan matnlar `AppLocalizations.of(context)!` orqali olinadi.
* Yangi so'z qo'shilganda `lib/l10n/app_*.arb` fayllarining barchasiga (uz, en, ru, ar, de, ko) kiritiladi.

---

## 5. 🎨 UI/UX, Ranglar va Tipografika Standartlari
* **Universal Shriftlar:** `Bebas Neue` kabi faqat lotincha harflarni qo'llovchi shriftlar sarlavhalarda yoki AppBar'da ishlatilmaydi (chunki Arab, Rus va Koreys tillarida xatolik keltirib chiqaradi). Uning o'rniga barcha alifbolarni qo'llovchi zamonaviy shriftlar (`Inter`, `Cairo`, `Noto Sans`) ishlatiladi.
* **Ergonomika:** AppBar'da 2 tadan ko'p amal tugmasi bo'lmasligi kerak. Qo'shimcha amallar (`share`, `rename`, `delete`) `PopupMenuButton` ichiga joylanadi.
* **Tegish maydoni (Touch Target):** Barcha bosiladigan elementlar minimal **44x44 dp** (yaxshisi 48x48 dp) o'lchamda bo'lishi shart.
* **Ranglar:** Asosiy dizayn tizimiga (`AppTheme.darkNavy`, `AppTheme.electricGold`, `AppTheme.surfaceNavy`, `AppTheme.textDim`) qat'iy amal qilinadi.

---

## 6. 🧪 Testlar
* Har qanday model yoki provider o'zgarganda, tegishli unit testlar yangilanadi.
* Har bir commit yoki refaktoringdan so'ng `flutter test` va `flutter analyze` 100% yashil (xatosiz) bo'lishi shart.
