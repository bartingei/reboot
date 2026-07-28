import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Semantic colors that Material's [ColorScheme] has no slot for: the two
/// pillars, milestone gold, SOS, and the craving-intensity ramp.
///
/// Read these via `context.rebootColors` so screens never hardcode a value
/// from [AppColors] and silently break in the other brightness.
@immutable
class RebootColors extends ThemeExtension<RebootColors> {
  const RebootColors({
    required this.recovery,
    required this.recoverySoft,
    required this.growth,
    required this.growthSoft,
    required this.milestone,
    required this.milestoneSoft,
    required this.sos,
    required this.sosSoft,
    required this.cravingCalm,
    required this.cravingIntense,
    required this.surfaceRaised,
    required this.surfaceSunken,
    required this.hairline,
  });

  /// Recovery pillar accent, and the app's default "you're doing it" color.
  final Color recovery;
  final Color recoverySoft;

  /// Growth pillar accent.
  final Color growth;
  final Color growthSoft;

  /// Badges, wins, unlocked milestones. Used sparingly — if everything
  /// celebrates, nothing does.
  final Color milestone;
  final Color milestoneSoft;

  /// SOS entry points and the SOS screen itself.
  final Color sos;
  final Color sosSoft;

  /// Ends of the craving-intensity ramp (0 → 10). Interpolate with
  /// [cravingColor] rather than picking a step color by hand.
  final Color cravingCalm;
  final Color cravingIntense;

  /// Card/sheet fill sitting above the scaffold, and the inset wells used
  /// for inputs and progress tracks.
  final Color surfaceRaised;
  final Color surfaceSunken;

  /// 1px separators. Low contrast by design — structure should come from
  /// spacing first, lines second.
  final Color hairline;

  /// Color for a craving rating of [intensity] on a 0–10 scale.
  Color cravingColor(int intensity) {
    final t = intensity.clamp(0, 10) / 10;
    return Color.lerp(cravingCalm, cravingIntense, t)!;
  }

  /// Accent for a pillar, keyed by whether it's the recovery pillar.
  Color pillar({required bool isRecovery}) => isRecovery ? recovery : growth;

  Color pillarSoft({required bool isRecovery}) =>
      isRecovery ? recoverySoft : growthSoft;

  static const RebootColors dark = RebootColors(
    recovery: AppColors.sage300,
    recoverySoft: Color(0xFF1B2F27),
    growth: AppColors.iris300,
    growthSoft: Color(0xFF232544),
    milestone: AppColors.amber300,
    milestoneSoft: Color(0xFF3A2E15),
    sos: AppColors.ember300,
    sosSoft: AppColors.ember900,
    cravingCalm: AppColors.sage300,
    cravingIntense: AppColors.ember300,
    surfaceRaised: AppColors.dusk800,
    surfaceSunken: Color(0xFF0F1716),
    hairline: Color(0x1FFFFFFF),
  );

  static const RebootColors light = RebootColors(
    recovery: AppColors.sage700,
    recoverySoft: AppColors.sage50,
    growth: AppColors.iris700,
    growthSoft: Color(0xFFEFEFFB),
    milestone: AppColors.amber700,
    milestoneSoft: Color(0xFFFDF4E2),
    sos: AppColors.ember700,
    sosSoft: Color(0xFFFCEDE7),
    cravingCalm: AppColors.sage600,
    cravingIntense: AppColors.ember700,
    surfaceRaised: AppColors.dusk0,
    // Not dusk50: that's the light scaffold color, and a sunken well has to
    // stay visible when it sits directly on the page rather than in a card.
    surfaceSunken: Color(0xFFEAEFED),
    hairline: Color(0x14000000),
  );

  @override
  RebootColors copyWith({
    Color? recovery,
    Color? recoverySoft,
    Color? growth,
    Color? growthSoft,
    Color? milestone,
    Color? milestoneSoft,
    Color? sos,
    Color? sosSoft,
    Color? cravingCalm,
    Color? cravingIntense,
    Color? surfaceRaised,
    Color? surfaceSunken,
    Color? hairline,
  }) {
    return RebootColors(
      recovery: recovery ?? this.recovery,
      recoverySoft: recoverySoft ?? this.recoverySoft,
      growth: growth ?? this.growth,
      growthSoft: growthSoft ?? this.growthSoft,
      milestone: milestone ?? this.milestone,
      milestoneSoft: milestoneSoft ?? this.milestoneSoft,
      sos: sos ?? this.sos,
      sosSoft: sosSoft ?? this.sosSoft,
      cravingCalm: cravingCalm ?? this.cravingCalm,
      cravingIntense: cravingIntense ?? this.cravingIntense,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      surfaceSunken: surfaceSunken ?? this.surfaceSunken,
      hairline: hairline ?? this.hairline,
    );
  }

  @override
  RebootColors lerp(ThemeExtension<RebootColors>? other, double t) {
    if (other is! RebootColors) return this;
    return RebootColors(
      recovery: Color.lerp(recovery, other.recovery, t)!,
      recoverySoft: Color.lerp(recoverySoft, other.recoverySoft, t)!,
      growth: Color.lerp(growth, other.growth, t)!,
      growthSoft: Color.lerp(growthSoft, other.growthSoft, t)!,
      milestone: Color.lerp(milestone, other.milestone, t)!,
      milestoneSoft: Color.lerp(milestoneSoft, other.milestoneSoft, t)!,
      sos: Color.lerp(sos, other.sos, t)!,
      sosSoft: Color.lerp(sosSoft, other.sosSoft, t)!,
      cravingCalm: Color.lerp(cravingCalm, other.cravingCalm, t)!,
      cravingIntense: Color.lerp(cravingIntense, other.cravingIntense, t)!,
      surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t)!,
      surfaceSunken: Color.lerp(surfaceSunken, other.surfaceSunken, t)!,
      hairline: Color.lerp(hairline, other.hairline, t)!,
    );
  }
}

