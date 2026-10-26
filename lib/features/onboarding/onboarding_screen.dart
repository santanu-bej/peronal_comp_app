import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers.dart';
import '../../core/theme/clay_tokens.dart';
import '../../core/widgets/clay_controls.dart';
import '../../core/widgets/screen.dart';
import '../goals/goal_sheet.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});
  @override
  ConsumerState<OnboardingScreen> createState() => _S();
}

class _S extends ConsumerState<OnboardingScreen> {
  int _step = 0;
  final _name = TextEditingController(text: 'Santanu');
  final _about = TextEditingController();
  final _key = TextEditingController();
  bool _testing = false;
  String? _keyMsg;
  bool _keyOk = false;

  Future<void> _finish(String? goalId, bool plan) async {
    final db = ref.read(dbProvider);
    await db.setSetting('onboarded', true);
    if (!mounted) return;
    context.go('/home');
    if (goalId != null && plan) context.push('/plan/$goalId');
    context.push('/setup');
  }

  Future<void> _step1() async {
    final db = ref.read(dbProvider);
    await db.setSetting('user.name', _name.text.trim().isEmpty ? 'Santanu' : _name.text.trim());
    await db.setSetting('user.about', _about.text.trim());
    setState(() => _step = 1);
  }

  Future<void> _testKey() async {
    setState(() { _testing = true; _keyMsg = null; });
    final err = await ref.read(aiClientProvider).testKey(_key.text.trim());
    if (err == null) {
      await ref.read(secretsProvider).setAiKey(_key.text.trim());
      await ref.read(dbProvider).setSetting('ai.off', false);
      ref.invalidate(aiReadyProvider);
    }
    setState(() { _testing = false; _keyOk = err == null; _keyMsg = err ?? 'Key works and is saved.'; });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.clay;
    final t = Theme.of(context).textTheme;
    Widget body;
    switch (_step) {
      case 0:
        body = Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('Goal Compass', style: t.headlineLarge),
          const SizedBox(height: 8),
          Text('What am I working toward? Is what I am doing right now helping? Am I on pace?', style: t.bodyLarge?.copyWith(color: c.inkMuted)),
          const SizedBox(height: 24),
          ClayTextField(label: 'Your name', controller: _name),
          const SizedBox(height: 14),
          ClayTextField(label: 'About me (optional, ≤ 200 chars, helps AI planning)', controller: _about, maxLength: 200, maxLines: 3, hint: 'IT services company, 6 staff…'),
          const SizedBox(height: 24),
          ClayButton('Next', onPressed: _step1),
        ]);
      case 1:
        body = Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('Gemini API key', style: t.headlineLarge),
          const SizedBox(height: 8),
          Text('Free key from Google AI Studio. Used only for planning, scoring odd todos and the weekly review. Stored encrypted on this phone.', style: t.bodyLarge?.copyWith(color: c.inkMuted)),
          const SizedBox(height: 24),
          ClayTextField(label: 'API key', controller: _key, obscure: true, hint: 'AIza…'),
          if (_keyMsg != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_keyMsg!, style: TextStyle(color: _keyOk ? c.mint : c.rose, fontWeight: FontWeight.w700))),
          const SizedBox(height: 16),
          ClayButton('Test key', kind: ClayButtonKind.soft, busy: _testing, onPressed: _key.text.trim().isEmpty ? null : _testKey),
          const SizedBox(height: 12),
          ClayButton(_keyOk ? 'Next' : 'Skip, use without AI', onPressed: () async {
            if (!_keyOk) await ref.read(dbProvider).setSetting('ai.off', true);
            setState(() => _step = 2);
          }),
        ]);
      default:
        body = Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('Your first goal', style: t.headlineLarge),
          const SizedBox(height: 8),
          Text('Title, deadline and why. You can add more later.', style: t.bodyLarge?.copyWith(color: c.inkMuted)),
          const SizedBox(height: 20),
          GoalForm(onSaved: _finish),
          const SizedBox(height: 12),
          ClayButton('Skip for now', kind: ClayButtonKind.soft, onPressed: () => _finish(null, false)),
        ]);
    }
    return ClayScreen(
      title: '',
      bottomPad: 40,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [for (var i = 0; i < 3; i++) Container(margin: const EdgeInsets.all(4), width: i == _step ? 28 : 10, height: 10, decoration: BoxDecoration(color: i <= _step ? c.primary : c.surfaceAlt, borderRadius: BorderRadius.circular(5)))]),
        const SizedBox(height: 24),
        body,
      ],
    );
  }
}
