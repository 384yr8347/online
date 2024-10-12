import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermarket/package/provider.dart';
import 'package:supermarket/package/shared_pref.dart';
import 'dart:async';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? wallet;
  int amount2 = 0;
  int quantity = 1;

  void startTimer() {
    Timer(Duration(seconds: 3), () {
      setState(() {});
    });
  }

  getthesharedpref() async {
    wallet = await SharedPreferenceHelper().getUserWallet();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // الحصول على CartModel باستخدام Provider
    final cart = context.watch<CartModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Food Cart",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        elevation: 3.0,
        shadowColor: Colors.black,
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
Expanded(
  child: ListView.builder(
    padding: EdgeInsets.zero,
    itemCount: cart.items.length,
    itemBuilder: (context, index) {
      var item = cart.items[index];
      return Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Column(
                  children: [
                    // عرض الكمية
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          item["Quantity"].toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: item["Image"] != null
                      ? Image.file(
                          File(item["Image"]),
                          height: 70,
                          width: 70,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/default_image.png',
                          height: 70,
                          width: 70,
                          fit: BoxFit.cover,
                        ),
                ),
                SizedBox(width: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["Name"] ?? "Unknown",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
  '\$${(item["Price"] != null ? (item["Price"] as double).toStringAsFixed(2) : '0.00')}', 
  style: TextStyle(
    color: Theme.of(context).colorScheme.onSecondary,
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
  ),
),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    cart.removeItem(index); 
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  ),
),

            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Price",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    "\$" + cart.totalPrice.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            GestureDetector(
              onTap: () async {
                if (cart.items.isNotEmpty) {
                  if (wallet != null && wallet!.isNotEmpty) {
                    try {
                      // تحويل totalPrice إلى int إذا كان من النوع double
                      int totalPrice = cart.totalPrice.toInt();

                      // طرح المجموع الكلي من المحفظة
                      int amount = int.parse(wallet!) - totalPrice;

                      // تحديث المحفظة في shared preferences
                      await SharedPreferenceHelper().saveUserWallet(amount.toString());

                      // إفراغ السلة بعد الدفع
                      cart.clearCart();

                      // عرض رسالة نجاح
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Payment Successful!'),backgroundColor: Colors.green,),
                      );
                    } catch (e) {
                      // التعامل مع الأخطاء مثل فشل التحويل
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e'),backgroundColor: Colors.red,),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Wallet is empty or invalid!'),backgroundColor: const Color.fromARGB(255, 148, 69, 69),),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Cart is Empty!'),backgroundColor: Color.fromARGB(255, 255, 163, 24),),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: Center(
                  child: Text(
                    "CheckOut",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
