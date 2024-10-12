import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supermarket/view/AboutUs.dart';
import 'package:supermarket/admin/home_admin.dart';
import 'package:supermarket/view/category.dart';
import 'package:supermarket/view/details.dart';
import 'package:supermarket/view/login.dart';
import 'package:supermarket/view/profile.dart';
import 'package:supermarket/package/provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> foodItems = [];
  TextEditingController searchController = TextEditingController();
  String searchText = '';

  @override
  void initState() {
    super.initState();
    loadFoodItems(); // استرجاع العناصر من التخزين الداخلي 
    //fetchFoodItems();
    searchController.addListener(() {
      filterSearchResults(searchController.text);
    });
  }

  // تخزين البيانات باستخدام shared_preferences
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

  // استرجاع البيانات عند تشغيل التطبيق
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

  Future<void> addNewFoodItem(String name, double price, String description,
      String category, File image) async {
    var request = http.MultipartRequest(
      'POST', Uri.parse("https://api-generator.retool.com/X7FM3x/data"));
    request.fields['name'] = name;
    request.fields['price'] = price.toString();
    request.fields['description'] = description;
    request.fields['category'] = category;
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    var response = await request.send();

    if (response.statusCode == 201) {
      // Successfully added
    } else {
      // Error
    }
  }

  Future<void> editFoodItem(String id, String name, double price,
      String description, String category, File image) async {
    var request = http.MultipartRequest(
        'PUT', Uri.parse("https://api-generator.retool.com/X7FM3x/data/$id"));
    request.fields['name'] = name;
    request.fields['price'] = price.toString();
    request.fields['description'] = description;
    request.fields['category'] = category;
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      // Successfully edited
    } else {
      // Error
    }
  }

  Future<void> deleteFoodItem(String id) async {
    final response =
        await http.delete(Uri.parse("https://api-generator.retool.com/X7FM3x/data/$id"));

    if (response.statusCode == 200) {
      // Successfully deleted
    } else {
      // Error
    }
  }

  Future<void> fetchFoodItems() async {
    final response =
        await http.get(Uri.parse("https://api-generator.retool.com/X7FM3x/data"));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        foodItems = data
            .map((item) => {
                  'name': item['name'],
                  'price': item['price'],
                  'description': item['description'],
                  'category': item['category'],
                  'image': File(item['image']),
                })
            .toList();
      });
      saveFoodItems(); // حفظ البيانات المسترجعة
    } else {
      throw Exception('Failed to load data');
    }
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      setState(() {
        foodItems = foodItems.where((item) {
          return item['name'].toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    } else {
      loadFoodItems(); // إعادة تعيين القائمة عند إفراغ البحث
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userModel = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
                userModel.isLoggedIn
                    ? 'Welcome, ${userModel.email}'
                    : 'Home',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
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
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                userModel.isLoggedIn
                    ? 'Welcome, ${userModel.name}'
                    : 'Please log in',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary
                ),
              ),
              accountEmail:
                  userModel.isLoggedIn ? Text(userModel.email) : Text(''),
              currentAccountPicture: CircleAvatar(
                backgroundImage:
                    userModel.isLoggedIn && userModel.profilePictureUrl != null
                        ? NetworkImage(userModel.profilePictureUrl)
                        : AssetImage('assets/food.jpg') as ImageProvider,
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text(
                      'Profile',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profile(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.error),
                    title: Text(
                      'About Us',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AboutUs(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.admin_panel_settings_sharp),
                    title: Text(
                      'Admin',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeAdmin(),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text(
                      'Logout',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onTap: () {
                      Provider.of<UserModel>(context, listen: false).logout();

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 30.0, left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: 10.0,
                right: 15.0,
              ),
              child: SizedBox(
                width: 400,
                height: 40,
                child: TextField(
                  controller: searchController,
                  style: Theme.of(context).brightness == Brightness.light
                      ? TextStyle(color: Colors.black, fontSize: 14)
                      : TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    labelText: 'Search Food',
                    labelStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                    hintText: 'Search for food items...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              'Fast order',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              'Discover and get great shopping',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 1.0,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(127, 82, 147, 122),
                        padding: EdgeInsets.all(8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Top',
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(57, 158, 158, 158),
                        padding: EdgeInsets.all(8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Categories()),
                        );
                      },
                      child: Text(
                        'All categories',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
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
                        ),
                        trailing: Text(
                          '\$${foodItems[index]['price'].toString()}',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Details(
                                foodItem: foodItems[index],
                              ),
                            ),
                          );
                        },
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
