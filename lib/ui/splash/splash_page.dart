import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/providers/cache_provider.dart';
import '../../root.dart';
import '../../utils/labels.dart';
import '../auth/providers/auth_provider.dart';
import '../components/bg.dart';
import '../onboarding/onboarding_page.dart';




class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});
  static const route = '/';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {

  void initState() {
    //init();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardingPage(),
        ),
      );
    });
    super.initState();
  }

  // void init()async{
  //  await ref.read(cacheProvider.future);
  //  ref.read(userProvider);
  //  // ignore: use_build_context_synchronously
  //  Navigator.pushNamedAndRemoveUntil(context, Root.route, (route) => false);
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Material(
      child: Bg(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Center(
                child: Text(
                  Labels.welcomeTo,
                  style: style.headlineLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  }
