# Architecture & Build Plan

Mobile app for tracking recovery and personal-growth habits: streaks, daily
check-ins, journaling, craving-SOS support, and milestones. Mobile-first,
built for a solo/student timeline, with privacy as a first-class constraint
given the sensitivity of the data involved.

## Tech stack

- **Client**: Flutter (single codebase for iOS + Android, strong offline
  story, good fit for custom animations like the SOS breathing screen)
- **Local storage**: Drift (SQLite) — source of truth on-device
- **Backend**: Supabase (Postgres + Auth + Edge Functions), used minimally
  — see "Privacy model" below for why its role is deliberately small
- **State management**: Riverpod

## Client architecture (layered)

```
Presentation  → Screens/Widgets (Home, Check-in, Journal, SOS, Badges)
State         → Riverpod — one provider per feature domain
Domain        → Use cases: LogCheckIn, ComputeStreak, TriggerSOS
Data          → Repositories (abstract) → Local (Drift) + Remote (Supabase)
```

Check-ins, journal entries, and streaks work offline-first: writes land in
Drift immediately, and a background sync service pushes to Supabase and
resolves conflicts later. The SOS screen in particular must render fully
from local state/assets with zero network dependency — someone in crisis
with no signal can't be blocked by a network call.

### Suggested folder structure

```
lib/
  features/
    checkin/      (screen, provider, repository, local model)
    journal/
    streaks/
    sos/
    badges/
  core/
    db/           (Drift schema, migrations)
    supabase/     (client, sync service)
    crypto/       (key derivation, encrypt/decrypt for backups)
    backup/       (export/import, backup scheduling)
    theme/
    widgets/       (shared: buttons, cards)
```

## Data model (local, Drift)

- **User** — local profile only; no server-side account required by default
- **Habit/Goal** — recovery + growth pillars
- **JournalEntry** — free text, tags, timestamp
- **CheckIn** — mood, craving intensity, growth prompt response
- **Streak** — per-pillar streak count, computed client-side
- **Milestone** — badges/wins unlocked by streaks or manual logging

## Privacy model: local-first, opt-in encrypted backup

Given the sensitivity of recovery/craving/journal data, the app defaults to
**storing everything only on the user's device** and never requires an
account:

- **Default (no backup)**: no login screen, no email collected, a local
  device UUID identifies the install. All reads/writes are local SQLite.
  Uninstalling the app deletes the data — this is the accepted tradeoff for
  not having any server-side copy of sensitive content.
- **Opt-in backup**: users can enable an encrypted backup instead of
  creating a normal account. Identity is a generated recovery
  phrase (12 words, wallet-style) rather than email/password, so there's
  no PII linking the backup to a real person.
  - Key derivation: Argon2id on the recovery phrase → 256-bit key,
    computed entirely on-device; the key and phrase never leave the device.
  - Encryption: AES-256-GCM (or libsodium secretbox), applied client-side
    before any network call.
  - The server (Supabase) only ever stores ciphertext:

    ```sql
    encrypted_backups
      id             uuid
      owner_id       uuid   -- anonymous auth id, RLS-scoped
      ciphertext     bytea
      nonce          bytea
      schema_version int
      created_at     timestamptz
    ```

  - Backup = serialize local DB (or diff) → encrypt → upload as one opaque
    blob. Restore = download → decrypt locally with the recovery phrase →
    rehydrate Drift. This is a **restore point, not live multi-device
    sync** — merging concurrent edits from two devices isn't possible
    without server-side decryption, which defeats the privacy goal.

### Consequences of this model

- No password-reset-style recovery: losing the recovery phrase means the
  backup is permanently unrecoverable. Onboarding must make this explicit
  (e.g. prompt to save the phrase in a password manager).
- Streak integrity is self-reported/client-trusted, since the server never
  sees structured data to validate against. Acceptable for a personal,
  non-competitive app.
- No cross-device live sync, no therapist/social sharing features in v1 —
  those would need a deliberate, separately-consented data path.

## Build phases

1. **Foundation (2-3 weeks)** — data model, Flutter + Drift scaffold, empty
   navigation, local-only User profile
2. **Core loop (3-4 weeks)** — streak tracker, daily check-in flow,
   journal, home dashboard
3. **Support features (2-3 weeks)** — SOS screen (breathing exercise,
   distraction tools, call-a-contact), wins log/affirmations, badges
4. **Safety & polish (1-2 weeks)** — crisis resources screen, disclaimers,
   onboarding, local check-in reminders (on-device scheduled notifications,
   no server round-trip)
5. **Encrypted backup (1-2 weeks)** — recovery-phrase identity, Argon2id +
   AES-GCM encrypt/decrypt, backup/restore flow, Edge Function for
   streak reconciliation on restore
6. **Testing & launch prep** — user testing (5-10 people), bug fixes,
   performance pass, app store assets

Suggested priority if time-constrained: streaks → check-ins → journal →
SOS button → badges → encrypted backup. Cut community/social features
for v1 — biggest scope risk relative to value.
