import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreenTextField extends StatelessWidget {
  AuthScreenTextField({
    Key? key,
    required this.label,
    required this.icon,
    this.controller,
    this.obscureText = false,
    this.errorText = '',
    this.prefixText = '',
    this.hintText = '',
    this.inputType = TextInputType.text,
    this.showNonNumericDigits = true
  }) : super(key: key);
  final String label;
  final IconData icon;
  TextEditingController? controller;
  bool obscureText = false;
  String errorText;
  String prefixText;
  String hintText;
  TextInputType inputType;
  bool showNonNumericDigits;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: TextField(
        keyboardType: inputType,
        controller: controller,
        obscureText: obscureText,
        inputFormatters: showNonNumericDigits ? null : <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ],
        decoration: InputDecoration(
          prefixText:  (prefixText != null || prefixText != '') ? prefixText : null,
          hintText: hintText,
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
          floatingLabelStyle: TextStyle(
            fontSize: 14,
            color: Theme.of(context).accentColor,
          ),
          errorText: (errorText != null || errorText != '') ? errorText : null,
          errorMaxLines: 5,
          errorBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          errorStyle: TextStyle(
            fontSize: 11,
            color: Theme.of(context).errorColor,
          ),
          focusedErrorBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
          prefixIcon: ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (Rect bounds) => LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              // radius: 5,
              colors: [
                Theme.of(context).accentColor,
                Colors.yellow,
              ],
            ).createShader(bounds),
            child: Icon(
              icon,
              // color: Colors.transparent,
            ),
          ),

          // borderRadius: BorderRadius.circular(10)
          // borderRadius: BorderRadius.circular(10)
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