extension RebootThemeContext on BuildContext {
  RebootColors get rebootColors =>
      Theme.of(this).extension<RebootColors>() ?? RebootColors.dark;

  ColorScheme get colors => Theme.of(this).colorScheme;

  TextTheme get text => Theme.of(this).textTheme;
}

class AppTheme {
  AppTheme._();

  /// Dark is the app's default (see [RebootApp]) — this app gets opened late
  /// at night more than most, and the dark palette is what the design
  /// targets. Light is a faithful port, not an afterthought.
  static ThemeData dark() => _build(
        brightness: Brightness.dark,
        scheme: const ColorScheme.dark(
          primary: AppColors.sage300,
          onPrimary: AppColors.sage900,
          primaryContainer: Color(0xFF1B2F27),
          onPrimaryContainer: AppColors.sage100,
          secondary: AppColors.iris300,
          onSecondary: AppColors.iris900,
          secondaryContainer: Color(0xFF232544),
          onSecondaryContainer: AppColors.iris100,
          tertiary: AppColors.amber300,
          onTertiary: Color(0xFF3A2E15),
          tertiaryContainer: Color(0xFF3A2E15),
          onTertiaryContainer: AppColors.amber100,
          error: AppColors.ember300,
          onError: AppColors.ember900,
          errorContainer: AppColors.ember900,
          onErrorContainer: AppColors.ember100,
          surface: AppColors.dusk950,
          onSurface: Color(0xFFE6EDEB),
          onSurfaceVariant: AppColors.dusk300,
          surfaceContainerHighest: AppColors.dusk700,
          outline: AppColors.dusk600,
          outlineVariant: AppColors.dusk700,
          inverseSurface: AppColors.dusk100,
          onInverseSurface: AppColors.dusk900,
        ),
        extension: RebootColors.dark,
      );

  static ThemeData light() => _build(
        brightness: Brightness.light,
        scheme: const ColorScheme.light(
          primary: AppColors.sage700,
          onPrimary: AppColors.dusk0,
          primaryContainer: AppColors.sage50,
          onPrimaryContainer: AppColors.sage900,
          secondary: AppColors.iris700,
          onSecondary: AppColors.dusk0,
          secondaryContainer: Color(0xFFEFEFFB),
          onSecondaryContainer: AppColors.iris900,
          tertiary: AppColors.amber700,
          onTertiary: AppColors.dusk0,
          tertiaryContainer: Color(0xFFFDF4E2),
          onTertiaryContainer: Color(0xFF4A3410),
          error: AppColors.ember700,
          onError: AppColors.dusk0,
          errorContainer: Color(0xFFFCEDE7),
          onErrorContainer: AppColors.ember900,
          surface: AppColors.dusk50,
          onSurface: AppColors.dusk900,
          onSurfaceVariant: AppColors.dusk500,
          surfaceContainerHighest: AppColors.dusk100,
          outline: AppColors.dusk300,
          outlineVariant: AppColors.dusk200,
          inverseSurface: AppColors.dusk900,
          onInverseSurface: AppColors.dusk50,
        ),
        extension: RebootColors.light,
      );

  static ThemeData _build({
    required Brightness brightness,
    required ColorScheme scheme,
    required RebootColors extension,
  }) {
    final textTheme =
        AppTypography.textTheme(scheme.onSurface, scheme.onSurfaceVariant);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: textTheme,
      extensions: [extension],
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.headlineSmall,
        iconTheme: IconThemeData(color: scheme.onSurface),
      ),
      // Card surfaces are styled by AppCard rather than ThemeData.cardTheme:
      // that property's type changed across recent Flutter releases
      // (CardTheme → CardThemeData), and every card in the app goes through
      // AppCard anyway.
      dividerTheme: DividerThemeData(
        color: extension.hairline,
        space: 1,
        thickness: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(AppTouch.comfortable),
          textStyle: textTheme.labelLarge,
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.pillBorder,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(AppTouch.comfortable),
          textStyle: textTheme.labelLarge,
          side: BorderSide(color: scheme.outline),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.pillBorder,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(textStyle: textTheme.labelLarge),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: extension.surfaceSunken,
          selectedBackgroundColor: scheme.primaryContainer,
          selectedForegroundColor: scheme.onPrimaryContainer,
          foregroundColor: scheme.onSurfaceVariant,
          side: BorderSide(color: extension.hairline),
          textStyle: textTheme.labelLarge,
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.pillBorder,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: extension.surfaceSunken,
        side: BorderSide(color: extension.hairline),
        labelStyle: textTheme.labelMedium,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.pillBorder,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: extension.surfaceSunken,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        contentPadding: const EdgeInsets.all(AppSpacing.lg),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: extension.hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: extension.hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
      ),
      sliderTheme: SliderThemeData(
        trackHeight: 8,
        inactiveTrackColor: extension.surfaceSunken,
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 22),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: extension.surfaceRaised,
        surfaceTintColor: Colors.transparent,
        indicatorColor: scheme.primaryContainer,
        elevation: 0,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelSmall),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.sheetBorder),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: extension.surfaceRaised,
        contentTextStyle: textTheme.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.zero,
        titleTextStyle: textTheme.titleSmall,
        subtitleTextStyle: textTheme.bodySmall,
        iconColor: scheme.onSurfaceVariant,
      ),
    );
  }
}
