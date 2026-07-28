# reboot

Recovery + growth habit-tracking mobile app.

See [ARCHITECTURE.md](./ARCHITECTURE.md) for the full architecture, data
model, and privacy design, and [DESIGN.md](./DESIGN.md) for the design
system — palette, type scale, components, and the principles behind them.

## Getting started

The `lib/` scaffold is checked in, but the native platform projects and
generated code are not (this repo was scaffolded without the Flutter SDK
available, so none of this has been run or verified yet):

```sh
flutter create . --project-name reboot   # generates android/, ios/, etc.
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # generates app_database.g.dart
flutter run
```
