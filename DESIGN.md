# Design system

Visual and interaction design for reboot. This is the reference for *why*
things look the way they do; the tokens themselves live in
`lib/core/theme/` and the shared components in `lib/core/widgets/`.

Everything here is built from Flutter's own `ThemeData` and `ThemeExtension`
— no UI kit dependency, no external font, no new packages. A recovery app
carries sensitive data, and every dependency added to it is another party to
trust; the tradeoff isn't worth it for styling.

## Principles

These are the rules that decide arguments about specific screens.

1. **Never shame.** No red for a broken streak, no "you failed", no guilt
   copy, no crossed-out days. A reset shows the new count next to *total
   days logged*, because that total never goes down.
2. **Calm over engaging.** No confetti, no flashing, no pulsing badges, no
   notification-red dots. Animation is slow (260–420ms) and never demands
   attention. Engagement patterns tuned to keep people scrolling are
   actively harmful here.
3. **Cheap to use on a bad day.** A check-in is one screen and a few taps,
   every field has a working default, and a partial answer saves fine. The
   app should be usable while distracted, tired, or shaking.
4. **The SOS path is sacred.** One tap from anywhere, renders offline,
   oversized targets, no decisions required, and an exit that never asks
   "are you sure?".
5. **Private by appearance, not just by architecture.** Nothing on screen
   names a substance or a diagnosis. Copy is neutral enough to read over a
   shoulder on a bus — the button says "I need support", not "RELAPSE".
6. **Structure from spacing, not lines.** Flat surfaces, hairline borders,
   no drop shadows. Shadows read as heavy and cluttered on a dark palette.

## Color

Raw ramps: `lib/core/theme/app_colors.dart`. Semantic mapping:
`RebootColors` in `lib/core/theme/app_theme.dart`.

| Role | Token | Dark | Light | Used for |
|---|---|---|---|---|
| Recovery pillar | `recovery` | `sage300` | `sage700` | Streak ring, recovery check-ins, the default "on track" accent |
| Growth pillar | `growth` | `iris300` | `iris700` | Growth streak, growth check-ins, journal prompts |
| Milestone | `milestone` | `amber300` | `amber700` | Badges, wins, next-milestone progress |
| SOS | `sos` | `ember300` | `ember700` | The support button and the whole SOS screen |
| Craving ramp | `cravingCalm` → `cravingIntense` | sage → ember | sage → ember | Intensity scale 0–10, interpolated |

Why these:

- **Two pillars, equal weight.** Sage and iris sit at matched lightness, so
  neither pillar looks like the "real" one. Recovery and growth are meant to
  be peers.
- **Ember, not red.** SOS has to be unmistakable without being alarming.
  Coral is findable at a glance and doesn't add adrenaline to a moment that
  already has enough. Alarm red is reserved for destructive confirmations
  (delete data, wipe backup) and appears nowhere in the daily loop.
- **Amber is rationed.** It only appears on things actually earned. If every
  surface celebrates, none of them mean anything.
- **Low saturation throughout.** Dusk neutrals are slightly green-blue so
  they sit under the sage without going muddy.

**Dark is the default** (`ThemeMode.dark` in `app.dart`). This app is opened
late at night more than most. Light is a complete port, not a fallback, and
every token is defined in both — but the design targets dark first. The SOS
screen is dark in both modes, deliberately.

## Type

`lib/core/theme/app_typography.dart`. Platform default font: nothing to
ship, nothing to fetch, and system text honours the user's accessibility
size settings for free. `AppTypography.fontFamily` is the single place to
change if a brand face is ever added.

| Style | Size/line | Use |
|---|---|---|
| `displaySmall` | 32/40 · 600 | Screen titles |
| `headlineSmall` | 22/30 · 600 | Sheet and card headlines |
| `titleMedium` | 16/22 · 600 | Card titles, field labels |
| `bodyLarge` | 16/24 · 400 | Journal entries — read, not scanned |
| `bodyMedium` | 15/22 · 400 | General body |
| `labelSmall` | 11/16 · 500 | Metadata, section headers (uppercased) |
| `AppTypography.numeral` | 52 · 700, tabular | Streak counts |

Tabular figures on numerals stop the streak count jittering as it changes.

## Spacing, radius, motion

`lib/core/theme/app_spacing.dart`. Everything is a multiple of 4; the named
steps (`xs` 4 → `huge` 40) cover essentially all of it. Page gutter is 20.

Radii are generous — 12/16/24/32 plus full pills. Hard corners read as
clinical, and this app is trying hard not to feel like a medical form.

