import 'package:farmer_app/helpers/public_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppColorButton extends StatefulWidget {
  String? name;
  final onPressed;
  bool isDisable = false;
  Color color = Colors.blue;
  bool isLoading = false;
  double elevation = 10;
  double fontSize = 16;
  

  AppColorButton(
      {this.onPressed,
      this.name,
      this.color = Colors.blue,
      this.isDisable = false,
      this.isLoading = false,
      this.elevation = 10,
      this.fontSize = 16});

  @override
  _AppColorButtonState createState() => _AppColorButtonState();
}

class _AppColorButtonState extends State<AppColorButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(

        onPressed: !widget.isDisable
            ? widget.onPressed
            : () {
                print("In Button" + widget.isLoading.toString());
                print("In Button" + widget.isDisable.toString());
              },
        style: ButtonStyle(
          elevation: MaterialStateProperty.resolveWith((states) => widget.elevation),
            backgroundColor:
                MaterialStateColor.resolveWith((states) => Colors.transparent),
            padding:
                MaterialStateProperty.all(EdgeInsets.fromLTRB(0, 0, 0, 0))),
        child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8),
            width: getWidth(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.name!,
                  style: TextStyle(color: Colors.white,fontSize: widget.fontSize),
                ),
                SizedBox(
                  width: widget.isLoading ? 5 : 0,
                ),
                widget.isLoading
                    ? SizedBox(
                        height: 20.0,
                        width: 20,
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                            strokeWidth: 2.0))
                    : SizedBox(),
              ],
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10)],
                color:widget.color)));
  }
}
