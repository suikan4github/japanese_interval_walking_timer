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
  String speechLapStart(int lap) {
    return 'Lap $lap. Please walk slowly.';
  }

  @override
  String get speechFastWalk => 'Please walk briskly.';

  @override
  String get speechFinished => 'All laps are complete. Well done.';

  @override
  String get settingsColorScheme => 'Color scheme';

  @override
  String get settingsSchemeSystem => 'Follow system';

  @override
  String get settingsSchemeCustom => 'Custom';

  @override
  String get settingsSeedColor => 'Theme color';

  @override
  String get settingsSelectColor => 'Select color';

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