Motion is slower than product default: `fast` 150ms, `normal` 260ms, `slow`
420ms. The SOS breathing phase is 4s (box breathing: in 4, hold 4, out 4,
hold 4).

Touch targets: `AppTouch.min` 48, `comfortable` 56 for primary buttons,
`distress` 72 for anything on the SOS path.

## Components

All in `lib/core/widgets/`:

- **`AppCard`** — the one card surface. Flat fill, hairline border, optional
  `accent` that applies a 10% tint and a matching border. Every card in the
  app goes through it (which is why `ThemeData.cardTheme` is left unset —
  that property's type has churned across recent Flutter releases).
- **`StreakRing`** — the signature component. Progress is toward the *next
  milestone*, not an absolute scale, so a 3-day streak still shows visible
  movement. An early streak rendered as a 1% sliver is discouraging exactly
  when discouragement is most expensive.
- **`MoodSelector`** — 5-point, labelled ("Rough / Low / Flat / Good /
  Great"). Bare faces are ambiguous, and the word is what makes the entry
  worth re-reading months later.
- **`IntensityScale`** — 0–10 craving bars, colored along the calm→intense
  ramp. Discrete steps rather than a slider: it's a self-report, and taps
  are easier to answer honestly than a drag that invites fiddling. Bars are
  narrower than 48dp, so the whole strip takes the gesture (tap or drag) and
  exposes one slider semantics node instead of eleven tiny buttons.
- **`PillarBadge`** / **`StatTile`** — pillar label; compact metric readout.
- **`SosButton`** — the persistent support entry point.
- **`SectionHeader`** / **`EmptyState`** — section label; empty states that
  describe the next action instead of scolding.

## Screens

### Today (`features/streaks`)

Answers one question above the fold: *am I on track today.* Recovery hero
card with the streak ring and either a check-in CTA or a "checked in today"
confirmation; a compact growth card; a 7-day strip; totals since starting;
next milestone.

Missed days in the week strip are a hollow outline — never a red cross. The
strip shows the shape of a week, it doesn't mark failures.

### Check in (`features/checkin`)

One screen, no wizard. Pillar toggle, mood, then the field that differs by
pillar: craving intensity for recovery, "what did you work on?" for growth.
Save is always enabled. Recent check-ins below.

This is the only screen already wired to real state (Riverpod +
Drift) — the redesign changed presentation only, not the providers or
repository.

### Journal (`features/journal`)

Entries as generous preview cards grouped by day, tag filter row, composer
in a bottom sheet rather than a full page — writing a line should feel as
cheap as sending a text. A daily prompt card sits at the bottom for people
who freeze at a blank page.

### Wins (`features/badges`)

Automatic milestones (time-based, unambiguous) plus user-logged wins. The
second list matters more: self-logged wins are what hold up on the day a
streak resets. Locked badges are visible but greyed, with no countdown —
seeing what's ahead motivates, a ticking timer to it pressures. A closing
card states plainly that a reset doesn't delete anything earned.

### SOS (`features/sos`)

Box-breathing pacer owns the screen; the circle is the instruction and the
words are the fallback, because following a shape is easier than reading
when panicking. Below it: call someone, ground me, why I started — three
oversized targets, no grid of choices, since decisions are the expensive
thing in that moment. Crisis helplines and an emergency-services line at the
bottom.

Nothing on this screen can be failed: no countdown, no timer, no streak
impact. Honours the OS reduce-motion setting by freezing the circle while
still cycling the phase labels. Fades in rather than sliding — a horizontal
push reads as going deeper into an app; this should feel like the app
stepping aside.

## Accessibility

- Body text 15–16dp minimum; system font scaling is respected everywhere
  (no fixed-height text containers).
- Targets meet 48dp, and the SOS path uses 72dp.
- Color is never the only signal: the week strip pairs color with a check
  glyph, the craving scale pairs color with a number *and* a word
  ("Manageable", "Strong"), pillars pair color with an icon and a label.
- Reduce-motion is honoured on the breathing pacer.
- `Semantics` is set on the custom gesture widgets (mood selector, intensity
  scale) since they aren't built from Material controls.

## Status

The design system and all five screens are implemented, but **nothing here
has been compiled or run** — the repo still has no Flutter SDK available and
no generated `app_database.g.dart`. Expect to fix small things on the first
`flutter run`.

Today, Journal, and Wins render sample data marked `NOTE:` in each file;
they're the presentation layer waiting on the providers from phases 2–3 in
ARCHITECTURE.md. Check-in is the one screen already reading real state.
