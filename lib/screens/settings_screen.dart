import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:japanese_interval_walking_timer/l10n/app_localizations.dart';
import 'package:japanese_interval_walking_timer/services/settings_provider.dart';
import 'package:japanese_interval_walking_timer/services/walking_timer_controller.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = context.watch<SettingsProvider>();
    final idle =
        context.watch<WalkingTimerController>().status == TimerStatus.idle;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _header(Icons.wallpaper, l10n.settingsColorScheme),
          const SizedBox(height: 12),
          SegmentedButton<bool>(
            key: const Key('schemeSelector'),
            segments: [
              ButtonSegment(
                value: true,
                label: Text(l10n.settingsSchemeSystem),
              ),
              ButtonSegment(
                value: false,
                label: Text(l10n.settingsSchemeCustom),
              ),
            ],
            selected: {settings.followSystem},
            onSelectionChanged: (s) => settings.followSystem = s.first,
          ),
          const SizedBox(height: 24),
          if (!settings.followSystem) ...[
            _header(Icons.palette, l10n.settingsSeedColor),
            const SizedBox(height: 12),
            Row(
              children: [
                ColorIndicator(
                  key: const Key('seedColorIndicator'),
                  color: settings.seedColor,
                  onSelectFocus: false,
                  onSelect: () => _pickColor(context, settings, l10n),
                ),
                const SizedBox(width: 16),
                Text(ColorTools.nameThatColor(settings.seedColor)),
              ],
            ),
            const SizedBox(height: 24),
            _header(Icons.mood, l10n.settingsColorVariant),
            const SizedBox(height: 12),
            SegmentedButton<DynamicSchemeVariant>(
              key: const Key('variantSelector'),
              segments: [
                ButtonSegment(
                  value: DynamicSchemeVariant.fidelity,
                  label: Text(l10n.settingsVariantFidelity),
                ),
                ButtonSegment(
                  value: DynamicSchemeVariant.tonalSpot,
                  label: Text(l10n.settingsVariantTonal),
                ),
                ButtonSegment(
                  value: DynamicSchemeVariant.neutral,
                  label: Text(l10n.settingsVariantNeutral),
                ),
                ButtonSegment(
                  value: DynamicSchemeVariant.monochrome,
                  label: Text(l10n.settingsVariantMonochrome),
                ),
              ],
              selected: {settings.schemeVariant},
              onSelectionChanged: (s) => settings.schemeVariant = s.first,
            ),
            const SizedBox(height: 24),
          ],
          _header(Icons.repeat, l10n.settingsLaps),
          Row(
            children: [
              Expanded(
                child: Slider(
                  key: const Key('lapsSlider'),
                  value: settings.totalLaps.toDouble(),
                  min: SettingsProvider.minLaps.toDouble(),
                  max: SettingsProvider.maxLaps.toDouble(),
                  divisions:
                      SettingsProvider.maxLaps - SettingsProvider.minLaps,
                  label: '${settings.totalLaps}',
                  onChanged: idle
                      ? (v) => settings.totalLaps = v.round()
                      : null,
                ),
              ),
              SizedBox(
                width: 56,
                child: Text(
                  '${settings.totalLaps}',
                  key: const Key('lapsValue'),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _header(Icons.timer, l10n.settingsHalfTime),
          Row(
            children: [
              Expanded(
                child: Slider(
                  key: const Key('halfSlider'),
                  value: settings.halfSeconds.toDouble(),
                  min: SettingsProvider.minHalfSeconds.toDouble(),
                  max: SettingsProvider.maxHalfSeconds.toDouble(),
                  divisions:
                      (SettingsProvider.maxHalfSeconds -
                          SettingsProvider.minHalfSeconds) ~/
                      10,
                  label: _formatSeconds(settings.halfSeconds),
                  onChanged: idle
                      ? (v) => settings.halfSeconds = (v / 10).round() * 10
                      : null,
                ),
              ),
              SizedBox(
                width: 56,
                child: Text(
                  _formatSeconds(settings.halfSeconds),
                  key: const Key('halfValue'),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          if (!idle)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(l10n.settingsLocked),
            ),
          const SizedBox(height: 24),
          _header(Icons.volume_up, l10n.settingsVolume),
          Slider(
            key: const Key('volumeSlider'),
            value: settings.volume,
            divisions: 10,
            label: '${(settings.volume * 100).round()}%',
            onChanged: (v) => settings.volume = v,
          ),
        ],
      ),
    );
  }

  String _formatSeconds(int s) =>
      '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';

  Widget _header(IconData icon, String text) => Row(
    children: [
      Icon(icon),
      const SizedBox(width: 12),
      Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    ],
  );

  Future<void> _pickColor(
    BuildContext context,
    SettingsProvider settings,
    AppLocalizations l10n,
  ) async {
    final saved = settings.seedColor;
    final ok = await ColorPicker(
      color: saved,
      onColorChanged: (c) => settings.seedColor = c,
      heading: Text(l10n.settingsSelectColor),
      showMaterialName: true,
      showColorName: true,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.primary: true,
        ColorPickerType.accent: false,
        ColorPickerType.wheel: true,
      },
    ).showPickerDialog(context);
    if (!ok) settings.seedColor = saved;
  }
}
