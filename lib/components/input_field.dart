import 'package:flutter/material.dart';
import 'package:mocozados/_utils/color_theme.dart';

TextFormField inputField(
  String label,
  IconData icon,
  TextEditingController controller,
  String? Function(String?) validator, {
  bool obscure = false,
}) {
  return TextFormField(
    obscureText: obscure,
    controller: controller,
    validator: validator,
    cursorColor: ColorTheme.quaternaryColor,
    style: TextStyle(fontSize: 16, color: ColorTheme.quaternaryColor),
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
      prefixIcon: Icon(icon, color: ColorTheme.quaternaryColor),
      floatingLabelStyle: TextStyle(color: ColorTheme.quaternaryColor),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorTheme.tertiaryColor, width: 3),
      ),
    ),
  );
}

/* Backup do Antigo */

/* TextFormField(
controller: _passwordController,
cursorColor: ColorTheme.quaternaryColor,
style: TextStyle(
fontSize: 16,
color: ColorTheme.quaternaryColor,
),
obscureText: true,
decoration: InputDecoration(
labelText: 'Senha',
border: OutlineInputBorder(),
prefixIcon: Icon(
Icons.lock,
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
validator: _passwordValidate,
), */
