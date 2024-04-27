import 'package:firebase_intro/screens/home_screen.dart';
import 'package:firebase_intro/services/auth_service.dart';
import 'package:firebase_intro/widget/snack_bar.dart';
import 'package:flutter/material.dart';

class LoginOrRegisterScreen extends StatefulWidget {
  const LoginOrRegisterScreen({super.key});

  @override
  State<LoginOrRegisterScreen> createState() => _LoginOrRegisterScreenState();
}

class _LoginOrRegisterScreenState extends State<LoginOrRegisterScreen> {
  final AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  bool _registerPage = true;

  void _submit() async {
    _registerPage ? _register() : _login();
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String? userId =
          await authService.signUpWithEmailAndPassword(_email, _password);
      if (userId != null) {
        if (mounted) {
          snackBar(context, "Kayıt başarılı! Kullanıcı ID: $userId",
              bgColor: Colors.green);
        }
      } else {
        if (mounted) {
          snackBar(
              context, "Kayıt olurken bir hata oluştu! Lütfen tekrar deneyin.");
        }
      }
    }
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String? userId =
          await authService.signInWithEmailAndPassword(_email, _password);
      if (userId != null) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
          snackBar(context, "Giriş başarılı! Kullanıcı ID: $userId",
              bgColor: Colors.green);
        }
      } else {
        if (mounted) {
          snackBar(
            context,
            "Giriş yaparken bir hata oluştu! Lütfen tekrar deneyin.",
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hoşgeldiniz"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_registerPage ? "Kayıt Ol" : "Giriş Yap"),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: const InputDecoration(labelText: "E-posta"),
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (newValue) {
                    _email = newValue!;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Şifre"),
                  autocorrect: false,
                  obscureText: true,
                  onSaved: (newValue) {
                    _password = newValue!;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _formKey.currentState!.save();
                    _submit();
                  },
                  child: Text(_registerPage ? "Kayıt Ol" : "Giriş Yap"),
                ),
                const SizedBox(height: 8),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _formKey.currentState!.reset();
                        _registerPage = !_registerPage;
                      });
                    },
                    child: Text(_registerPage
                        ? "Zaten üye misiniz? Giriş Yap"
                        : "Hesabınız yok mu? Kayıt Ol"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
