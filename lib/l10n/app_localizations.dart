import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Interval Walking Timer'**
  String get appTitle;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @stopConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Stop the timer?'**
  String get stopConfirmTitle;

  /// No description provided for @stopConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'The current progress will be cleared.'**
  String get stopConfirmMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @lapProgress.
  ///
  /// In en, this message translates to:
  /// **'{lap}/{total}'**
  String lapProgress(int lap, int total);

  /// No description provided for @speechLap.
  ///
  /// In en, this message translates to:
  /// **'Lap {lap}.'**
  String speechLap(int lap);

  /// No description provided for @speechSlowWalk.
  ///
  /// In en, this message translates to:
  /// **'Please walk slowly.'**
  String get speechSlowWalk;

  /// No description provided for @speechFastWalk.
  ///
  /// In en, this message translates to:
  /// **'Please walk briskly.'**
  String get speechFastWalk;

  /// No description provided for @speechFinished.
  ///
  /// In en, this message translates to:
  /// **'We did it! Have a good day.'**
  String get speechFinished;

  /// No description provided for @settingsColorScheme.
  ///
  /// In en, this message translates to:
  /// **'Color scheme'**
  String get settingsColorScheme;

  /// No description provided for @settingsSchemeSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get settingsSchemeSystem;

  /// No description provided for @settingsSchemeCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get settingsSchemeCustom;

  /// No description provided for @settingsSeedColor.
  ///
  /// In en, this message translates to:
  /// **'Theme color'**
  String get settingsSeedColor;

  /// No description provided for @settingsColorVariant.
  ///
  /// In en, this message translates to:
  /// **'Color variation'**
  String get settingsColorVariant;

  /// No description provided for @settingsVariantFidelity.
  ///
  /// In en, this message translates to:
  /// **'Vivid'**
  String get settingsVariantFidelity;

  /// No description provided for @settingsVariantTonal.
  ///
  /// In en, this message translates to:
  /// **'Tonal'**
  String get settingsVariantTonal;

  /// No description provided for @settingsVariantNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get settingsVariantNeutral;

  /// No description provided for @settingsVariantMonochrome.
  ///
  /// In en, this message translates to:
  /// **'Monochrome'**
  String get settingsVariantMonochrome;

  /// No description provided for @settingsSelectColor.
  ///
  /// In en, this message translates to:
  /// **'Select color'**
  String get settingsSelectColor;

  /// No description provided for @settingsLaps.
  ///
  /// In en, this message translates to:
  /// **'Number of laps'**
  String get settingsLaps;

  /// No description provided for @settingsHalfTime.
  ///
  /// In en, this message translates to:
  /// **'Duration of each half'**
  String get settingsHalfTime;

  /// No description provided for @settingsLocked.
  ///
  /// In en, this message translates to:
  /// **'Cannot be changed while the timer is active'**
  String get settingsLocked;

  /// No description provided for @settingsVolume.
  ///
  /// In en, this message translates to:
  /// **'Voice volume'**
  String get settingsVolume;

  /// No description provided for @walkingSlow.
  ///
  /// In en, this message translates to:
  /// **'Walking slowly'**
  String get walkingSlow;

  /// No description provided for @walkingFast.
  ///
  /// In en, this message translates to:
  /// **'Walking briskly'**
  String get walkingFast;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Interval walking in progress'**
  String get notificationTitle;

  /// No description provided for @notificationText.
  ///
  /// In en, this message translates to:
  /// **'Lap {lap}/{total}'**
  String notificationText(int lap, int total);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
