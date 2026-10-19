// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'インターバル速歩タイマー';

  @override
  String get start => 'スタート';

  @override
  String get pause => '一時停止';

  @override
  String get stop => 'ストップ';

  @override
  String get settings => '設定';

  @override
  String get about => 'バージョン情報';

  @override
  String get stopConfirmTitle => 'タイマーを停止しますか？';

  @override
  String get stopConfirmMessage => '現在の進捗はクリアされます。';

  @override
  String get cancel => 'キャンセル';

  @override
  String get ok => 'OK';

  @override
  String lapProgress(int lap, int total) {
    return '$lap/$total';
  }

  @override
  String speechLap(int lap) {
    return '第$lapラップです。';
  }

  @override
  String get speechSlowWalk => 'ゆっくり歩いてください';

  @override
  String get speechFastWalk => '早足で歩いてください';

  @override
  String get speechFinished => 'これで終了です。お疲れ様でした。';

  @override
  String get settingsColorScheme => '配色';

  @override
  String get settingsSchemeSystem => 'システムに従う';

  @override
  String get settingsSchemeCustom => 'カスタム';

  @override
  String get settingsSeedColor => 'テーマカラー';

  @override
  String get settingsColorVariant => 'カラーバリエーション';

  @override
  String get settingsVariantFidelity => '充実';

  @override
  String get settingsVariantTonal => 'トーン';

  @override
  String get settingsVariantNeutral => 'ニュートラル';

  @override
  String get settingsVariantMonochrome => 'モノクロ';

  @override
  String get settingsSelectColor => '色を選択';

  @override
  String get settingsLaps => 'ラップ数';

  @override
  String get settingsHalfTime => '前半・後半それぞれの時間';

  @override
  String get settingsLocked => 'タイマーの動作中は変更できません';

  @override
  String get settingsVolume => '音声の音量';

  @override
  String get walkingSlow => 'ゆっくり歩く';

  @override
  String get walkingFast => '早足で歩く';

  @override
  String get notificationTitle => 'インターバル速歩を実行中';

  @override
  String notificationText(int lap, int total) {
    return 'ラップ $lap/$total';
  }
}
