import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:supermarket/package/provider.dart';

class Details extends StatefulWidget {
  final Map<String, dynamic> foodItem; // استقبال بيانات المنتج

  const Details({super.key, required this.foodItem}); // استلام بيانات المنتج عبر الـ Constructor

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final cart = Provider.of<CartModel>(context, listen: false);

    // استخدام البيانات الممررة لعرض التفاصيل
    String name = widget.foodItem['name'];
    double price = widget.foodItem['price'];
    String description = widget.foodItem['description'];
    String category = widget.foodItem['category'];
    File image = widget.foodItem['image'];

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Image.file(
              image, 
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category, 
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      name, 
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Spacer(),

                GestureDetector(
                  onTap: () {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 20.0),
                Text(
                  quantity.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 20.0),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      quantity++;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            RatingBar(
              initialRating: 3,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 20.0,
              ratingWidget: RatingWidget(
                full: Icon(Icons.star, color: Colors.amber),
                half: Icon(
                  Icons.star_half,
                  color: Colors.amber,
                ),
                empty: Icon(
                  Icons.star_border,
                  color: Colors.amber,
                ),
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
            const SizedBox(height: 20.0),
            Text(
              description,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 30.0),
            GestureDetector(
              onTap: () {
                cart.addItem(
                  name,
                  price,
                  image.path,
                  quantity,
                  price * quantity,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added to Cart'), backgroundColor: Colors.green,)
                  
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Add to Cart',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(width: 30.0),
                    Icon(
                      Icons.shopping_cart_outlined,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 10.0),
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
