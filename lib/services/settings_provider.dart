import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this._prefs)
    : _seedColor = Color(
        _prefs.getInt(_seedKey) ?? defaultSeedColor.toARGB32(),
      ),
      _followSystem = _prefs.getBool(_followSystemKey) ?? true,
      _volume = (_prefs.getDouble(_volumeKey) ?? 1.0).clamp(0.0, 1.0);

  static const _seedKey = 'seedColor';
  static const _followSystemKey = 'followSystem';
  static const _volumeKey = 'volume';
  static const defaultSeedColor = Color(0xFF1E90FF); // Dodger Blue

  final SharedPreferences _prefs;
  Color _seedColor;
  double _volume;
  bool _followSystem;

  Color get seedColor => _seedColor;
  double get volume => _volume;
  bool get followSystem => _followSystem;

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
