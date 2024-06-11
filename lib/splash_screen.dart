import 'package:afriqmarkethub/main.dart';
import 'package:afriqmarkethub/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  // Load onboarding status from SharedPreferences

  // Navigate to appropriate screen based on onboarding status
  // Here you can navigate to the home page or the onboarding screen
  Future<void> _loadOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      onboardingStatus = prefs.getInt('onboardingStatus') ?? 0;
    });
    if (onboardingStatus == 1) {
      Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: ((context) => const WebViewExample())));
    } else if (onboardingStatus == 0) {
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: ((context) => const OnboardingScreen())));
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Adjust the duration as needed
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    // Start the animation
    _controller.forward();
    Future.delayed(const Duration(seconds: 4), () {
      _loadOnboardingStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              FadeTransition(
                opacity: _opacity,
                child: Center(
                  child: Image.asset(
                    "assets/images/afriqmarkethublogo.png",
                    scale: 2.8,
                  ),
                ),
              )
              // AnimatedSplashScreen(
              //   splash: 'assets/images/splash.jpg',
              //   splashIconSize: double.infinity,
              //   nextScreen: OnboardingScreen(),
              //   splashTransition: SplashTransition.fadeTransition,
              //   pageTransitionType: PageTransitionType.rightToLeft,
              //   curve: Curves.easeIn,
              //   centered: true,
              // ),
            ],
          )),
    );
  }
}
