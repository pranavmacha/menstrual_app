import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../core/constants/colors.dart';
import '../education/education_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final titles = ['HerTrack', 'Health Hub'];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_selectedIndex]),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _DashboardView(
              onNavigateToLearn: () => _onItemTapped(1),
              onRefresh: () =>
                  setState(() {}), // Refresh when returning from calendar
            ),
            const EducationScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textLight,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Learn'),
        ],
      ),
    );
  }
}

class _DashboardView extends StatefulWidget {
  final VoidCallback onNavigateToLearn;
  final VoidCallback onRefresh;

  const _DashboardView({
    required this.onNavigateToLearn,
    required this.onRefresh,
  });

  @override
  State<_DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<_DashboardView> {
  late Box box;
  DateTime? lastPeriodStart;
  DateTime? lastPeriodEnd;
  List<Map<String, dynamic>> periodLogs = [];

  @override
  void initState() {
    super.initState();
    box = Hive.box('cycleData');
    _loadData();
  }

  void _loadData() {
    final storedLogs = box.get('periodLogs', defaultValue: []);
    setState(() {
      periodLogs = (storedLogs as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
      lastPeriodStart = box.get('lastPeriodStart');
      lastPeriodEnd = box.get('lastPeriodEnd');
    });
  }

  // Calculate average cycle length (start to start)
  double? getAverageCycleLength() {
    if (periodLogs.length < 2) return null;
    List<int> lengths = [];
    for (int i = 1; i < periodLogs.length; i++) {
      final prevStart = DateTime.parse(periodLogs[i - 1]["start"]);
      final currStart = DateTime.parse(periodLogs[i]["start"]);
      lengths.add(currStart.difference(prevStart).inDays);
    }
    return lengths.reduce((a, b) => a + b) / lengths.length;
  }

  // Predict next period
  DateTime? predictNextPeriod() {
    if (periodLogs.isEmpty) return null;
    final lastLog = periodLogs.last;
    final lastStart = DateTime.parse(lastLog["start"]);
    final avg = getAverageCycleLength() ?? 28;
    return lastStart.add(Duration(days: avg.round()));
  }

  // Get current cycle day
  int? getCurrentCycleDay() {
    if (periodLogs.isEmpty && lastPeriodStart == null) return null;

    DateTime referenceStart;
    if (lastPeriodStart != null && lastPeriodEnd == null) {
      // Currently on period
      referenceStart = lastPeriodStart!;
    } else if (periodLogs.isNotEmpty) {
      // Use last completed period
      referenceStart = DateTime.parse(periodLogs.last["start"]);
    } else {
      return null;
    }

    return DateTime.now().difference(referenceStart).inDays + 1;
  }

  // Get days until next period
  int? getDaysUntilNextPeriod() {
    final predicted = predictNextPeriod();
    if (predicted == null) return null;
    final diff = predicted.difference(DateTime.now()).inDays;
    return diff > 0 ? diff : 0;
  }

  // Get cycle phase
  String getCyclePhase(int? cycleDay, double avgCycle) {
    if (cycleDay == null) return "Unknown";

    if (cycleDay <= 5) return "Menstrual";
    if (cycleDay <= avgCycle / 2) return "Follicular";
    if (cycleDay <= (avgCycle / 2) + 2) return "Ovulation";
    return "Luteal";
  }

  // Get phase-specific tips
  List<String> getPhaseSpecificTips(String phase) {
    switch (phase) {
      case "Menstrual":
        return [
          "Drink at least 8 cups of water to ease bloating.",
          "Prioritize iron-rich foods like spinach and lentils.",
          "Take gentle walks or do light yoga for cramps.",
          "Rest well - your body needs extra sleep now.",
        ];
      case "Follicular":
        return [
          "Great time for high-intensity workouts!",
          "Boost creativity - try new recipes or projects.",
          "Energy is high - tackle challenging tasks.",
          "Stay hydrated and eat protein-rich meals.",
        ];
      case "Ovulation":
        return [
          "Peak energy - perfect for social activities!",
          "Maintain balanced meals with healthy fats.",
          "Great time for important meetings or events.",
          "Stay active with cardio or dance workouts.",
        ];
      case "Luteal":
        return [
          "Manage cravings with healthy snacks.",
          "Practice stress-relief activities like meditation.",
          "Gentle exercises like swimming work best.",
          "Get 7-8 hours of quality sleep nightly.",
        ];
      default:
        return [
          "Start tracking your cycle for personalized tips!",
          "Drink plenty of water throughout the day.",
          "Maintain a balanced diet with fruits and veggies.",
          "Aim for 30 minutes of movement daily.",
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final avgCycle = getAverageCycleLength() ?? 28;
    final currentDay = getCurrentCycleDay();
    final daysUntil = getDaysUntilNextPeriod();
    final phase = getCyclePhase(currentDay, avgCycle);
    final tips = getPhaseSpecificTips(phase);

    return RefreshIndicator(
      onRefresh: () async {
        _loadData();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hi, welcome back 🌸",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _CycleSummaryCard(
              daysUntil: daysUntil,
              currentDay: currentDay,
              avgCycle: avgCycle.round(),
              phase: phase,
              isOnPeriod: lastPeriodStart != null && lastPeriodEnd == null,
            ),
            const SizedBox(height: 24),
            _QuickActionRow(onRefresh: _loadData),
            const SizedBox(height: 24),
            _SymptomHighlightCard(phase: phase),
            const SizedBox(height: 24),
            _WellnessChecklist(tips: tips, phase: phase),
            const SizedBox(height: 24),
            _EducationPreviewCard(onNavigateToLearn: widget.onNavigateToLearn),
          ],
        ),
      ),
    );
  }
}

class _CycleSummaryCard extends StatelessWidget {
  final int? daysUntil;
  final int? currentDay;
  final int avgCycle;
  final String phase;
  final bool isOnPeriod;

