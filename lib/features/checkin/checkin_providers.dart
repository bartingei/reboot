import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/db/database_provider.dart';
import 'checkin_repository.dart';

final checkInRepositoryProvider = Provider<CheckInRepository>((ref) {
  return CheckInRepository(ref.watch(appDatabaseProvider));
});

final recentCheckInsProvider =
    StreamProvider.autoDispose<List<CheckIn>>((ref) {
  return ref.watch(checkInRepositoryProvider).watchRecentCheckIns();
});

class CheckInFormState {
  const CheckInFormState({
    this.pillar = Pillar.recovery,
    this.mood = 3,
    this.cravingIntensity = 0,
    this.growthPrompt = '',
    this.isSubmitting = false,
  });

  final Pillar pillar;
  final int mood;
  final int cravingIntensity;
  final String growthPrompt;
  final bool isSubmitting;

  CheckInFormState copyWith({
    Pillar? pillar,
    int? mood,
    int? cravingIntensity,
    String? growthPrompt,
    bool? isSubmitting,
  }) {
    return CheckInFormState(
      pillar: pillar ?? this.pillar,
      mood: mood ?? this.mood,
      cravingIntensity: cravingIntensity ?? this.cravingIntensity,
      growthPrompt: growthPrompt ?? this.growthPrompt,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class CheckInFormController extends StateNotifier<CheckInFormState> {
  CheckInFormController(this._repository) : super(const CheckInFormState());

  final CheckInRepository _repository;

  void setPillar(Pillar pillar) => state = state.copyWith(pillar: pillar);

  void setMood(int mood) => state = state.copyWith(mood: mood);

  void setCravingIntensity(int value) =>
      state = state.copyWith(cravingIntensity: value);

  void setGrowthPrompt(String value) =>
      state = state.copyWith(growthPrompt: value);

  /// Persists the current form as a check-in, then resets the form
  /// (keeping the selected pillar, since that's likely still correct for
  /// the user's next check-in).
  Future<void> submit() async {
    state = state.copyWith(isSubmitting: true);
    try {
      final habit = await _repository.ensureDefaultHabit(state.pillar);
      await _repository.addCheckIn(
        habitId: habit.id,
        mood: state.mood,
        cravingIntensity:
            state.pillar == Pillar.recovery ? state.cravingIntensity : null,
        growthPrompt: state.pillar == Pillar.growth &&
                state.growthPrompt.trim().isNotEmpty
            ? state.growthPrompt.trim()
            : null,
      );
    } finally {
      state = CheckInFormState(pillar: state.pillar);
    }
  }
}

final checkInFormControllerProvider = StateNotifierProvider.autoDispose<
    CheckInFormController, CheckInFormState>((ref) {
  return CheckInFormController(ref.watch(checkInRepositoryProvider));
});
