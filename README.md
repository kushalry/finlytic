# Finlytic

A personal finance tracker built with Flutter, showcasing production-grade mobile architecture for a fintech domain.

> **Status:** In active development. Follow along via commit history — each commit is a meaningful architectural step.

## Why this project

Finlytic is part of a three-project portfolio designed to demonstrate senior-level (SDE-2) engineering across mobile and backend. This is the Flutter piece: a realistic fintech app where architecture, data modeling, and performance decisions matter.

The other two projects in the portfolio are a native Android app and a Java Spring Boot backend service, each targeting different domains to flex different skills.

## Features (planned)

- Track income and expenses across multiple accounts (bank, wallet, credit card, cash)
- Categorize transactions with smart defaults, archive old categories without losing history
- Monthly budgets per category with visual progress indicators
- Dashboard with spending breakdown (pie) and monthly trend (line) charts
- Biometric app lock for sensitive financial data
- Dark / light / system theme
- CSV import / export
- AI-powered insights (stretch goal)

## Tech stack

| Layer | Choice | Why |
|---|---|---|
| Framework | Flutter 3.24+ | Cross-platform single codebase |
| Language | Dart 3.5+ | Null safety, records, pattern matching |
| State management | Riverpod 2.x | Compile-safe, testable without `BuildContext`, modern community default |
| Navigation | go_router | Declarative routing with type-safe deep links |
| Local database | Drift (SQLite) | Type-safe SQL, reactive streams, migration system |
| Data classes | Freezed | Immutability, `copyWith`, exhaustive `switch` |
| Charts | fl_chart | Customizable, performant |
| Testing | flutter_test, mocktail, integration_test | Full testing pyramid |

## Architecture

Clean Architecture with feature-first folder organization.

```
lib/
├── app/                          # MaterialApp, router, theme
├── core/
│   ├── database/                 # Drift schema, DAOs, migrations
│   ├── errors/                   # Failure types
│   └── utils/                    # Formatters, extensions
├── features/
│   ├── transactions/
│   │   ├── data/                 # Drift-backed repositories
│   │   ├── domain/               # Pure Dart business logic (testable in isolation)
│   │   └── presentation/         # Riverpod providers, screens, widgets
│   ├── categories/
│   ├── budgets/
│   ├── dashboard/
│   └── settings/
└── shared/                       # Reusable widgets
```

**Dependency rule:** presentation depends on domain, data implements domain. Domain has zero Flutter dependencies — it's pure Dart, fast to test, framework-agnostic.

## Key design decisions

Architectural decisions that interviewers typically probe. Documented upfront.

### Money stored as integer minor units
All amounts live in the database as integers in the minor unit of the currency (paise/cents). `₹1,234.56` is stored as `123456`. Floating-point math is never used for money — this eliminates a common class of rounding errors that plague fintech systems.

### Single `transactions` table with `type` column
Income, expense, and transfer are all rows in one table, distinguished by a `type` enum. Keeps queries simple (one balance query across all movement types) and supports linking transfer pairs via a shared `transferGroupId`.

### Soft delete via `isArchived` flag
Categories and accounts can't be hard-deleted because historical transactions reference them. Archiving hides them from pickers while preserving referential integrity.

### Reactive queries via Drift streams
UI subscribes to query streams, so any database write automatically updates the screen — no manual refresh logic, no `setState` after save.

### Background database initialization
`NativeDatabase.createInBackground` opens the SQLite connection on a background isolate, keeping the main isolate free for UI rendering.

## Running the project

**Prerequisites:**
- Flutter 3.24+ (`flutter --version`)
- Java 17 (for Android builds)
- Xcode 15+ (for iOS builds on macOS)

**Setup:**
```bash
git clone https://github.com/<you>/finlytic.git
cd finlytic
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

Testing strategy:
- **Unit tests** — pure Dart domain logic (use cases, entities)
- **Integration tests** — DAOs tested against in-memory SQLite
- **Widget tests** — UI behavior with mocked repositories
- **End-to-end** — real database, real navigation (planned)

## Roadmap

- [x] Project scaffold with Clean Architecture
- [x] Drift database schema and DAOs
- [ ] Transactions feature (domain + data + presentation)
- [ ] Categories feature
- [ ] Dashboard with charts
- [ ] Budgets with alerts
- [ ] Polish: animations, empty states, error handling
- [ ] Biometric lock
- [ ] CSV import/export
- [ ] AI insights

## License

MIT — feel free to reference for your own learning.

## Author

Kushal Roy — transitioning to SDE-2. [LinkedIn] [GitHub]