import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mocozados/_utils/color_theme.dart';
import 'package:mocozados/components/input_field.dart';

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
                  TextFormField(
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorTheme.quaternaryColor,
                    ),
                    controller: _dateController,
                    decoration: InputDecoration(
                      focusColor: ColorTheme.primaryColor,
                      labelText: 'Data de Nascimento',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: ColorTheme.quaternaryColor,
                      ),
                      floatingLabelStyle: TextStyle(
                        color: ColorTheme.quaternaryColor,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: ColorTheme.tertiaryColor,
                          width: 3,
                        ),
                      ),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, seleciona uma data';
                      }
                      return null; /* Retorna null se a validação for feita */
                    },
                  ),
                  SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorTheme.tertiaryColor,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          print('cadastrar');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Cadastrando..."),
                              duration: Duration(milliseconds: 1100),
                            ),
                          );
                          Future.delayed(
                            const Duration(milliseconds: 1500),
                            () {
                              Navigator.pop(context);
                            },
                          );
                        }
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
