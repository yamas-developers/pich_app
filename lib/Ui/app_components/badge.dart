import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge({
    Key? key,
    required this.value,
    this.color,
  }) : super(key: key);

  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: color != null ? color : Theme.of(context).accentColor,
      ),
      constraints: BoxConstraints(
        minWidth: 12,
        minHeight: 12,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 2, 8, 4),
        child: Text(value,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
