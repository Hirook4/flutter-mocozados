import 'package:flutter/material.dart';
import 'package:mocozados/_utils/color_theme.dart';
import 'package:mocozados/_utils/snackbar.dart';
import 'package:mocozados/components/input_field.dart';
import 'package:mocozados/screens/home.dart';
import 'package:mocozados/screens/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mocozados/services/auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool _keepLogged = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final Auth _authService = Auth();
  @override
  void initState() {
    super.initState();
    _loadKeepLogged();
  }

  Future<void> _loadKeepLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _keepLogged = prefs.getBool('keepLogged') ?? false;
    });
  }

  Future<void> _saveKeepLogged(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('keepLogged', value);
  }

  /* Valida email */
  String? _emailValidate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Digite um E-mail';
    }

    final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email Inválido';
    }
    return null;
  }

  /* Valida senha */
  String? _passwordValidate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Digite uma senha';
    }
    if (value.length < 10) {
      return 'A senha deve ter no mínimo 10 caracteres';
    }
    return null;
  }

  /* Botão Logar */
  signInButton() {
    if (_formKey.currentState!.validate()) {
      _authService
          .signInUser(
            email: _emailController.text,
            password: _passwordController.text,
          )
          .then((String? error) {
            if (mounted) {
              if (error != null) {
                showSnackBar(context: context, text: error, isError: true);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              }
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.primaryColor,
      body: Padding(
        padding: EdgeInsets.all(25),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/logo.png', height: 128),
                  Text(
                    "Mocozados",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: ColorTheme.quaternaryColor,
                    ),
                  ),
                  SizedBox(height: 45),
                  /* Componentes inputField */
                  inputField(
                    "Email",
                    Icons.email,
                    _emailController,
                    _emailValidate,
                  ),
                  SizedBox(height: 30),
                  inputField(
                    "Senha",
                    Icons.lock,
                    _passwordController,
                    _passwordValidate,
                    obscure: true,
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: CheckboxListTile(
                          value: _keepLogged,
                          side: const BorderSide(
                            color: ColorTheme.tertiaryColor,
                          ),
                          title: Text(
                            "Manter logado",
                            style: TextStyle(
                              color: ColorTheme.quaternaryColor,
                              fontSize: 14,
                            ),
                          ),
                          activeColor: ColorTheme.tertiaryColor,
                          checkColor: ColorTheme.quaternaryColor,
                          onChanged: (bool? newValue) {
                            setState(() {
                              _keepLogged = newValue ?? false;
                              _saveKeepLogged(_keepLogged);
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          checkboxShape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: ColorTheme.tertiaryColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          "esqueci a senha",
                          style: TextStyle(
                            color: ColorTheme.tertiaryColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorTheme.tertiaryColor,
                      ),
                      onPressed: () {
                        signInButton();
                      },
                      child: Text(
                        'login',
                        style: TextStyle(color: ColorTheme.quaternaryColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 80),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUp(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'ou ',
                                style: TextStyle(
                                  color: ColorTheme.quaternaryColor,
                                ),
                              ),
                              TextSpan(
                                text: 'cadastre-se',
                                style: TextStyle(
                                  color: ColorTheme.tertiaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
