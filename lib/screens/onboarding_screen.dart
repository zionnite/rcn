import 'package:flutter/material.dart';
import 'package:flutter_onboard/flutter_onboard.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_signup_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoard(
        pageController: _pageController,
        // Either Provide onSkip Callback or skipButton Widget to handle skip state
        onSkip: () async {
          // print('skipped');
          // moveToLogin();
        },
        // Either Provide onDone Callback or nextButton Widget to handle done state
        onDone: () async {
          print('done');
          moveToLogin();
        },

        onBoardData: onBoardData,
        titleStyles: const TextStyle(
          color: Colors.deepOrange,
          fontSize: 18,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.15,
        ),
        descriptionStyles: TextStyle(
          fontSize: 16,
          color: Colors.brown.shade300,
        ),
        pageIndicatorStyle: const PageIndicatorStyle(
          width: 100,
          inactiveColor: Colors.deepOrangeAccent,
          activeColor: Colors.deepOrange,
          inactiveSize: Size(8, 8),
          activeSize: Size(12, 12),
        ),
        // Either Provide onSkip Callback or skipButton Widget to handle skip state
        skipButton: TextButton(
          onPressed: () {
            moveToLogin();
          },
          child: const Text(
            "Skip",
            style: TextStyle(color: Colors.deepOrangeAccent),
          ),
        ),
        // Either Provide onDone Callback or nextButton Widget to handle done state
        nextButton: OnBoardConsumer(
          builder: (context, ref, child) {
            final state = ref.watch(onBoardStateProvider);
            return InkWell(
              onTap: () => _onNextTap(state),
              child: Container(
                width: 230,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Colors.redAccent, Colors.deepOrangeAccent],
                  ),
                ),
                child: Text(
                  state.isLastPage ? "Done" : "Next",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onNextTap(OnBoardState onBoardState) {
    if (!onBoardState.isLastPage) {
      _pageController.animateToPage(
        onBoardState.page + 1,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutSine,
      );
    } else {
      moveToLogin();
    }
  }
}

moveToLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('isFirstTime', true);
  Get.offAll(() => LoginSignupScreen());
}

final List<OnBoardModel> onBoardData = [
  const OnBoardModel(
    title: "Listen & Download Audio Sermon",
    description:
        "you can download Apostle'\s sermon directly to your device and also able to create a playlist",
    imgUrl: "assets/images/music.png",
  ),
  const OnBoardModel(
    title: "Go Live with Apostle",
    description: "Never miss any moment of Apostle ministration",
    imgUrl: 'assets/images/live.png',
  ),
  const OnBoardModel(
    title: "Keep track of Apostle Itinerary",
    description: "Stay connected to Apostle Ministration anywhere in the World",
    imgUrl: 'assets/images/track.png',
  ),
];
