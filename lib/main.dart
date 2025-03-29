import 'package:fast_ego_frontend/core/providers/deposit_provider.dart';
import 'package:fast_ego_frontend/core/providers/get_a_card_provider.dart';
import 'package:fast_ego_frontend/core/providers/merchant_provider.dart';
import 'package:fast_ego_frontend/core/providers/withdrawal_provider.dart';
import 'package:fast_ego_frontend/feautures/auth/presentation/pages/login_page.dart';
import 'package:fast_ego_frontend/feautures/auth/presentation/pages/signup_page1.dart';
import 'package:fast_ego_frontend/feautures/auth/presentation/pages/signup_page2.dart';
import 'package:fast_ego_frontend/feautures/auth/presentation/pages/signup_page3.dart';
import 'package:fast_ego_frontend/feautures/splash/presentation/pages/splash_screen.dart';
import 'package:fast_ego_frontend/feautures/splash/presentation/pages/splash_screen_2.dart';
import 'package:fast_ego_frontend/feautures/splash/presentation/pages/welcome_page.dart';
import 'package:fast_ego_frontend/feautures/wallet/presentation/pages/confirm_payment_page.dart';
import 'package:fast_ego_frontend/feautures/wallet/presentation/pages/contact_us_page.dart';
import 'package:fast_ego_frontend/feautures/wallet/presentation/pages/deposit_page.dart';
import 'package:fast_ego_frontend/feautures/wallet/presentation/pages/get_a_card_page.dart';
import 'package:fast_ego_frontend/feautures/wallet/presentation/pages/merchant_registration_page.dart';
import 'package:fast_ego_frontend/feautures/wallet/presentation/pages/register_a_card.dart';
import 'package:fast_ego_frontend/feautures/wallet/presentation/pages/transfer_page.dart';
import 'package:fast_ego_frontend/feautures/wallet/presentation/pages/wallet_home_page.dart';
import 'package:fast_ego_frontend/feautures/wallet/presentation/pages/withdrawal_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fast_ego_frontend/core/providers/auth_provider.dart';
import 'package:fast_ego_frontend/core/providers/transfer_provider.dart';
import 'package:fast_ego_frontend/core/providers/balance_provider.dart';
import 'package:fast_ego_frontend/core/providers/contact_provider.dart'; // Added missing import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TransferProvider()),
        ChangeNotifierProvider(create: (_) => BalanceProvider()),
        ChangeNotifierProvider(create: (_) => GetACardProvider()),
        ChangeNotifierProvider(create: (_) => MerchantProvider()),
        ChangeNotifierProvider(create: (_) => DepositProvider()),
        ChangeNotifierProvider(create: (_) => WithdrawalProvider()),
        ChangeNotifierProvider(create: (_) => ContactProvider()),
      ],
      child: MaterialApp(
        title: 'FastEGO Wallet',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/wallet-home',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/splash2': (context) => const SplashScreen2(),
          '/welcome': (context) => const WelcomePage(),
          '/login': (context) => const LoginPage(),
          '/signup-step1': (context) => const SignupStep1(),
          '/signup-step2': (context) => const SignupStep2(),
          '/signup-step3': (context) => const SignupStep3(),
          '/wallet-home': (context) => const WalletHomePage(),
          '/deposit': (context) => const DepositPage(),
          '/withdrawal': (context) => const WithdrawalPage(),
          '/transfer': (context) => const TransferPage(),
          '/confirm-payment': (context) => const ConfirmPaymentPage(),
          '/merchant-registration': (context) => const RegisterMerchantPage(),
          '/get-card': (context) => const GetACardPage(),
          '/contact-us': (context) => const ContactUsPage(),
          '/register-card': (context) => const RegisterCardPage(),
        },
      ),
    );
  }
}