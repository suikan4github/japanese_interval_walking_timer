import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this._prefs)
    : _seedColor = Color(
        _prefs.getInt(_seedKey) ?? defaultSeedColor.toARGB32(),
      ),
      _followSystem = _prefs.getBool(_followSystemKey) ?? true,
      _schemeVariant = _loadVariant(_prefs.getString(_variantKey)),
      _totalLaps = (_prefs.getInt(_lapsKey) ?? defaultLaps).clamp(
        minLaps,
        maxLaps,
      ),
      _halfSeconds = (_prefs.getInt(_halfKey) ?? defaultHalfSeconds).clamp(
        minHalfSeconds,
        maxHalfSeconds,
      ),
      _volume = (_prefs.getDouble(_volumeKey) ?? 1.0).clamp(0.0, 1.0);

  static const _seedKey = 'seedColor';
  static const _followSystemKey = 'followSystem';
  static const _volumeKey = 'volume';
  static const _variantKey = 'schemeVariant';
  static const supportedVariants = <DynamicSchemeVariant>[
    DynamicSchemeVariant.fidelity,
    DynamicSchemeVariant.tonalSpot,
    DynamicSchemeVariant.neutral,
    DynamicSchemeVariant.monochrome,
  ];
  static const defaultVariant = DynamicSchemeVariant.tonalSpot;

  static DynamicSchemeVariant _loadVariant(String? name) => supportedVariants
      .firstWhere((v) => v.name == name, orElse: () => defaultVariant);

  static const _lapsKey = 'totalLaps';
  static const _halfKey = 'halfSeconds';
  static const int minLaps = 1;
  static const int maxLaps = 15;
  static const int defaultLaps = 10;
  static const int minHalfSeconds = 10;
  static const int maxHalfSeconds = 300;
  static const int defaultHalfSeconds = 180;
  static const defaultSeedColor = Color(0xFF1E90FF); // Dodger Blue

  final SharedPreferences _prefs;
  Color _seedColor;
  double _volume;
  bool _followSystem;
  DynamicSchemeVariant _schemeVariant;
  int _totalLaps;
  int _halfSeconds;

  Color get seedColor => _seedColor;
  double get volume => _volume;
  bool get followSystem => _followSystem;
  DynamicSchemeVariant get schemeVariant => _schemeVariant;

  set schemeVariant(DynamicSchemeVariant value) {
    _schemeVariant = value;
    _prefs.setString(_variantKey, value.name);
    notifyListeners();
  }

  int get totalLaps => _totalLaps;
  int get halfSeconds => _halfSeconds;

  set totalLaps(int value) {
    _totalLaps = value.clamp(minLaps, maxLaps);
    _prefs.setInt(_lapsKey, _totalLaps);
    notifyListeners();
  }

  set halfSeconds(int value) {
    _halfSeconds = value.clamp(minHalfSeconds, maxHalfSeconds);
    _prefs.setInt(_halfKey, _halfSeconds);
    notifyListeners();
  }

  set followSystem(bool value) {
    _followSystem = value;
    _prefs.setBool(_followSystemKey, value);
    notifyListeners();
  }

  set seedColor(Color value) {
    _seedColor = value;
    _prefs.setInt(_seedKey, value.toARGB32());
    notifyListeners();
  }

  set volume(double value) {
    _volume = value.clamp(0.0, 1.0);
    _prefs.setDouble(_volumeKey, _volume);
    notifyListeners();
  }
}
