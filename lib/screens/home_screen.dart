import 'package:flutter/material.dart';
import 'package:japanese_interval_walking_timer/l10n/app_localizations.dart';
import 'package:japanese_interval_walking_timer/screens/settings_screen.dart';
import 'package:japanese_interval_walking_timer/services/background_service.dart';
import 'package:japanese_interval_walking_timer/services/walking_timer_controller.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.backgroundService});

  final BackgroundService backgroundService;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final WalkingTimerController _controller;
  TimerStatus _lastStatus = TimerStatus.idle;
  int _lastLap = 0;

  @override
  void initState() {
    super.initState();
    _controller = context.read<WalkingTimerController>();
    _controller.addListener(_syncBackground);
  }

  @override
  void dispose() {
    _controller.removeListener(_syncBackground);
    super.dispose();
  }

  void _syncBackground() {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final status = _controller.status;
    final text = l10n.notificationText(
      _controller.lap,
      WalkingTimerController.totalLaps,
    );
    if (status == TimerStatus.running && _lastStatus != TimerStatus.running) {
      widget.backgroundService.start(l10n.notificationTitle, text);
    } else if (status == TimerStatus.running && _lastLap != _controller.lap) {
      widget.backgroundService.update(l10n.notificationTitle, text);
    } else if (status != TimerStatus.running &&
        _lastStatus == TimerStatus.running) {
      widget.backgroundService.stop();
    }
    _lastStatus = status;
    _lastLap = _controller.lap;
  }

  Future<void> _confirmStop() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.stopConfirmTitle),
        content: Text(l10n.stopConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
    if (confirmed == true) _controller.stop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final timer = context.watch<WalkingTimerController>();
    final running = timer.status == TimerStatus.running;
    final idle = timer.status == TimerStatus.idle;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            tooltip: l10n.settings,
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 260,
              height: 260,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.expand(
                    child: CircularProgressIndicator(
                      key: const Key('lapProgress'),
                      value: timer.progress,
                      strokeWidth: 14,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        timer.isFastHalf
                            ? Icons.directions_run
                            : Icons.directions_walk,
                        key: Key(timer.isFastHalf ? 'fastIcon' : 'slowIcon'),
                        size: 96,
                        semanticLabel: timer.isFastHalf
                            ? l10n.walkingFast
                            : l10n.walkingSlow,
                      ),
                      Text(
                        l10n.lapProgress(
                          timer.lap,
                          WalkingTimerController.totalLaps,
                        ),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 12,
              children: [
                FilledButton.icon(
                  onPressed: running ? null : timer.start,
                  icon: const Icon(Icons.play_arrow),
                  label: Text(l10n.start),
                ),
                FilledButton.tonalIcon(
                  onPressed: running ? timer.pause : null,
                  icon: const Icon(Icons.pause),
                  label: Text(l10n.pause),
                ),
                FilledButton.tonalIcon(
                  onPressed: idle ? null : _confirmStop,
                  icon: const Icon(Icons.stop),
                  label: Text(l10n.stop),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
