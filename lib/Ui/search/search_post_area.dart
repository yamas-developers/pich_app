import 'package:farmer_app/Ui/posts/post_item.dart';
import 'package:flutter/material.dart';
class SearchPostArea extends StatelessWidget {
  const SearchPostArea({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
      color: Colors.white,
      child: ListView(
        children: [
          PostItem(),
          PostItem(),
          PostItem(),
          PostItem(),
        ],
      ),
    );
  }
}
