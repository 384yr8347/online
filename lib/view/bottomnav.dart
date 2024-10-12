import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:supermarket/view/home.dart';
import 'package:supermarket/view/order.dart';
import 'package:supermarket/view/profile.dart';
import 'package:supermarket/view/wallet.dart';
import 'package:flutter/material.dart';
import 'package:supermarket/package/provider.dart';
import 'package:provider/provider.dart';


class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;   //حدد أي شاشة يتم عرضها حاليًا بناءً على اختيار المستخدم.

  late List<Widget> view;
  late Widget currentPage;
  late Home homepage;
  late Profile profile;
  late Order order;
  late Wallet wallet;

  @override
  void initState() {  //تهيئة الواجهات
    homepage = const Home();
    order = Order();
    profile = Profile();
    wallet = Wallet();
    view = [homepage, order, wallet, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          height: 65,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          color: Theme.of(context).colorScheme.primary,
          animationDuration: Duration(milliseconds: 500),
          onTap: (int index) {
            setState(() {
              currentTabIndex = index; //يتم تغيير القيمة بناءً على الشاشة التي تم اختيارها.
            });
          },
          items: [
            Icon(
              Icons.home_outlined,
              color: Theme.of(context).colorScheme.secondary,
              size:30,
            ),
            Icon(
              Icons.shopping_bag_outlined,
              color: Theme.of(context).colorScheme.secondary,
              size:30,
            ),
            Icon(
              Icons.wallet_outlined,
              color:Theme.of(context).colorScheme.secondary,
              size:30,
            ),
            Icon(
              Icons.person_outline,
              color:Theme.of(context).colorScheme.secondary,
              size:30,
            )
          ]),
      body: view[currentTabIndex],
    );
  }
}
