import 'package:ecomerce/auth_screen.dart';
import 'package:ecomerce/const/const_color.dart';
import 'package:ecomerce/controller/cart_controller.dart';
import 'package:ecomerce/view/signup/create_account.dart';
import 'package:ecomerce/view/home/home_screen.dart';
import 'package:ecomerce/view/login/forgot_password.dart';
import 'package:ecomerce/view/login/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");

  // Stripe.publishableKey = dotenv.env["STRIPE_PUBLISH_KEY"]!;
  final publishableKey = dotenv.env["STRIPE_PUBLISH_KEY"];
  if (publishableKey == null || publishableKey.isEmpty) {
    throw Exception("Stripe publishable key is missing from .env file");
  }
  Stripe.publishableKey = publishableKey;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => CartProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shopywell',
        theme: ThemeData(
          fontFamily: 'Montserrat',
          appBarTheme: AppBarTheme(
            surfaceTintColor: AppColors.backgroundColor,
            backgroundColor: AppColors.backgroundColor,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
              fontSize: 17,
              fontFamily: 'Montserrat',
            ),
            actionsIconTheme: IconThemeData(),
            // iconTheme: IconThemeData(color: AppColors.textColor),
          ),
          scaffoldBackgroundColor: AppColors.backgroundColor,
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(AppColors.buttoncolor),
              // textStyle: WidgetStateProperty.all(
              //   TextStyle(
              //     color: AppColors.buttoncolor,
              //     fontSize: 16,
              //     fontWeight: FontWeight.w300,
              //   ),
              // ),
            ),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedLabelStyle: TextStyle(fontSize: 12),
            unselectedLabelStyle: TextStyle(fontSize: 12),
            backgroundColor: AppColors.backgroundColor,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppColors.buttoncolor),
              foregroundColor: WidgetStateProperty.all(
                AppColors.backgroundColor,
              ),
              textStyle: WidgetStateProperty.all(
                TextStyle(
                  color: AppColors.backgroundColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              elevation: WidgetStateProperty.all(0),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              ),
            ),
          ),

          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: AuthWrapper(),
        routes: {
          '/home': (context) => HomeScreen(),
          '/login': (context) => LoginScreen(),
          '/create': (context) => CreateAccount(),
          '/forgotpassword': (context) => ForgotPassword(),
        },
        // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
