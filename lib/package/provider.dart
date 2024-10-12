import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supermarket/package/dark_light_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = Lightmode;

  bool get isDarkMode => _themeData == Darkmode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == Lightmode) {
      themeData = Darkmode;
    } else {
      themeData = Lightmode;
    }
  }
}



// /يحفظ التطبيق بيانات في وحدة التخزين الداخلية للجهاز///
class UserModel with ChangeNotifier {
  String _email = '';
  String _password = '';
  String _name = '';
  bool _isLoggedIn = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;  //firebase
  String get profilePictureUrl => "assets/food.jpg";
  String get name => _name;
  String get email => _email;
  bool get isLoggedIn => _isLoggedIn;
  

  // دالة تسجيل الدخول
  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _email = email;
      _isLoggedIn = true;
      await _saveUserData(); 
      notifyListeners();
    } catch (e) {
      print('Error: $e');
    }
  }

  // دالة التسجيل
  void register(String name, String email, String password) async {
    _name = name;
    _email = email;
    _password = password;
    _isLoggedIn = true;
    await _saveUserData(); // حفظ بيانات المستخدم
    notifyListeners();
  }

  // دالة لتسجيل الخروج
  void logout() {
    _email = '';
    _password = '';
    _isLoggedIn = false;
    notifyListeners();
  }

  // دالة لحفظ بيانات المستخدم في SharedPreferences
  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', _email);
    await prefs.setString('userName', _name);
  }
  Future<void> loadUserData() async {
  final prefs = await SharedPreferences.getInstance();
  _email = prefs.getString('userEmail') ?? '';
  _name = prefs.getString('userName') ?? '';
  _isLoggedIn = _email.isNotEmpty; // تعيين حالة تسجيل الدخول بناءً على وجود البريد الإلكتروني
  notifyListeners();
}
}





// /يحفظ التطبيق بيانات في وحدة التخزين الداخلية للجهاز///
class CartModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  CartModel() {
    _loadCartFromPrefs();
  }

  void addItem(String name,double? price, String image, int quantity, double total) {
    _items.add({
      "Name": name,
      "Price": price,
      "Image": image,
      "Quantity": quantity.toString(),
      "Total": total.toStringAsFixed(2),
    });
    _saveCartToPrefs();
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    _saveCartToPrefs();
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _saveCartToPrefs();
    notifyListeners();
  }

  void updateItemQuantity(int index, int newQuantity) {
    _items[index]["Quantity"] = newQuantity.toString();
    _saveCartToPrefs();
    notifyListeners();
  }

  double get totalPrice {
    double total = 0.0;
    for (var item in _items) {
      total += double.parse(item["Total"]);
    }
    return total;
  }


// json عند استرجاع البيانات، يتم تحويل النص إلى كائنات Dart مرة أخرى للتعامل معها في التطبيق.
//الصور والملفات نوع معقد فيتم استخدام JSON
  Future<void> _saveCartToPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String cartData = jsonEncode(_items);
    await prefs.setString('cart_items', cartData);
  }

  Future<void> _loadCartFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartData = prefs.getString('cart_items');
    if (cartData != null) {
      List<dynamic> loadedItems = jsonDecode(cartData);
      _items.clear();
      loadedItems.forEach((item) {
        _items.add(Map<String, dynamic>.from(item));
      });
      notifyListeners();
    }
  }
}



