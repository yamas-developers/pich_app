import 'package:flutter/material.dart';

import '../../helpers/color_constants.dart';

class CircularInputField extends StatefulWidget {
  TextEditingController? controller;
  Icon? rightIcon;
  String label;
  String? value;
  String hintText;
  Icon? leftIcon;
  Color? labelColor;
  Color? barColor;
  final onChanged;
  bool readOnly = false;
  TextInputType type = TextInputType.text;
  Color? TextColor;
  int? maxLines;
  int? minLines;
  bool obscureText = false;
  Color? bgColor = Colors.white.withOpacity(.4);
  bool enabled = true;
  FloatingLabelBehavior floatingLabelBehavior;

  CircularInputField(
      {this.label = '',
      this.hintText = '',
      this.value,
      this.rightIcon,
      this.leftIcon,
      this.barColor,
      this.labelColor,
      this.readOnly = false,
      this.onChanged,
      this.type = TextInputType.text,
      this.TextColor = Colors.black,
      this.maxLines = 1,
      this.minLines = 1,
      this.obscureText = false,
      this.controller,
      this.bgColor,
      this.enabled = true,
      this.floatingLabelBehavior = FloatingLabelBehavior.always});

  @override
  _CircularInputFieldState createState() => _CircularInputFieldState();
}

class _CircularInputFieldState extends State<CircularInputField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      onTap: null,
      cursorColor: Theme.of(context).cursorColor,
      obscureText: widget.obscureText,
      initialValue: widget.value,
      showCursor: true,
      //add this line
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      // maxLength: ,
      keyboardType: widget.type,
      style: TextStyle(color: widget.TextColor),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(
          color: widget.labelColor,
        ),
        enabled: widget.enabled,
        filled: false,
        // fillColor: widget.bgColor,
        floatingLabelBehavior: widget.floatingLabelBehavior,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
        contentPadding:
            const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
        // border: OutlineInputBorder(
        //   borderSide: BorderSide(color: Theme.of(context).primaryColor),
        //   borderRadius: BorderRadius.circular(10.7),
        // ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(10.7),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(10.7),
        ),
      ),
    );
  }
}

class default_button extends StatelessWidget {
  const default_button({
    Key? key,
    this.text,
    this.press,
  }) : super(key: key);
  final String? text;
  final Function? press;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: kYellowColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onPressed: press as void Function()?,
      child: Text(
        text!,
        style: TextStyle(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class defaulTextField extends StatelessWidget {
  const defaulTextField({
    Key? key,
    this.labelText,
  }) : super(key: key);
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style:
          TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500),
      cursorColor: kprimaryColor,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(19)),
          borderSide: BorderSide(color: kprimaryColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(19)),
          borderSide: BorderSide(color: kprimaryColor, width: 1.0),
        ),
        labelText: labelText!,
        labelStyle: TextStyle(color: Colors.grey.shade700),
      ),
    );
  }
}

class profileTextField extends StatelessWidget {
  profileTextField({
    Key? key,
    this.labelText,
    this.icon,
    this.controller,
    this.showKeyboard = true,
    this.onTap,
  }) : super(key: key);
  final String? labelText;
  TextEditingController? controller;
  final icon;
  bool showKeyboard;

  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: showKeyboard ? TextInputType.text : TextInputType.none,
      onTap: onTap,
      controller: controller,
      style: TextStyle(fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          // color: Theme.of(context).primaryColor,
        ),
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
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
