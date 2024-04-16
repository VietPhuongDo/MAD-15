import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_firebase/ui/habits/write_habit_page.dart';

import '../../../utils/assets.dart';
import '../../../utils/labels.dart';
import '../../components/big_button.dart';
import '../../components/circle_button.dart';
import '../../dashboard/statistics.dart';

class CongratsSheet extends StatelessWidget {
  const CongratsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final scheme = theme.colorScheme;
    return SafeArea(
      child: Card(
        margin: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    Assets.teepee2,
                  ),
                  Text(
                    Labels.congratulations,
                    style: style.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris',
                    textAlign: TextAlign.center,
                    style: style.titleMedium,
                  ),
                  const SizedBox(height: 28),
                  BigButton(
                    elevation: 0,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => WriteHabitPage()), // Thay NextPage() bằng trang tiếp theo bạn muốn chuyển hướng đến
                      );
                    },
                    text: Labels.createNewHabit,
                  ),
                  const SizedBox(height: 8),
                  MaterialButton(
                    elevation: 0,
                    color: scheme.primaryContainer,
                    textColor: scheme.onPrimary,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => StatisticsPage()), // Thay NextPage() bằng trang tiếp theo bạn muốn chuyển hướng đến
                      );
                    },
                    child: const Text(Labels.continue_),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: CircleButton(
                child: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
