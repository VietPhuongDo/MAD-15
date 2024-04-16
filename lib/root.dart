
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test_firebase/ui/auth/login_page.dart';
import 'package:test_firebase/ui/auth/providers/auth_provider.dart';
import 'package:test_firebase/ui/auth/verification_page.dart';
import 'package:test_firebase/ui/dashboard/dashboard.dart';
import 'package:test_firebase/ui/onboarding/onboarding_page.dart';
import 'package:test_firebase/utils/constants.dart';

import 'core/providers/cache_provider.dart';


class Root extends ConsumerWidget {
  const Root({super.key});
  static const route = '/root';
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final cache = ref.watch(cacheProvider).value!;
    final seen = cache.getBool(Constants.seen) ?? false;
    final User? user = ref.read(userProvider).asData?.value;
    //return Dashboard() ;
    return !seen? const OnboardingPage(): user == null? LoginPage():user.emailVerified? VerificationPage():Dashboard();//: VerificationPage();
  }
}