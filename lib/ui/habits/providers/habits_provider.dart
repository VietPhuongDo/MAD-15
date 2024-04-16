
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/models/habit.dart';
import '../../../core/repositories/habit_repository.dart';
import '../../auth/providers/auth_provider.dart';

final habitsProvider = StreamProvider<List<Habit>>(
  (ref) {
    final user = ref.watch(userProvider).asData?.value;
    if (user == null) {
      return Stream.error('User not found!');
    } else {
      return ref.read(habitRepositoryProvider).getHabits(user.uid);
    }
  },
);
