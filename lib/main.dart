import 'package:ecomerce/auth_screen.dart';
import 'package:ecomerce/const/const_color.dart';
import 'package:ecomerce/controller/cart_controller.dart';
import 'package:ecomerce/view/home/home_screen.dart';
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

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Configure Stripe with your publishable key & merchant identifier.
  // Stripe.publishableKey =
  //     'pk_test_51QzcMbAB7nmlSDhKNvYqjjEqh87ld74rC6pPRKw0T0HCq9xw190wv2hy0Y19GGNBsSUgIqSxT6fMl14Pw2LyWwXR00hGIcvjGf';
  // // Stripe.publishableKey = 'sk_test_tR3PYbcVNZZ796tH88S4VQ2u';
  // Stripe.merchantIdentifier = 'merchant.com.yourapp';
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
            backgroundColor: AppColors.backgroundColor,
            elevation: 0,
            iconTheme: IconThemeData(color: AppColors.textColor),
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
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: AuthWrapper(),
        routes: {
          '/home': (context) => HomeScreen(),
          '/login': (context) => LoginScreen(),
        },
        // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
