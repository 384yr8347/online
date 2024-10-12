import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:supermarket/view/forgotpassword.dart';
import 'package:supermarket/view/home.dart';
import 'package:supermarket/view/bottomnav.dart';
import 'package:supermarket/view/signup.dart';
import 'package:supermarket/package/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController useremailcontroller = TextEditingController();
  TextEditingController userpasswordcontroller = TextEditingController();
  bool isPasswordValid = false; // حالة صلاحية كلمة المرور
  List<String> savedEmails = []; // قائمة لحفظ البريد الإلكتروني

  @override
  void initState() {
    super.initState();
    _loadSavedData(); // تحميل البيانات المحفوظة عند تشغيل الصفحة
  }

  // تحميل البريد الإلكتروني المحفوظ
  _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? emails = prefs.getStringList('savedEmails');
    if (emails != null) {
      setState(() {
        savedEmails = emails;
      });
    }
  }

  //حفظ البريد الإلكتروني الجديد
  _saveEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!savedEmails.contains(email)) {
      savedEmails.add(email);
      prefs.setStringList('savedEmails', savedEmails);
    }
  }

  // حذف البريد الإلكتروني من القائمة
  _deleteEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      savedEmails.remove(email);
      prefs.setStringList('savedEmails', savedEmails);
    });
  }


  // زر تسجيل الدخول
  userLogin() {
    String email = useremailcontroller.text;
    String password = userpasswordcontroller.text;

    _saveEmail(email); // حفظ البريد الإلكتروني بعد تسجيل الدخول
    print("Login with email: $email and password: $password");

    // حفظ حالة المستخدم باستخدام UserModel
    Provider.of<UserModel>(context, listen: false).login(email, password);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BottomNav()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Text(
              'Login',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            actions: [
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
          body: SingleChildScrollView(
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/logo2.png",
                          width: MediaQuery.of(context).size.width / 2.3,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 40.0),
                      TextFormField(
                        controller: useremailcontroller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                          suffixIcon: PopupMenuButton<String>(
                            icon: Icon(Icons.arrow_drop_down),
                            onSelected: (String value) {
                              setState(() {
                                useremailcontroller.text = value;
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              return savedEmails
                                  .map<PopupMenuEntry<String>>((String value) {
                                return PopupMenuItem<String>(
                                  value: value,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(value),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          _deleteEmail(value);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }).toList();
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        controller: userpasswordcontroller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Password';
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.lock_outlined),
                        ),
                        onChanged: (value) {
                          setState(() {
                            isPasswordValid = value.isNotEmpty;
                          });
                        },
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotPassword(),
                                ),
                              );
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.0),
                      ElevatedButton(
                        onPressed: isPasswordValid
                            ? () {
                                if (_formkey.currentState!.validate()) {
                                  userLogin();
                                }
                              }
                            : null,
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUp()),
                          );
                        },
                        child: Text(
                          "Don't have an account? Sign up",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(height: 240.0),
                      Text(
                        '© [2024] [NMSR/UST]. All rights reserved.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontWeight: FontWeight.w200,
                          fontSize: 12,
                        ),
                      ),
                      if (isKeyboardVisible) SizedBox(height: 100),
                      SizedBox(height: 600.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
