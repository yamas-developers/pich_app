import 'package:farmer_app/helpers/constraints.dart';
import 'package:flutter/material.dart';

class AppLoader extends StatefulWidget {
  const AppLoader({Key? key,this.size = 80.0,this.strock = 6.0}) : super(key: key);
  final double size;
  final double strock;
  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> with TickerProviderStateMixin {
  late AnimationController progressController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 700))
        ..repeat();

  @override
  void dispose() {
    progressController.stop();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(10),
                child: Image.asset(
                  "assets/images/logo.gif",
                  width: widget.size /2,
                  height:  widget.size /2,
                ),
              )),
          SizedBox(
            height:  widget.size,
            width:  widget.size,
            child: CircularProgressIndicator(
              strokeWidth: widget.strock,
              valueColor: createColorTween(progressController),
            ),
          ),
        ],
      ),
    );
  }
}
