import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mocozados/_utils/color_theme.dart';
import 'package:mocozados/_utils/snackbar.dart';
import 'package:mocozados/components/input_field.dart';
import 'package:mocozados/services/auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final Auth _authService = Auth();

  /* Seleção de data de nascimento */
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      setState(() {
        _dateController.text = formattedDate;
      });
    }
  }

  /* Validators retornam null quando NÃO tem nenhum problema */
  /* Valida Nome */
  String? _nameValidate(String? value) {
    if (value == null || value.isEmpty) {
      return 'O nome não pode ser vazio!';
    }
    if (value.length < 3) {
      return 'O nome deve ter pelo menos 3 caracteres!';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'O nome deve conter apenas letras e espaços!';
    }
    return null;
  }

  /* Valida Email */
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

  /* Valida Senha */
  String? _passwordValidate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Digite uma senha';
    }
    if (value.length < 10) {
      return 'A senha deve ter no mínimo 10 caracteres';
    }
    return null;
  }

  /* Botão cadastrar */
  signUpButton() {
    if (_formKey.currentState!.validate()) {
      _authService
          .signUpUser(
            name: _nameController.text,
            email: _emailController.text,
            password: _passwordController.text,
          )
          .then((String? error) {
            if (mounted) {
              if (error != null) {
                showSnackBar(context: context, text: error, isError: true);
              } else {
                showSnackBar(
                  context: context,
                  text: "Cadastro efetuado com sucesso!",
                  isError: false,
                );
                Navigator.pop(context);
              }
            }
          });
      print('cadastrar');
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
                  Image.asset("assets/logo.png", height: 128),
                  Text(
                    "Mocozados",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: ColorTheme.quaternaryColor,
                    ),
                  ),
                  SizedBox(height: 30),
                  inputField(
                    "Nome",
                    Icons.account_circle,
                    _nameController,
                    _nameValidate,
                  ),
                  SizedBox(height: 30),
                  inputField(
                    "Email",
                    Icons.email,
                    _emailController,
                    _emailValidate,
                  ),
                  SizedBox(height: 30),
                  inputField(
                    obscure: true,
                    "Senha",
                    Icons.lock,
                    _passwordController,
                    _passwordValidate,
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorTheme.tertiaryColor,
                      ),
                      onPressed: () {
                        signUpButton();
                      },
                      child: Text(
                        'Cadastrar',
                        style: TextStyle(color: ColorTheme.quaternaryColor),
                      ),
                    ),
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
