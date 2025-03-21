import 'package:flutter/material.dart';
import 'package:mocozados/_utils/color_theme.dart';
import 'package:mocozados/components/input_field.dart';
import 'package:mocozados/screens/home.dart';
import 'package:mocozados/screens/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool _keepLogged = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                        onTap: () {
                          print('esqueci a senha');
                        },
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
                        if (_formKey.currentState!.validate()) {
                          print('logar - Manter logado: $_keepLogged');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Logando..."),
                              duration: Duration(milliseconds: 1100),
                            ),
                          );
                          Future.delayed(
                            const Duration(milliseconds: 1500),
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Home()),
                              );
                            },
                          );
                        }
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
                          print('cadastre-se');
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
