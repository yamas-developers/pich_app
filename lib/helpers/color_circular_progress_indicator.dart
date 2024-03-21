import 'package:farmer_app/helpers/constraints.dart';
import 'package:flutter/material.dart';

class ColorCircularProgressIndicator extends StatefulWidget {
  final String message;
  final bool showMessage;
  final double height;
  final double width;
  final double stroke;
  ColorCircularProgressIndicator({this.message = 'loading', this.height = 60, this.width = 60, this.stroke = 6, this.showMessage = true});

  @override
  State<ColorCircularProgressIndicator> createState() => _ColorCircularProgressIndicatorState();
}

class _ColorCircularProgressIndicatorState extends State<ColorCircularProgressIndicator> with TickerProviderStateMixin {
  late AnimationController progressController =
  AnimationController(vsync: this, duration: Duration(milliseconds: 700))..repeat();
  @override
  void dispose() {
    progressController.stop();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return   Padding(
      padding: const EdgeInsets.all(0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if(widget.showMessage)Text(widget.message,
          style: TextStyle(
            fontSize: 8,
          ),),
          SizedBox(
            height: widget.height,
            width: widget.width,
            child: CircularProgressIndicator(
              strokeWidth: widget.stroke,
              valueColor: createColorTween(progressController),
            ),
          ),
        ],
      ),
    );
  }
}