  const _CycleSummaryCard({
    required this.daysUntil,
    required this.currentDay,
    required this.avgCycle,
    required this.phase,
    required this.isOnPeriod,
  });

  @override
  Widget build(BuildContext context) {
    String mainText;
    String subText;
    double progress;

    if (currentDay == null) {
      mainText = "Start tracking your cycle";
      subText =
          "Open the calendar to log your first period and get personalized predictions.";
      progress = 0.0;
    } else if (isOnPeriod) {
      mainText = "You're on your period (Day $currentDay)";
      subText =
          "Take it easy and stay hydrated. Track symptoms for better insights.";
      progress = currentDay! / 7; // Assume average 7-day period
    } else if (daysUntil != null && daysUntil! > 0) {
      mainText =
          "Next period in $daysUntil ${daysUntil! == 1 ? 'day' : 'days'}";
      subText =
          "Cycle day $currentDay of an average $avgCycle-day rhythm. You're in the $phase phase.";
      progress = currentDay! / avgCycle;
    } else {
      mainText = "Period expected today or soon";
      subText = "Cycle day $currentDay. Your period might start anytime now.";
      progress = 1.0;
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isOnPeriod ? Icons.water_drop : Icons.calendar_today,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    mainText,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(subText, style: const TextStyle(color: AppColors.textLight)),
            if (currentDay != null) ...[
              const SizedBox(height: 18),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 10,
                  backgroundColor: AppColors.accent,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${(progress * 100).clamp(0, 100).round()}% complete',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textLight,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _QuickActionRow extends StatelessWidget {
  final VoidCallback onRefresh;

  const _QuickActionRow({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            icon: Icons.calendar_today,
            title: 'Open calendar',
            subtitle: 'Review past cycles and plan ahead.',
            onTap: () async {
              await Navigator.pushNamed(context, '/calendar');
              onRefresh(); // Refresh data when returning
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionCard(
            icon: Icons.edit_note,
            title: 'Log symptoms',
            subtitle: 'Add today\'s mood, cramps, or notes.',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Symptom logging is coming soon!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1F000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.accent,
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: AppColors.textLight, height: 1.3),
            ),
          ],
        ),
      ),
    );
  }
}

class _SymptomHighlightCard extends StatelessWidget {
  final String phase;

  const _SymptomHighlightCard({required this.phase});

  Map<String, List<String>> get phaseSymptoms => {
    "Menstrual": ["Cramps", "Fatigue", "Low mood", "Bloating"],
    "Follicular": ["High energy", "Clear skin", "Positive mood", "Focus"],
    "Ovulation": ["Peak energy", "Confidence", "Social", "Libido peak"],
    "Luteal": ["Cravings", "Mood swings", "Breast tenderness", "Fatigue"],
    "Unknown": ["No data yet", "Start tracking"],
  };

  @override
  Widget build(BuildContext context) {
    final symptoms = phaseSymptoms[phase] ?? phaseSymptoms["Unknown"]!;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Common in $phase phase',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (phase != "Unknown") ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      phase,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: symptoms
                  .map((symptom) => _SymptomChip(label: symptom))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Text(
              phase == "Unknown"
                  ? "Start tracking to get insights about your cycle phases."
                  : "These are common symptoms. Track yours for personalized insights.",
              style: const TextStyle(color: AppColors.textLight),
            ),
          ],
        ),
      ),
    );
  }
}

class _SymptomChip extends StatelessWidget {
  final String label;

  const _SymptomChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _WellnessChecklist extends StatelessWidget {
  final List<String> tips;
  final String phase;

  const _WellnessChecklist({required this.tips, required this.phase});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Today\'s wellness checklist',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                if (phase != "Unknown")
                  Icon(
                    Icons.emoji_emotions,
                    color: AppColors.primary,
                    size: 20,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            ...tips.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                          color: AppColors.textDark,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EducationPreviewCard extends StatelessWidget {
  final VoidCallback onNavigateToLearn;

  const _EducationPreviewCard({required this.onNavigateToLearn});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.school, color: AppColors.primary),
                SizedBox(width: 12),
                Text(
                  'Discover more in the Health Hub',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Learn about cycle phases, hygiene, eco-friendly products, nutrition, and myth busting.',
              style: TextStyle(color: AppColors.textLight, height: 1.4),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: onNavigateToLearn,
                child: const Text('Explore now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
