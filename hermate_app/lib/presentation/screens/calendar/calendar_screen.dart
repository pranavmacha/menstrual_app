import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hive/hive.dart';
import '../../../core/constants/colors.dart';
import 'log_history_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late Box box;
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  DateTime? lastPeriodStart;
  DateTime? lastPeriodEnd;
  List<Map<String, dynamic>> periodLogs = [];

  Key _calendarKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    box = Hive.box('cycleData');
    _loadData();
    selectedDay = DateTime.now();
  }

  void _resetHistoryData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("⚠️ Confirm Reset"),
        content: const Text(
          "This will delete all your period history and reset the calendar. "
          "Are you sure you want to continue?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              box.delete('periodLogs');
              box.delete('lastPeriodStart');
              box.delete('lastPeriodEnd');

              setState(() {
                periodLogs.clear();
                lastPeriodStart = null;
                lastPeriodEnd = null;
                selectedDay = DateTime.now();
                _calendarKey = UniqueKey();
              });

              _toast("🗑️ All history and calendar data have been reset");
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  void _loadData() {
    final storedLogs = box.get('periodLogs', defaultValue: []);
    periodLogs = (storedLogs as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();

    setState(() {
      lastPeriodStart = box.get('lastPeriodStart');
      lastPeriodEnd = box.get('lastPeriodEnd');
    });
  }

  String _formatDate(DateTime date) => "${date.day}-${date.month}-${date.year}";

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }

  void logPeriodStart() {
    if (selectedDay == null) {
      _toast("Select a date first 🌸");
      return;
    }

    if (lastPeriodStart != null && lastPeriodEnd == null) {
      _toast("You already have an ongoing cycle! Mark it ended first 🌺");
      return;
    }

    box.put('lastPeriodStart', selectedDay);
    box.delete('lastPeriodEnd');

    setState(() {
      lastPeriodStart = selectedDay;
      lastPeriodEnd = null;
      selectedDay = DateTime.now();
      _calendarKey = UniqueKey();
    });

    _toast("🩸 Period start logged: ${_formatDate(lastPeriodStart!)}");
  }

  void logPeriodEnd() {
    if (selectedDay == null) {
      _toast("Select a date first 🌷");
      return;
    }
    if (lastPeriodStart == null) {
      _toast("Please log a period start first 💗");
      return;
    }
    if (selectedDay!.isBefore(lastPeriodStart!)) {
      _toast("End date cannot be before start date ❌");
      return;
    }

    final periodLength = selectedDay!.difference(lastPeriodStart!).inDays + 1;
    if (periodLength > 10) {
      _showLongPeriodDialog(periodLength);
      return;
    }

    _completePeriodLog();
  }

  void _showLongPeriodDialog(int days) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("⚠️ Long Period Duration"),
        content: Text(
          "This period is $days days long, which is unusually long. "
          "Are you sure the dates are correct?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _completePeriodLog();
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  void _completePeriodLog() {
    box.put('lastPeriodEnd', selectedDay);

    final newLog = <String, dynamic>{
      "start": lastPeriodStart!.toIso8601String(),
      "end": selectedDay!.toIso8601String(),
    };
    periodLogs.add(newLog);
    box.put('periodLogs', periodLogs);

    setState(() {
      lastPeriodEnd = selectedDay;
      selectedDay = DateTime.now();
      _calendarKey = UniqueKey();
    });

    _toast("✅ Period end logged: ${_formatDate(lastPeriodEnd!)}");
  }

  void resetCalendarData() {
    box.delete('lastPeriodStart');
    box.delete('lastPeriodEnd');
    setState(() {
      lastPeriodStart = null;
      lastPeriodEnd = null;
      selectedDay = DateTime.now();
      _calendarKey = UniqueKey();
    });
    _toast("🔄 Calendar reset successfully");
  }

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

  DateTime? predictNextPeriod() {
    if (periodLogs.isEmpty) return null;
    final lastLog = periodLogs.last;
    final lastStart = DateTime.parse(lastLog["start"]);
    final avg = getAverageCycleLength() ?? 28;
    return lastStart.add(Duration(days: avg.round()));
  }

  int? getCurrentCycleDay() {
    if (lastPeriodStart == null) return null;
    if (lastPeriodEnd != null) return null;
    return DateTime.now().difference(lastPeriodStart!).inDays + 1;
  }

  bool _isPeriodDay(DateTime day) {
    for (var log in periodLogs) {
      final start = DateTime.parse(log["start"]);
      final end = DateTime.parse(log["end"]);
      if (day.isAfter(start.subtract(const Duration(days: 1))) &&
          day.isBefore(end.add(const Duration(days: 1)))) {
        return true;
      }
    }

    if (lastPeriodStart != null && lastPeriodEnd == null) {
      if (day.isAfter(lastPeriodStart!.subtract(const Duration(days: 1))) &&
          day.isBefore(DateTime.now().add(const Duration(days: 1)))) {
        return true;
      }
    }

    return false;
  }

  bool _isPredictedPeriodDay(DateTime day) {
    final predicted = predictNextPeriod();
    if (predicted == null) return false;

    return day.isAfter(predicted.subtract(const Duration(days: 1))) &&
        day.isBefore(predicted.add(const Duration(days: 5)));
  }

  @override
  Widget build(BuildContext context) {
    final avgCycle = getAverageCycleLength();
    final predictedNext = predictNextPeriod();
    final currentCycleDay = getCurrentCycleDay();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cycle Calendar"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LogHistoryScreen(
                    logs: periodLogs,
                    onDeleteHistory: () {
                      box.put('periodLogs', []);
                      setState(() => periodLogs.clear());
                      _toast("🗑️ History deleted successfully");
                    },
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: resetCalendarData,
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                const SizedBox(height: 10),
                TableCalendar(
                  key: _calendarKey,
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: focusedDay,
                  selectedDayPredicate: (day) => isSameDay(selectedDay, day),
                  onDaySelected: (selected, focused) {
                    setState(() {
                      selectedDay = selected;
                      focusedDay = focused;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    weekendTextStyle: const TextStyle(color: Colors.pink),
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      if (_isPeriodDay(day)) {
                        return Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.pink.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        );
                      }
                      if (_isPredictedPeriodDay(day)) {
                        return Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade50,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.purple.shade200,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: TextStyle(color: Colors.purple.shade700),
                            ),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendItem(Colors.pink.shade100, "Period Days"),
                      const SizedBox(width: 15),
                      _buildLegendItem(
                        Colors.purple.shade50,
                        "Predicted",
                        borderColor: Colors.purple.shade200,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                if (lastPeriodStart != null && lastPeriodEnd == null)
                  Text(
                    "🩸 Period Start: ${_formatDate(lastPeriodStart!)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                if (lastPeriodStart != null && lastPeriodEnd != null)
                  Text(
                    "✅ Last Period: ${_formatDate(lastPeriodStart!)} - ${_formatDate(lastPeriodEnd!)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                const SizedBox(height: 10),
                if (avgCycle != null)
                  Text(
                    "📅 Avg Cycle Length: ${avgCycle.toStringAsFixed(1)} days",
                    style: const TextStyle(fontSize: 15),
                  ),
                if (predictedNext != null)
                  Text(
                    "🔮 Next Period: ${_formatDate(predictedNext)}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                if (currentCycleDay != null)
                  Text(
                    "🌼 Current Period Day: $currentCycleDay",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ), // ✅ Fixed: Replaced Spacer with SizedBox
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: resetCalendarData,
                              icon: const Icon(Icons.refresh),
                              label: const Text(
                                "Reset Calendar",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey.shade100,
                                foregroundColor: Colors.black87,
                                minimumSize: const Size(double.infinity, 45),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _resetHistoryData,
                              icon: const Icon(Icons.delete_forever),
                              label: const Text(
                                "Reset History",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade100,
                                foregroundColor: Colors.red.shade700,
                                minimumSize: const Size(double.infinity, 45),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: logPeriodStart,
                        icon: const Icon(Icons.favorite),
                        label: const Text(
                          "Mark Period Started",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: logPeriodEnd,
                        icon: const Icon(Icons.favorite_border),
                        label: const Text(
                          "Mark Period Ended",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink.shade200,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, {Color? borderColor}) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: borderColor != null
                ? Border.all(color: borderColor, width: 2)
                : null,
          ),
        ),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
