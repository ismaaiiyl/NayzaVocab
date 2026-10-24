# Coding Standards & Architecture Rules for NayzaVocab

- **Max File Length**: Strict 200 lines limit per `.dart` file. Split into sub-widgets and dialogs when reaching 150 lines.
- **Folder Organization**: Every screen must have a dedicated folder with `page.dart`, `widgets/`, `dialogs/`, `controllers/`.
- **Clean Architecture**: Domain (entities, usecases, repo interfaces) -> Data (datasources, models, repo impl) -> Presentation (pages, widgets, providers).
- **Clean Code**:
  - No duplicated widgets or classes.
  - Guard clauses (early return) over nested `if-else`.
  - Comprehensive `try-catch` with typed Failures, never silent error swallowing.
  - Strict typing: No untyped `dynamic` in presentation layers.
- **Localization (i18n)**: All UI strings must use `AppLocalizations.of(context)`. Never hardcode user-facing strings.
- **UI/UX & Fonts**: Use font families compatible with all supported languages (Uzbek, Russian, English, Arabic, German, Korean). No all-caps English-only display fonts for multilingual headings.
- **Test Integrity**: Keep all unit and widget tests green after every change.
