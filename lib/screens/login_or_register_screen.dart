import 'package:firebase_intro/services/auth_service.dart';
import 'package:firebase_intro/widget/snack_bar.dart';
import 'package:flutter/material.dart';

class LoginOrRegisterScreen extends StatefulWidget {
  const LoginOrRegisterScreen({super.key});

  @override
  State<LoginOrRegisterScreen> createState() => _LoginOrRegisterScreenState();
}

class _LoginOrRegisterScreenState extends State<LoginOrRegisterScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  bool _registerPage = true;

  void _submit() async {
    _registerPage ? _register() : _login();
  }

  void _register() async {
    try {
      await _authService.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      if (mounted) {
        snackBar(context, 'Başarılı şekilde tamamlandı.',
            bgColor: Colors.green);
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        snackBar(context, 'Kullanıcı kaydedilirken bir hata oluştu.');
      }
    }
  }

  void _login() async {
    try {
      await _authService.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      if (mounted) {
        snackBar(context, 'Başarılı şekilde giriş yapıldı.',
            bgColor: Colors.green);
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        snackBar(context, 'Kullanıcı giriş yaparken bir hata oluştu.');
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
