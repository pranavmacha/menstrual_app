import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class LogHistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> logs;
  final VoidCallback onDeleteHistory;

  const LogHistoryScreen({
    super.key,
    required this.logs,
    required this.onDeleteHistory,
  });

  String formatDate(String iso) {
    final date = DateTime.parse(iso);
    return "${date.day}-${date.month}-${date.year}";
  }

  String formatDateLong(String iso) {
    final date = DateTime.parse(iso);
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  int calculatePeriodLength(Map<String, dynamic> log) {
    final start = DateTime.parse(log["start"]);
    final end = DateTime.parse(log["end"]);
    return end.difference(start).inDays + 1;
  }

  int? calculateCycleLength(int index) {
    if (index == 0) return null; // No previous cycle
    final currentStart = DateTime.parse(logs[index]["start"]);
    final previousStart = DateTime.parse(logs[index - 1]["start"]);
    return currentStart.difference(previousStart).inDays;
  }

  Map<String, dynamic> calculateStats() {
    if (logs.isEmpty) {
      return {
        'avgPeriodLength': 0.0,
        'avgCycleLength': 0.0,
        'shortestPeriod': 0,
        'longestPeriod': 0,
        'totalCycles': 0,
      };
    }

    List<int> periodLengths = [];
    List<int> cycleLengths = [];

    for (int i = 0; i < logs.length; i++) {
      periodLengths.add(calculatePeriodLength(logs[i]));
      final cycleLen = calculateCycleLength(i);
      if (cycleLen != null) cycleLengths.add(cycleLen);
    }

    return {
      'avgPeriodLength':
          periodLengths.reduce((a, b) => a + b) / periodLengths.length,
      'avgCycleLength': cycleLengths.isEmpty
          ? 0.0
          : cycleLengths.reduce((a, b) => a + b) / cycleLengths.length,
      'shortestPeriod': periodLengths.reduce((a, b) => a < b ? a : b),
      'longestPeriod': periodLengths.reduce((a, b) => a > b ? a : b),
      'totalCycles': logs.length,
    };
  }

  Color _getPeriodLengthColor(int days) {
    if (days <= 3) return Colors.orange;
    if (days <= 7) return Colors.green;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final stats = calculateStats();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cycle Log History"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppColors.background,
      body: logs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text(
                    "No logs recorded yet 🌸",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Start tracking your cycle to see history here",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Statistics Card
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, Colors.pink.shade300],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "📊 Your Cycle Statistics",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            "Total Cycles",
                            "${stats['totalCycles']}",
                            Icons.calendar_month,
                          ),
                          _buildStatItem(
                            "Avg Period",
                            "${stats['avgPeriodLength'].toStringAsFixed(1)} days",
                            Icons.favorite,
                          ),
                          if (stats['avgCycleLength'] > 0)
                            _buildStatItem(
                              "Avg Cycle",
                              "${stats['avgCycleLength'].toStringAsFixed(1)} days",
                              Icons.loop,
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            "Shortest",
                            "${stats['shortestPeriod']} days",
                            Icons.compress,
                          ),
                          _buildStatItem(
                            "Longest",
                            "${stats['longestPeriod']} days",
                            Icons.expand,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // History List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final reversedIndex = logs.length - 1 - index;
                      final log = logs[reversedIndex];
                      final periodLength = calculatePeriodLength(log);
                      final cycleLength = calculateCycleLength(reversedIndex);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.accent,
                            child: Text(
                              "${reversedIndex + 1}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            "Cycle ${reversedIndex + 1}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            "${formatDate(log["start"])} → ${formatDate(log["end"])}",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getPeriodLengthColor(
                                periodLength,
                              ).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "$periodLength days",
                              style: TextStyle(
                                color: _getPeriodLengthColor(periodLength),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(),
                                  _buildDetailRow(
                                    Icons.play_circle_outline,
                                    "Period Started",
                                    formatDateLong(log["start"]),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildDetailRow(
                                    Icons.stop_circle_outlined,
                                    "Period Ended",
                                    formatDateLong(log["end"]),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildDetailRow(
                                    Icons.schedule,
                                    "Period Duration",
                                    "$periodLength days",
                                    valueColor: _getPeriodLengthColor(
                                      periodLength,
                                    ),
                                  ),
                                  if (cycleLength != null) ...[
                                    const SizedBox(height: 8),
                                    _buildDetailRow(
                                      Icons.autorenew,
                                      "Cycle Length",
                                      "$cycleLength days (from previous cycle)",
                                      valueColor: Colors.purple,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Delete Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final confirm = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: const Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.orange,
                              ),
                              SizedBox(width: 8),
                              Text("Delete History?"),
                            ],
                          ),
                          content: const Text(
                            "This will permanently remove all your cycle logs. "
                            "This action cannot be undone.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text("Delete"),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true && context.mounted) {
                        onDeleteHistory();
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.delete_forever),
                    label: const Text(
                      "Delete All History",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
