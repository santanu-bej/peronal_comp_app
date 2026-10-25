import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers.dart';
import '../../core/repos/routine_repo.dart';
import '../../core/theme/clay_tokens.dart';
import '../../core/utils/time.dart';
import '../../core/widgets/clay_container.dart';
import '../../core/widgets/clay_controls.dart';
import '../../core/widgets/clay_progress.dart';

/// Opened by WakeActivity over the lock screen. No way out except proof (or snooze if allowed).
class WakeScreen extends ConsumerStatefulWidget {
  final String routineId;
  const WakeScreen({super.key, required this.routineId});
  @override
  ConsumerState<WakeScreen> createState() => _S();
}

class _S extends ConsumerState<WakeScreen> {
  WakeConfig _cfg = const WakeConfig();
  String _top = '';
  int _steps = 0, _snoozesLeft = 0;
  Timer? _poll, _clock;
  final _typed = TextEditingController();
  late List<(int, int)> _sums;
  final _answers = List.generate(3, (_) => TextEditingController());
  String _now = '';
  bool _done = false;

  @override
  void initState() {
    super.initState();
    final r = Random();
    _sums = List.generate(3, (_) => (10 + r.nextInt(89), 10 + r.nextInt(89)));
    _tick();
    _clock = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    _load();
  }

  void _tick() => setState(() => _now = timeLabel(DateTime.now().millisecondsSinceEpoch));

  Future<void> _load() async {
    final db = ref.read(dbProvider);
    final routines = await db.select(db.routines).get();
    final r = routines.where((x) => x.id == widget.routineId).firstOrNull;
    if (r != null) _cfg = WakeConfig.fromJson(r.configJson);
    final top = await ref.read(todoRepoProvider).topTodo();
    _top = top?.title ?? 'Start your day';
    final st = await ref.read(bridgeProvider).wakeState();
    _snoozesLeft = (st?['snoozesLeft'] as int?) ?? _cfg.snoozeMax;
    if (_cfg.proof == 'walk') {
      _poll = Timer.periodic(const Duration(milliseconds: 500), (_) async {
        final s = await ref.read(bridgeProvider).wakeSteps();
        if (mounted) setState(() => _steps = s);
        if (s >= 30) _finish();
      });
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _poll?.cancel();
    _clock?.cancel();
    super.dispose();
  }

  Future<void> _finish() async {
    if (_done) return;
    _done = true;
    _poll?.cancel();
    await ref.read(bridgeProvider).wakeProofDone(widget.routineId);
    if (mounted) context.go('/morning');
  }

  bool get _sumsOk {
    for (var i = 0; i < 3; i++) {
      if (int.tryParse(_answers[i].text.trim()) != _sums[i].$1 + _sums[i].$2) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    Widget proof;
    switch (_cfg.proof) {
      case 'type':
        proof = Column(children: [
          Text('Type this exactly to stop the alarm:', style: t.bodyMedium?.copyWith(color: Colors.white)),
          const SizedBox(height: 8),
          Text(_top, textAlign: TextAlign.center, style: t.titleLarge?.copyWith(color: Colors.white)),
          const SizedBox(height: 12),
          ClayTextField(controller: _typed, hint: 'Type the task title', onChanged: (v) { if (v.trim() == _top.trim()) _finish(); }),
        ]);
      case 'maths':
        proof = Column(children: [
          Text('Solve 3 sums to stop the alarm', style: t.bodyMedium?.copyWith(color: Colors.white)),
          const SizedBox(height: 8),
          for (var i = 0; i < 3; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ClayTextField(label: '${_sums[i].$1} + ${_sums[i].$2} =', controller: _answers[i], keyboardType: TextInputType.number, onChanged: (_) { if (_sumsOk) _finish(); }),
            ),
        ]);
      default:
        proof = Column(children: [
          ClayProgressRing(value: _steps / 30, color: Colors.white, size: 140, stroke: 14, center: Text('$_steps/30', style: const TextStyle(fontFamily: 'Fredoka', fontWeight: FontWeight.w600, fontSize: 32, color: Colors.white))),
          const SizedBox(height: 10),
          Text('Walk 30 steps to stop the alarm', style: t.bodyMedium?.copyWith(color: Colors.white)),
        ]);
    }
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFFF8A8A), Color(0xFFFFB48F)])),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - 80),
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Column(children: [
                    const SizedBox(height: 20),
                    Text(_now, style: const TextStyle(fontFamily: 'Fredoka', fontWeight: FontWeight.w600, fontSize: 64, color: Colors.white)),
                    const SizedBox(height: 8),
                    ClayContainer(color: Colors.white.withValues(alpha: 0.35), child: Row(children: [const Icon(Icons.flag_rounded, color: Colors.white), const SizedBox(width: 10), Expanded(child: Text(_top, style: t.titleMedium?.copyWith(color: Colors.white)))])),
                  ]),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 24), child: proof),
                  if (_snoozesLeft > 0)
                    TextButton(
                      onPressed: () async {
                        await ref.read(bridgeProvider).wakeSnooze(widget.routineId);
                        setState(() => _snoozesLeft--);
                      },
                      child: Text('Snooze 5 min ($_snoozesLeft left)', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    )
                  else
                    const SizedBox(height: 48),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: unused_element
const _unusedColors = ClayColors.light;
