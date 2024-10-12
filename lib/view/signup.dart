import 'package:flutter/material.dart';
import 'package:supermarket/view/login.dart';
import 'package:supermarket/view/bottomnav.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:random_string/random_string.dart';
import 'package:provider/provider.dart';
import 'package:supermarket/package/provider.dart';
import 'package:supermarket/package/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "", password = "", name = "";
  bool isChecked = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  registration()async {
    if (_formKey.currentState!.validate() && isChecked ) { 
      setState(() {
        email = mailController.text;
        name = nameController.text;
        password = passwordController.text;
      });
 try {
      // تسجيل المستخدم في Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      String userId = randomAlphaNumeric(10); // توليد معرف عشوائي للمستخدم

      // تخزين البيانات في Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'wallet': '0', // القيمة الافتراضية للمحفظة
        'id': userId,
      });

      // تخزين البيانات في SharedPreferences
      SharedPreferenceHelper().saveUserName(name);
      SharedPreferenceHelper().saveUserEmail(email);

      // إظهار رسالة نجاح
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Color.fromARGB(255, 82, 147, 122),
        content: Text(
          "Registered Successfully",
          style: TextStyle(fontSize: 20.0),
        ),
      ));
    final list = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    if (list.isNotEmpty) {
      // البريد الإلكتروني مستخدم
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text("The email address is already in use by another account."),
      ));
      return;
    }
      // الانتقال إلى صفحة تسجيل الدخول
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } catch (e) {
      // في حال وجود خطأ، إظهار رسالة
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Color.fromARGB(255, 189, 0, 0),
        content: Text("Error: $e"),
      ));
    }
  }else {

      if (!isChecked) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color.fromARGB(255, 189, 0, 0),
          content: Text("You must agree to the terms and conditions."),
        ));
      }
     }
     

  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Expanded(
          child: Container(
            color: Theme.of(context).colorScheme.secondary,
            child: Stack(
              children: [
                Container(
            padding: const EdgeInsets.only(top: 45.0, left: 20.0, right: 20.0),
            height: MediaQuery.of(context).size.height / 2.3,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.elliptical(MediaQuery.of(context).size.width, 105.0),
              ),
            ),
          ),
                Container(
                  margin: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
                  child: Column(
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/logo2.png",
                          width: MediaQuery.of(context).size.width / 2.3,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 1.4,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                SizedBox(height: 20.0),
                                Text(
                                  "Sign up",
                                  style:TextStyle(
                                    color:Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                TextFormField(
                                  controller: nameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Name';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Name',
                                    hintStyle: TextStyle(
                                        color:Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Poppins',
                                    ),
                                    prefixIcon: Icon(Icons.person_outlined,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                TextFormField(
                                  controller: mailController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter E-mail';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                   hintStyle: TextStyle(
                                        //color:Colors.black,
                                        color:Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Poppins',
                                    ),
                                    prefixIcon: Icon(Icons.email_outlined,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                TextFormField(
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  controller: passwordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Password';
                                    }
                                    return null;
                                  },
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    hintStyle: TextStyle(
                                        color:Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Poppins',
                                    ),
                                    prefixIcon: Icon(Icons.lock_outlined,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                Row(
                                  children: [
                                    Checkbox(
                                    
                                      value: isChecked,
                                      onChanged: (value) {
                                        setState(() {
                                          isChecked = value!;
                                        });
                                      },
                                     activeColor: Theme.of(context).colorScheme.primary, 
                                     checkColor: Colors.white, 
                                    ),
                                    Expanded(
                                      child: Text(
                                        "I agree to the terms and conditions and privacy policy.",
                                        style: TextStyle(fontSize: 14,color: Colors.black,),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.0),
          
                                GestureDetector(
                                  onTap: registration,
                                  child: Material(
                                    elevation: 5.0,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.0),
                                      width: 200,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "SIGN UP",
                                          style: TextStyle(
                                            color:Colors.white,
                                            fontSize: 17.0,
                                            fontFamily: 'Poppins1',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Login()));
                        },
                        child: Text(
                          "Already have an account? Login",
                          style:TextStyle(
                              color: Colors.black
                          ) ,
          
                        ),
                      ),
                              ],
                            ),
                          ),
          
          
                          
                        ),
                      ),
                      SizedBox(height: 50,),
                      Text('© all right reserved to Nada&Shaima&Rahaf&Malak',
                      style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontWeight: FontWeight.w200,fontSize: 12
                          ),
                      ),
                      
                      KeyboardVisibilityProvider(
                        child: Builder(
                          builder: (context) {
                            final isKeyboardVisible =
                                KeyboardVisibilityProvider.isKeyboardVisible(context);
                            return isKeyboardVisible ? SizedBox(height: 100) : Container();
                          },
                        ),
                      ),
                    ],
                    
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
