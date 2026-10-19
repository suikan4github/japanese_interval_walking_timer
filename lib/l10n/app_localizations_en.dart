// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Interval Walking Timer';

  @override
  String get start => 'Start';

  @override
  String get pause => 'Pause';

  @override
  String get stop => 'Stop';

  @override
  String get settings => 'Settings';

  @override
  String get about => 'About';

  @override
  String get stopConfirmTitle => 'Stop the timer?';

  @override
  String get stopConfirmMessage => 'The current progress will be cleared.';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String lapProgress(int lap, int total) {
    return '$lap/$total';
  }

  @override
  String speechLap(int lap) {
    return 'Lap $lap.';
  }

  @override
  String get speechSlowWalk => 'Please walk slowly.';

  @override
  String get speechFastWalk => 'Please walk briskly.';

  @override
  String get speechFinished => 'We did it! Have a good day.';

  @override
  String get settingsColorScheme => 'Color scheme';

  @override
  String get settingsSchemeSystem => 'Follow system';

  @override
  String get settingsSchemeCustom => 'Custom';

  @override
  String get settingsSeedColor => 'Theme color';

  @override
  String get settingsColorVariant => 'Color variation';

  @override
  String get settingsVariantFidelity => 'Vivid';

  @override
  String get settingsVariantTonal => 'Tonal';

  @override
  String get settingsVariantNeutral => 'Neutral';

  @override
  String get settingsVariantMonochrome => 'Monochrome';

  @override
  String get settingsSelectColor => 'Select color';

  @override
  String get settingsLaps => 'Number of laps';

  @override
  String get settingsHalfTime => 'Duration of each half';

  @override
  String get settingsLocked => 'Cannot be changed while the timer is active';

  @override
  String get settingsVolume => 'Voice volume';

  @override
  String get walkingSlow => 'Walking slowly';

  @override
  String get walkingFast => 'Walking briskly';

  @override
  String get notificationTitle => 'Interval walking in progress';

  @override
  String notificationText(int lap, int total) {
    return 'Lap $lap/$total';
  }
}
