import 'package:farmer_app/Ui/app_components/touchable_opacity.dart';
import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  double width = 20;
  double scale = 1;
  Color color = Colors.black;

  AppBackButton({this.width = 20,this.color = Colors.black, this.scale = 1});

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
        onTap: (){
          Navigator.pop(context);
        },
        child: Image.asset("assets/icons/back-arrow.png",color: color,width: width,scale: scale,)
    );
  }
}
