# Kalpi — mobile strategy notebook

A mobile-first Flutter app (iOS + Android) that reimagines the Kalpi
rule-based strategy builder for the pocket: onboard, build a strategy from a
stock universe, filters, ranking and allocation, then save and manage it.

Dark theme only. Built pixel-to-pixel from the Penpot design (65 boards) using
Manrope for display type, Inter Tight for body copy and Flutter's Cupertino
icon set.

> This is a product/UX prototype with **mock data**. It never places trades,
> connects to a broker, scans live markets or makes recommendations. Saved
> strategies are definitions stored on the device.

---

## Features

| Area | What you can do |
| --- | --- |
| **Onboarding** | Welcome → investing experience → intent. Radios select in place, *Continue* commits, *Skip* applies defaults. A “learn” intent lands on the worked example. |
| **Strategy builder** | Four numbered steps + review: universe (Nifty 50 / Nifty 500 / custom stock picker), AND-combined rules with a metric picker and validated numeric input, ranking metric + direction + holding count, equal or market-cap allocation. One shared draft survives back/forward, pickers and the exit sheet. |
| **Review & save** | Editable name with inline validation, per-section edit links, busy state, idempotent save with a full **save-recovery** screen and retry. |
| **My strategies** | Empty state, list with search (case-insensitive, distinct “no results”), transient success banners, per-card *More* actions. |
| **Manage** | View detail, edit (same id, “Changes saved”), duplicate (new id, fresh rule ids), delete with named confirmation and failure recovery. |
| **Learn** | Two-minute worked example that seeds the builder. |
| **Preferences** | Change experience/intent without touching strategies. Includes a clearly labelled demo switch that makes the next write fail once so the recovery flows can be exercised. |

## Tech stack

- **Flutter 3.38 / Dart 3.10**, iOS + Android
- **State**: `flutter_bloc` — Cubits only (`PreferencesCubit`, `StrategyListCubit`, `BuilderCubit`)
- **Navigation**: `go_router` with onboarding redirects and a 160 ms dissolve
- **Persistence**: `shared_preferences` behind repository interfaces (device-local demo adapter)
- **Ids / idempotency**: `uuid`; every mutation carries a request id so retries never duplicate
- **Tests**: `flutter_test`, `bloc_test`, golden screenshots, `integration_test`

## Project structure

```
lib/
├── main.dart                      # bootstrap
├── app/
│   ├── kalpi_app.dart             # MaterialApp.router + providers
│   ├── app_bloc_observer.dart
│   ├── di/app_dependencies.dart   # composition root (swap adapters here)
│   └── router/                    # routes, GoRouter, page transitions
├── core/
│   ├── constants/                 # strings, dimens, durations, config, storage keys
│   ├── theme/                     # colours, typography, icons, ThemeData
│   ├── utils/                     # id generator, number formatting
│   └── widgets/                   # design-system components (button, chip, choice card,
│                                  #   sheet, stepper, fields, bottom nav, …)
└── features/
    ├── onboarding/                # domain · data · cubit · pages
    ├── strategies/                # domain models, validation, narrator, repository,
    │                              #   list/detail/duplicate pages, sheets
    ├── builder/                   # BuilderCubit, step host, five steps, rule editor,
    │                              #   metric & stock pickers
    ├── learn/
    └── preferences/
test/
├── unit/                          # validation, cubits, repository
├── golden/                        # 28 screen goldens rendered with the real fonts
└── support/fakes.dart
integration_test/app_flow_test.dart  # on-device lifecycle test
```

Every user-facing string lives in `lib/core/constants/app_strings.dart`; every
size, radius and duration in `app_dimens.dart` / `app_durations.dart`; colours
and text styles in `lib/core/theme/`.

## Getting started

```bash
flutter pub get
flutter run                       # pick an iOS simulator or Android device
```

### Quality checks

```bash
flutter analyze                   # 0 issues
flutter test test/unit            # 37 unit tests
flutter test test/golden          # 22 golden scenarios (28 screens)
flutter test integration_test -d <device-id>   # end-to-end on a device
```

Golden images live in `test/golden/goldens/`. Regenerate after intentional
visual changes with `flutter test --update-goldens test/golden`.

## Design fidelity

- Layout metrics were taken from the Penpot layer snapshot (positions, sizes,
  radii, strokes, font sizes/weights) and the live boards exported through the
  Penpot MCP server; goldens were overlaid on the boards at 390 × 844 to verify.
- The boards are references, not a fixed viewport: layouts are fluid from 320 px
  upward, respect safe areas and the keyboard, and centre a reading column on
  wide screens.
- Body text uses **Inter Tight**, which is what the Penpot file actually
  renders (the written handoff says “Inter”; the file was followed).
- Deliberate, documented departures from the static boards, all driven by the
  UX contract: the ranking hint says “up to the top N” (matches are not
  guaranteed), the ranking metric picker also exposes sort direction, the rule
  editor offers *Remove rule* in edit mode, and the custom-universe screen’s
  primary action is *Use selected stocks*.

## What is mocked / still needs a backend

- **Stock catalogue** — a static list of ~48 large caps in `stock_catalog.dart`. Live index constituents need market data.
- **Strategy storage** — `LocalStrategyRepository` (SharedPreferences JSON, 900 ms simulated latency, revision tokens, request-id replay). Replace with an API client implementing `StrategyRepository`; nothing above the repository changes.
- **Preferences storage** — `LocalPreferencesRepository`.
- **Market-cap weights** and any matching/scan counts — illustrative only; no backtests, no live scans.
- **Auth, accounts, sync, analytics** — not present.

## Accessibility notes

Real buttons, radios (`inMutuallyExclusiveGroup`), labelled icon buttons,
live regions for banners and errors, ≥44 px hit areas, focus moves to the name
field on a rejected save, sheets trap focus and restore it, reduced motion
collapses transitions to zero.
