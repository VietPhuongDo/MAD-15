import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/repositories/habit_repository.dart';
import '../auth/providers/auth_provider.dart';
import '../../../core/models/habit.dart';
import '../components/custom_scaffold.dart';

final habitsProvider = StreamProvider<List<Habit>>((ref) async* {
  final user = ref.read(userProvider).when(
    data: (userData) => userData,
    loading: () => null,
    error: (error, stackTrace) {
      return null;
    },
  );
  if (user == null) {
    yield* Stream.error('User not found!');
  } else {
    yield* ref.read(habitRepositoryProvider).getHabits(user.uid);
  }
});

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final scheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E9),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        title: const Text('Statictics'),
      ),
      body: Consumer(
        builder: (context, ref, _) {
          return ref.watch(habitsProvider).when(
            data: (habits) {
              final habitCounts = <String, int>{};
              final currentDate = DateTime.now();
              final formatter = DateFormat('dd-MM-yyyy');
              DateTime now = DateTime.now();
              final currentDateString = formatter.format(currentDate);
              habits.forEach((habit) {
                final completedDays = habit.completedDays;
                final a = completedDays.where((day) {
                  try {
                    final completedDay = parseDate(day);
                    return completedDay.month == now.month && completedDay.year == now.year;
                  } catch (e) {
                    return false;
                  }
                }).length;
                int daysPassed = now.day;
                int c=(a/daysPassed*100).toInt();
                habitCounts[habit.name] = c;
              });

              final data = habitCounts.entries
                  .map((entry) => charts.Series<HabitData, String>(
                id: entry.key,
                domainFn: (HabitData habitData, _) =>
                habitData.habitName,
                measureFn: (HabitData habitData, _) =>
                habitData.habitCount,
                data: [HabitData(entry.key, entry.value)],
              ))
                  .toList();

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Set background color here
                  borderRadius: BorderRadius.circular(10.0), // Set border radius as needed
                ),
                width: 400,
                height: 500,
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.all(10.0),
                child: charts.BarChart(
                  data,
                  animate: true,
                  barGroupingType: charts.BarGroupingType.grouped,
                  domainAxis: charts.OrdinalAxisSpec(
                    renderSpec: charts.SmallTickRendererSpec(
                      lineStyle: charts.LineStyleSpec(
                        color: charts.Color.transparent,
                      ),
                    ),
                    tickProviderSpec: charts.StaticOrdinalTickProviderSpec(
                      <charts.TickSpec<String>>[
                        for (var habitName in habitCounts.keys)
                          charts.TickSpec<String>(habitName),
                      ],
                    ),
                  ),
                  primaryMeasureAxis: const charts.NumericAxisSpec(
                    renderSpec: charts.GridlineRendererSpec(
                      labelStyle: charts.TextStyleSpec(
                        fontSize: 12, // Optional: Set font size for labels
                      ),
                      // Define the range of the y-axis
                      axisLineStyle: charts.LineStyleSpec(
                        color: charts.Color.transparent,
                      ),
                    ),
                    // Define the range of the y-axis
                    viewport: charts.NumericExtents(0, 100),
                  ),
                  barRendererDecorator: charts.BarLabelDecorator<String>(
                    labelPosition: charts.BarLabelPosition.inside,
                    labelPadding: 4,
                    outsideLabelStyleSpec: charts.TextStyleSpec(fontSize: 12),
                  ),
                  behaviors: [
                    charts.SeriesLegend(
                      position: charts.BehaviorPosition.bottom,
                      cellPadding: EdgeInsets.all(4.0),
                    ),
                  ],
                  defaultRenderer: charts.BarRendererConfig(
                    groupingType: charts.BarGroupingType.grouped,
                    strokeWidthPx: 2.0,
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) =>
                Center(child: Text('Error: $error')),
          );
        },
      ),
    );
  }
}

class HabitData {
  final String habitName;
  final int habitCount;

  HabitData(this.habitName, this.habitCount);
}

DateTime parseDate(String date) {
  final parts = date.split('-');
  final day = int.parse(parts[0]);
  final month = int.parse(parts[1]);
  final year = int.parse(parts[2]);
  return DateTime(year, month, day);
}
