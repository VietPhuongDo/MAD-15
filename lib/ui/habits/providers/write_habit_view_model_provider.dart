import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test_firebase/utils/formats.dart';

import '../../../core/models/habit.dart';
import '../../../core/providers/loading_provider.dart';
import '../../../core/repositories/habit_repository.dart';
import '../../../utils/utils.dart';
import '../../auth/providers/auth_provider.dart';

final writeHabitViewModelProvider =
    ChangeNotifierProvider.autoDispose((ref) => WriteHabitViewModel(ref));

class WriteHabitViewModel extends ChangeNotifier {
  final Ref _ref;

  WriteHabitViewModel(this._ref);

  final formKey = GlobalKey<FormState>();

  Habit initial = Habit.empty(Map<String, int>.fromEntries(
      Utils.weekDays.map((e) => MapEntry(e.labelDay, 1))));

  void init(Habit habit) {
    if (initial.id.isEmpty) {
      initial = habit;
      // name = habit.name;
      // frequency = Map<String, int>.fromEntries(habit.frequency.entries);
      // reminders = habit.reminders;
      // _notification = habit.notification;
    }
  }

  void toggleReminder(TimeOfDay time) {
    if (initial.reminders.contains(time)) {
      initial.reminders.remove(time);
    } else {
      initial.reminders.add(time);
    }
    notifyListeners();
  }

  void updateFrequency(String day, int count) {
    initial.frequency[day] = count;
    notifyListeners();
  }

  void toggleNotification() {
    initial.notification = !initial.notification;
    notifyListeners();
  }

  Loading get _loading => _ref.read(loadingProvider);

  HabitRepository get _repository => _ref.read(habitRepositoryProvider);

  Future<void> write() async {
    try {
      initial.createdBy = _ref.read(userProvider).value!.uid;
      _loading.start();
      await _repository.writeHabit(initial);
      _loading.end();
    } on FirebaseException catch (e) {
      _loading.stop();
      return Future.error(e.message ?? e.code);
    } catch (e) {
      _loading.stop();
      return Future.error(e.toString());
    }
  }
}
