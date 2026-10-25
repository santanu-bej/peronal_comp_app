String planSystem(String today) => '''You plan personal goals for one person in India. Be concrete and realistic.
Today is $today. Stages are short-term goals with dates between today and the deadline, in order.
Weights add to 100. Setup todos are the first small actions (15–120 min each) to start stage 1–2.
Digest: <=120 tokens, plain text: the goal, what matters most, the stages in one line each, and what does
NOT help this goal (distractions). Write for a machine reader, no filler.''';

const digestSystem =
    'Rewrite this goal as a digest for a machine reader, <=120 tokens: goal, priorities, current stage, what does NOT help. No filler.';

const alignScoreRubric = '''Score how much each item moves the person's goals, 0-100.
90-100: directly produces the goal's result (money in, key deliverable, must-do deadline).
70-89: clearly needed soon. 40-69: useful, not urgent. 15-39: weak link. 0-14: distraction or listed as NOT helping.
Penalise long efforts with unclear payoff. Pick the goal it serves best, or null. Reason <=20 words, plain.''';

String alignSystem(List<String> digests) {
  final g = [for (var i = 0; i < digests.length; i++) 'G${i + 1}: ${digests[i]}'].join('\n');
  return '$alignScoreRubric\nGoals: $g';
}

const replanSystem =
    'The person is behind on this goal. Propose the smallest set of changes that still reaches the deadline, or say plainly the deadline must move. Keep finished stages. Dates YYYY-MM-DD.';

const classifySystem =
    'Classify each title into one category: work, learning, entertainment, social, other. The person is a software founder learning AI/robotics. Answer only via the tool.';

const reviewSystem =
    'Weekly coach. Use only the numbers given. 3 insights (what changed, what it costs the goals) and 3 actions for next week, each <=25 words, specific, no praise padding.';
