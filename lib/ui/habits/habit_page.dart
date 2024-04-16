import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:test_firebase/ui/habits/widgets/congrats_sheet.dart';
import 'package:test_firebase/utils/formats.dart';
import 'dart:math' show Random;
import '../../core/models/habit.dart';
import '../../core/repositories/habit_repository.dart';
import '../../utils/assets.dart';
import '../../utils/labels.dart';
import '../../utils/utils.dart';
import '../components/app_back_button.dart';
import '../components/big_button.dart';
import '../components/circle_button.dart';
import '../components/cus_circle_button.dart';
import '../components/custom_scaffold.dart';
import '../components/status_button.dart';
import '../home/home_root.dart';



final habitProvider = StateProvider<Habit>((ref) => throw UnimplementedError());

class HabbitPage extends ConsumerWidget {
  const HabbitPage({super.key,required this.habit});
  static const route = '/habbit';
  //final CustomHabit customHabit;

  final Habit habit;
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final scheme = theme.colorScheme;
    final completedDays = habit.completedDays;
    DateTime now = DateTime.now();
    int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    int daysPassed = now.day;
    final a = completedDays.where((day) {
      try {
        final completedDay = parseDate(day);
        return completedDay.month == now.month && completedDay.year == now.year;
      } catch (e) {
        return false;
      }
    }).length;
    int b=(daysPassed-a).toInt();
    int c=(a/daysPassed*100).toInt();
    return CustomScaffold(
      title: habit.name,
      leading: const AppBackButton(),
      traling:  DualCircleButtons(
        buttons: [
          CircleButton(
            child: const Icon(Icons.edit_outlined),
            onPressed: () {
              ref.read(writerProvider.notifier).state = true;
            },
          ),
          CircleButton(
            child: const Icon(Icons.delete_outline),
            onPressed: () {
                final habitId = habit.id;
                ref.read(habitRepositoryProvider).deleteHabit(habitId);
                Navigator.pop(context);
            },
          ),
          // Widget con khác tại đây
          // Widget con khác tại đây
        ],
        // onPressed: () {
        //   ref.read(writerProvider.notifier).state = true;
        // },
        // child: Icon(
        //   Icons.edit_outlined,
        // ),
        // onPressed: () async {
        //   final habitId = habit.id;
        //   await ref.read(habitRepositoryProvider).deleteHabit(habitId);
        //   Navigator.pop(context);
        // },
        // child: Icon(
        //   Icons.delete_outline,
        // ),
      ),
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.all(20),
            child: SizedBox(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: scheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                                scheme.primaryContainer, BlendMode.darken),
                            image: const AssetImage(
                              Assets.teepee,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(flex: 2),
                          Text(
                            habit.name,
                            style: style.titleMedium,
                          ),
                          const Spacer(flex: 2),
                          Row(
                            children: [
                              Icon(
                                Icons.notifications_none_outlined,
                                size: 16,
                                color: scheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                Labels.repeatEveryday,
                                style: style.bodySmall,
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Icon(
                                Icons.repeat_rounded,
                                size: 16,
                                color: scheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                Labels.reminders,
                                style: style.bodySmall,
                              ),
                            ],
                          ),
                          const Spacer(
                            flex: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.keyboard_arrow_left_rounded),
                    ),
                    Text(
                      DateFormat('MMMM').format(DateTime.now()),
                      style: style.titleMedium,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.keyboard_arrow_right_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: Utils.weekDays
                      .map(
                        (e) => Expanded(
                          child: Text(
                            e.labelDay,
                            style: style.bodySmall!.copyWith(
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 2),
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                    childAspectRatio: 47 / 72,
                  ),
                  itemCount: Utils.allDaysOfMonth(DateTime.now()).length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(6),
                  itemBuilder: (BuildContext context, int index) {
                    final day = Utils.allDaysOfMonth(DateTime.now())[index];
                    final completedDate = DateFormat('dd-MM-yyyy').format(day);
                    final isCompleted = habit.completedDays.contains(completedDate);
                    final isCurrentMonth = day.month == DateTime.now().month;
                    final completedDayOfWeek = DateFormat('E').format(day).toUpperCase();
                    final count =habit.frequency[completedDayOfWeek]??0;
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: scheme.primaryContainer,
                      ),
                      child: Column(
                        children: [
                          const Spacer(flex: 2),
                          Text(
                            '${day.day}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: day.month != DateTime.now().month
                                  ? scheme.onPrimary.withOpacity(0.3)
                                  : null,
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: StatusButton(
                                value:isCurrentMonth && isCompleted ? count : 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          const SizedBox(height: 48),
          Container(
            decoration:
                BoxDecoration(color: scheme.primaryContainer, boxShadow: [
              BoxShadow(
                color: scheme.primary.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 10,
              ),
            ]),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  Labels.analytics,
                  style: style.bodySmall!.copyWith(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 22),
                Card(
                  child: AspectRatio(
                    aspectRatio: 2,
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              OverviewWidget(
                                title: '${Labels.days(a)}',
                                subtitle: Labels.longestStreak,
                                asset: Assets.fire,
                              ),
                              Container(
                                width: 1,
                                color: theme.dividerColor,
                              ),
                              OverviewWidget(
                                title: '${Labels.days(b)}',
                                subtitle: Labels.currentStreak,
                                asset: Assets.flash,
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        Expanded(
                          child: Row(
                            children: [
                              OverviewWidget(
                                title: '${Labels.percentage(c)}',
                                subtitle: Labels.completionRate,
                                asset: Assets.rate,
                              ),
                              Container(
                                width: 1,
                                color: theme.dividerColor,
                              ),
                              OverviewWidget(
                                title: '7',
                                subtitle: Labels.averageEasinessScore,
                                asset: Assets.leaf,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                BigButton(
                  
                  onPressed: () {
                    String completedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
                    habit.completedDays.add(completedDate);
                    FirebaseFirestore.instance.collection('habits').doc(habit.id).update({
                      'completedDays': FieldValue.arrayUnion([completedDate]),
                    });

                    // Kiểm tra xem ngày hiện tại đã được hoàn thành hay chưa

                    // Nếu chưa hoàn thành thì thêm ngày hiện tại vào danh sách hoàn thành

                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (context) => CongratsSheet(),
                    );
                  },
                  text: Labels.markHabitAsComplete,
                ),
                const SizedBox(height: 8),
                MaterialButton(
                  color: scheme.surface,
                  textColor: scheme.onPrimary,
                  onPressed: () {
                  },
                  child: Text(Labels.markHabitAsMissed),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
DateTime parseDate(String date) {
  final parts = date.split('-');
  final day = int.parse(parts[0]);
  final month = int.parse(parts[1]);
  final year = int.parse(parts[2]);
  return DateTime(year, month, day);
}
class OverviewWidget extends StatelessWidget {
  const OverviewWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.asset,
  });

  final String title;
  final String subtitle;
  final String asset;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final scheme = theme.colorScheme;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: style.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: style.bodySmall,
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 19,
              backgroundColor: scheme.primary.withOpacity(0.2),
              child: SvgPicture.asset(asset),
            ),
          ],
        ),
      ),
    );
  }
}


