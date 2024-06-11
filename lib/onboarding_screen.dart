import 'package:flutter/material.dart';
import 'package:afriqmarkethub/components/onboarding_template.dart';
import 'package:afriqmarkethub/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

final _controller = PageController();

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  Future<void> _incrementOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onboardingStatus', 1);
    setState(() {
      onboardingStatus = 1;
    });
    Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: ((context) => const WebViewExample())));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                children: [
                  OnboardingTemplate(
                    buttonTitle: 'Next',
                    onBoardingImage: 'assets/images/afric1.jpg',
                    heading: "Unique Products",
                    decsription:
                        "Explore unique, hand-selected products from around the globe, only at AfricMarketHub. Find your one-of-a-kind item today! Each piece is curated to ensure exclusivity and exceptional quality.",
                    onPressed: () {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    },
                  ),
                  OnboardingTemplate(
                    buttonTitle: 'Next',
                    onBoardingImage: 'assets/images/afric2.jpg',
                    heading: "Affordable Price",
                    decsription:
                        "Enjoy the best deals without sacrificing quality. AfricMarketHub offers affordable prices on all our unique, high-quality products. Shop with confidence and maximize your savings on every order.",
                    onPressed: () {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    },
                  ),
                  OnboardingTemplate(
                    buttonTitle: 'Get Started',
                    onBoardingImage: 'assets/images/afric3.jpg',
                    heading: "Fast Delivery",
                    decsription:
                        "Get your products quickly with AfricMarketHub's fast delivery service. Reliable, swift, and ready to serve you wherever you are! Experience hassle-free shopping with our prompt delivery.",
                    onPressed: () {
                      _incrementOnboardingStatus();
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SmoothPageIndicator(
                      effect: const ExpandingDotsEffect(
                        activeDotColor: Colors.black,
                      ),
                      controller: _controller,
                      count: 3,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      width: 80,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        onTap: () {
                          _incrementOnboardingStatus();
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Skip',
                            ),
                            SizedBox(
                                width:
                                    8), // Adjust spacing between label and icon
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
