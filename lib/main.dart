import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test_firebase/router.dart';
import 'package:test_firebase/ui/colors.dart';
import 'package:test_firebase/ui/components/status_button.dart';
import 'package:test_firebase/ui/splash/splash_page.dart';
import 'package:test_firebase/utils/constants.dart';
import 'package:test_firebase/utils/labels.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(seedColor: AppColors.orange).copyWith(
      primary: AppColors.orange,
      onPrimary: AppColors.textColor,
      primaryContainer: AppColors.lightOrange,
      outline: AppColors.lightText,
      surfaceVariant: AppColors.gray,
    );
    final base = ThemeData.light().textTheme;
    return MaterialApp(
      title: Labels.appName,
      theme: ThemeData(
        indicatorColor: AppColors.lightText,
        dividerTheme: const DividerThemeData(thickness: 1, space: 0),
        dividerColor: scheme.primaryContainer,
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.orange,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
        ),
        colorScheme: scheme,
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(scheme.onPrimary),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            padding: MaterialStateProperty.all(
              const EdgeInsets.all(16),
            ),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            foregroundColor: MaterialStateProperty.all(scheme.onPrimary),
          ),
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: scheme.surface,
          margin: EdgeInsets.zero,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
            color: AppColors.lightText,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          fillColor: scheme.primaryContainer,
          filled: true,
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: scheme.primary,
          textTheme: ButtonTextTheme.primary,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        textTheme: base
            .apply(fontFamily: Constants.manrope)
            .copyWith(
          headlineLarge: const TextStyle(fontFamily: Constants.klasik),
          headlineMedium: const TextStyle(
            fontFamily: Constants.klasik,
            fontSize: 32,
          ),
          headlineSmall: const TextStyle(fontFamily: Constants.klasik),
          titleMedium: const TextStyle(
              fontWeight: FontWeight.bold, fontFamily: Constants.manrope),
          labelLarge: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: Constants.manrope,
            fontSize: 17,
          ),
          bodyLarge: const TextStyle(
            fontFamily: Constants.manrope,
            fontSize: 16,
          ),
        )
            .apply(
          bodyColor: AppColors.textColor,
          displayColor: AppColors.textColor,
        )
            .copyWith(
          bodySmall: const TextStyle(
            color: AppColors.lightText,
          ),
        ),
      ),
      //home:const SplashPage(),
      initialRoute: SplashPage.route,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}

extension CustomStyles on TextTheme {
  TextStyle? get specialTitle => titleMedium?.copyWith(fontSize: 18);
  TextStyle? get titleMedium2 => bodySmall?.copyWith(fontSize: 16);
}
class YourWidget extends StatefulWidget {
  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  List<DateTime> habitData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: fetchDataFromFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            habitData = snapshot.data as List<DateTime>;
            return GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 47 / 72,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              padding: EdgeInsets.all(6),
              children: habitData.map((e) => buildGridItem(e)).toList(),
            );
          }
        },
      ),
    );
  }

  Widget buildGridItem(DateTime date) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xFFFFF3E9),
      ),
      child: Column(
        children: [
          Spacer(flex: 2),
          Text(
            '${date.day}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: date.month != DateTime.now().month ? Color(0xFF573353).withOpacity(0.3) : null,
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: AspectRatio(
              aspectRatio: 1,
              child: StatusButton(value: 1),
            ),
          )
        ],
      ),
    );
  }

  Future<List<DateTime>> fetchDataFromFirebase() async {
    var habitData = <DateTime>[];
    var snapshot = await FirebaseFirestore.instance.collection('habits').get();
    snapshot.docs.forEach((doc) {
      var date = (doc.data() as Map)['date'].toDate();
      habitData.add(date);
    });
    return habitData;
  }
}


