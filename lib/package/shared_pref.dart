import 'package:shared_preferences/shared_preferences.dart'; 


class SharedPreferenceHelper {

  static const String userProfileKey = "USERPROFILEKEY"; 
  static const String userNameKey = "USERNAMEKEY"; 
  static const String userEmailKey = "USEREMAILKEY"; 
  static const String userIdKey = "USERIDKEY"; 
  static const String userWalletKey = "USERWALLETKEY"; 

  static SharedPreferences? _prefs; // متغير لتخزين SharedPreferences


  static Future<SharedPreferences> _getPrefs() async {
    // تهيئة SharedPreferences مرة واحدة فقط
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs!; 
  }

  // دالة لحفظ بروفايل المستخدم
  Future<bool> saveUserProfile(String userProfile) async {
    final prefs = await _getPrefs();
    return prefs.setString(userProfileKey, userProfile); // حفظ بيانات البروفايل
  }

  // دالة لاسترجاع بروفايل المستخدم
  Future<String?> getUserProfile() async {
    final prefs = await _getPrefs();
    return prefs.getString(userProfileKey); // استرجاع بيانات البروفايل
  }

  // دالة لحفظ معرف المستخدم
  Future<bool> saveUserId(String userId) async {
    final prefs = await _getPrefs();
    return prefs.setString(userIdKey, userId); // حفظ معرف المستخدم
  }

  // دالة لاسترجاع معرف المستخدم
  Future<String?> getUserId() async {
    final prefs = await _getPrefs();
    return prefs.getString(userIdKey); // استرجاع معرف المستخدم
  }

  // دالة لحفظ اسم المستخدم
  Future<bool> saveUserName(String userName) async {
    final prefs = await _getPrefs();
    return prefs.setString(userNameKey, userName); // حفظ اسم المستخدم
  }

  // دالة لاسترجاع اسم المستخدم
  Future<String?> getUserName() async {
    final prefs = await _getPrefs();
    return prefs.getString(userNameKey); // استرجاع اسم المستخدم
  }

  // دالة لحفظ البريد الإلكتروني للمستخدم
  Future<bool> saveUserEmail(String userEmail) async {
    final prefs = await _getPrefs();
    return prefs.setString(userEmailKey, userEmail); // حفظ البريد الإلكتروني
  }

  // دالة لاسترجاع البريد الإلكتروني للمستخدم
  Future<String?> getUserEmail() async {
    final prefs = await _getPrefs();
    return prefs.getString(userEmailKey); // استرجاع البريد الإلكتروني
  }

  // دالة لحفظ محفظة المستخدم
  Future<bool> saveUserWallet(String userWallet) async {
    final prefs = await _getPrefs();
    return prefs.setString(userWalletKey, userWallet); // حفظ محفظة المستخدم
  }

  // دالة لاسترجاع محفظة المستخدم
  Future<String?> getUserWallet() async {
    final prefs = await _getPrefs();
    return prefs.getString(userWalletKey); // استرجاع محفظة المستخدم
  }

  // دالة لمسح بيانات المستخدم
  Future<bool> clearUserData() async {
    final prefs = await _getPrefs();
    return prefs.clear(); // مسح جميع البيانات المحفوظة
  }
}















































  

  // Save user name
  // Future<bool> saveUserName(String userName) async {
  //   final prefs = await _getPrefs();
  //   return prefs.setString(userNameKey, userName);
  // }

  // // Get user name
  // Future<String?> getUserName() async {
  //   final prefs = await _getPrefs();
  //   return prefs.getString(userNameKey);
  // }

  // // Save user email
  // Future<bool> saveUserEmail(String userEmail) async {
  //   final prefs = await _getPrefs();
  //   return prefs.setString(userEmailKey, userEmail);
  // }

  // // Get user email
  // Future<String?> getUserEmail() async {
  //   final prefs = await _getPrefs();
  //   return prefs.getString(userEmailKey);
  // }