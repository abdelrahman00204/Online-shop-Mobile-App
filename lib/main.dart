import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:the_project/app_theme.dart';
import 'package:the_project/data/branch_data.dart';
import 'package:the_project/data/categories_data.dart';
import 'package:the_project/data/offers_data.dart';
import 'package:the_project/data/product_data.dart';
import 'package:the_project/managers/auth_manage.dart';
import 'screens/home_screen.dart';
import 'package:easy_localization/easy_localization.dart';
//import 'package:the_project/screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await dotenv.load();

  // Run independent data-loading calls concurrently instead of sequentially
  // await Future.wait([

  // ]);
    await  getBranch();
   await getCategories();
   await getProducts();
   await getActiveOffers();

  await AuthManage.instance.tryAutoLogin();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'الغول',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: AppTheme.getTheme(context.locale.languageCode == 'ar'),
      home: //AuthManage.instance.isLoggedIn
          const HomeScreen(),
      // : const LoginScreen(),
    );
  }
}
