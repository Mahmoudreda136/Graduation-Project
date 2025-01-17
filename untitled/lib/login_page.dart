import 'package:flutter/material.dart';
import 'package:graduation_project/signup_page.dart';
import 'our_services_page.dart'; // استيراد صفحة الخدمات
import 'globals.dart'; // استيراد المتغيرات العامة

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  void _login(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // تحقق من صحة البريد الإلكتروني
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter a valid email address!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // تحقق من أن الحقول ليست فارغة
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email and Password are required!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 2)); // محاكاة عملية تسجيل الدخول

    if (email != registeredEmail || password != registeredPassword) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invalid email or password!"),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      setState(() {
        isLoggedIn = true;
        _isLoading = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OurServicesPage(
            userName: registeredName,
            userEmail: registeredEmail,
            userImage: "assets/user.jpg",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown, // إعادة اللون البني
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // الرجوع إلى الصفحة السابقة
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // أيقونة كبيرة تشبه تسجيل الدخول
              SizedBox(height: 40),
              Icon(
                Icons.person, // أيقونة شخص
                size: 100, // حجم الأيقونة
                color: Colors.brown, // لون الأيقونة
              ),
              SizedBox(height: 24),
              // عنوان الصفحة
              Text(
                "Log in",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown, // إعادة اللون البني
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              // حقل الإيميل
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.brown),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.brown),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.brown, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // حقل كلمة المرور
              TextField(
                controller: passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: Colors.brown),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.brown),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.brown, width: 2),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.brown,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 24),
              // زر تسجيل الدخول
              _isLoading
                  ? Center(child: CircularProgressIndicator(color: Colors.brown))
                  : ElevatedButton(
                onPressed: () => _login(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown, // إعادة اللون البني
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Log in",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 16),
              // رابط الانتقال إلى صفحة التسجيل
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You do not have an account? ",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignupPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        color: Colors.brown, // إعادة اللون البني
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}