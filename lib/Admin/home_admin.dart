import 'dart:io';
import 'package:supermarket/Admin/manage.dart';
import 'package:flutter/material.dart';
import 'package:supermarket/admin/add_food.dart';
import 'package:supermarket/view/bottomnav.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:supermarket/admin/api_manage.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  List<Map<String, dynamic>> foodItems = [];
  @override
  void initState() {
    super.initState();
    loadFoodItems(); // استرجاع العناصر الغذائية عند بدء التطبيق
  }

  // حفظ العناصر الغذائية في shared_preferences
  Future<void> saveFoodItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedFoodItems = foodItems.map((food) {
      Map<String, dynamic> json = Map.from(food);
      json['image'] = food['image'].path; // حفظ مسار الصورة كـ String
      return jsonEncode(json);
    }).toList();
    await prefs.setStringList('food_items', encodedFoodItems);
  }

  // استرجاع العناصر الغذائية من shared_preferences
  Future<void> loadFoodItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedFoodItems = prefs.getStringList('food_items');
    if (encodedFoodItems != null) {
      setState(() {
        foodItems = encodedFoodItems.map((encodedItem) {
          Map<String, dynamic> food = jsonDecode(encodedItem);
          food['image'] = File(food['image']); // استرجاع الصورة كـ File
          return food;
        }).toList();
      });
    }
  }

  void addFoodItem(String name, double price, String description,
      String category, File image) {
    // إضافة عنصر غذائي جديد إلى القائمة
    setState(() {
      foodItems.add({
        'name': name,
        'price': price,
        'description': description,
        'category': category,
        'image': image,
      });
    });
    saveFoodItems();
  }

  void editFoodItem(int index, String name, double price, String description,
      String category, File image) {
    setState(() {
      foodItems[index] = {
        'name': name,
        'price': price,
        'description': description,
        'category': category,
        'image': image,
      };
    });
    saveFoodItems();
  }

  void deleteFoodItem(int index) {
    setState(() {
      foodItems.removeAt(index);
    });
    saveFoodItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Admin"),
        leading: IconButton(
          icon: Icon(
            Icons.home,
            color: Theme.of(context).colorScheme.primary,
          ), // زر الرجوع
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNav(),
                )); // إجراء الرجوع عند النقر على الزر
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddFoodItem(onAdd: addFoodItem),
                    ));
              },
              child: Material(
                elevation: 10.0,
                borderRadius: BorderRadius.circular(10),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Icon(
                            Icons.add_circle_outline,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 30.0,
                        ),
                        Text(
                          "Add Food Items",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmployeeScreen(),
                    ));
              },
              child: Material(
                elevation: 10.0,
                borderRadius: BorderRadius.circular(10),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Icon(
                            Icons.person_pin,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 30.0,
                        ),
                        Text(
                          "Employees",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),

            Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddFoodItem(onAdd: addFoodItem),
                      ));
                },
                child: Material(
                  elevation: 10.0,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Text(
              'Items Food',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              maxLines: 1,
            ),
            SizedBox(
              height: 40,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: foodItems.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 13.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          foodItems[index]['name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: 20),
                        ),
                        subtitle: Text(
                          foodItems[index]['category'],
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: 10),
                        ),
                        leading: SizedBox(
                          width: 50,
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: foodItems[index]['image']
                                    .existsSync() // تحقق من وجود الصورة
                                ? Image.file(
                                    foodItems[index]['image'],
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset('assets/person.png',
                                    fit: BoxFit.cover), // صورة افتراضية
                          ),
                        ), // عرض الصورة
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                // الانتقال إلى شاشة التعديل
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditFoodItem(
                                      name: foodItems[index]['name'],
                                      price: foodItems[index]['price'],
                                      description: foodItems[index]
                                          ['description'],
                                      category: foodItems[index]['category'],
                                      image: foodItems[index]['image'],
                                      onUpdate: (name, price, description,
                                          category, image) {
                                        editFoodItem(index, name, price,
                                            description, category, image);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // تأكيد الحذف قبل الحذف
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Delete Item'),
                                    content: Text(
                                        'Are you sure you want to delete this item?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(
                                              context); // إغلاق مربع الحوار
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          deleteFoodItem(index);
                                          Navigator.pop(
                                              context); // إغلاق مربع الحوار
                                        },
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        onTap: () {},
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}