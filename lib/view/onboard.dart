import 'package:flutter/material.dart';
import 'package:supermarket/view/Login.dart';
import 'package:supermarket/view/home.dart';
import 'package:supermarket/view/signup.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supermarket/package/dark_light_mode.dart';
import 'package:supermarket/package/provider.dart';
import 'package:provider/provider.dart';
import 'package:supermarket/view/bottomnav.dart';

class Onboarding extends StatelessWidget {
  Onboarding({Key? key}) : super(key: key);

  PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(left: 200.0),
          ),
          IconButton(
            onPressed: () {
              themeProvider.toggleTheme();
            },
            icon: themeProvider.isDarkMode
                ? Icon(Icons.dark_mode)
                : Icon(Icons.light_mode),
          ),
        ],
      ),
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          OnboardingPage(
            image: Image.asset("assets/all_grocery.png"),
            title: "Welcome",
            description:
                "Welcome to the best online grocery store. Here you will find all the groceries in one place.",
            noOfScreen: 3,
            onNextPressed: changeScreen,
            currentScreenNo: 0,
          ),
          OnboardingPage(
            image: Image.asset("assets/grocery.png"),
            title: "Fresh Fruits & Vegetables",
            description:
                "Buy farm-fresh fruits & vegetables online at the best & affordable prices.",
            noOfScreen: 3,
            onNextPressed: changeScreen,
            currentScreenNo: 1,
          ),
          OnboardingPage(
            image: Image.asset("assets/delivery.png"),
            title: "Quick & Fast Delivery",
            description:
                "We offer speedy delivery of your groceries, bathroom supplies, baby care products, pet care items, stationery, etc. within 30 minutes at your doorstep.",
            noOfScreen: 3,
            onNextPressed: changeScreen,
            currentScreenNo: 2,
          ),
          
        ],
      ),
    );
  }

  void changeScreen(int nextScreenNo) {
    controller.animateToPage(nextScreenNo,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  }
}

class OnboardingPage extends StatelessWidget {
  OnboardingPage({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
    required this.noOfScreen,
    required this.onNextPressed,
    required this.currentScreenNo,
  }) : super(key: key);

  final Image image;
  final String title;
  final String description;
  final int noOfScreen;
  final Function(int) onNextPressed;
  final int currentScreenNo;

  @override
  Widget build(BuildContext context) {
    bool isLastScreen = currentScreenNo >= noOfScreen - 1;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                image,
                const SizedBox(height: 20),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 30,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    description,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: !isLastScreen,
            replacement: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: 50,
                  child: RoundedButton(
                    title: "Get Started",
                    onPressed: () {
                      openLoginScreen(context);
                    },
                  ),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RoundedButton(
                  title: "Skip",
                  onPressed: () {
                    openLoginScreen(context);
                  },
                ),
                Row(
                  children: [
                    for (int index = 0; index < noOfScreen; index++)
                      createProgressDots(
                          (index == currentScreenNo) ? true : false),
                  ],
                ),
                RoundedButton(
                  title: "Next",
                  onPressed: () {
                    onNextPressed(currentScreenNo + 1);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget createProgressDots(bool isActiveScreen) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: isActiveScreen ? 15 : 10,
      width: isActiveScreen ? 15 : 10,
      decoration: BoxDecoration(
        color: isActiveScreen
            ? const Color.fromARGB(255, 82, 147, 122)
            : Colors.grey,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  void openLoginScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }
}

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
