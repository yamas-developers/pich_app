import 'package:farmer_app/Ui/search/search_post_area.dart';
import 'package:farmer_app/Ui/search/search_profiles_area.dart';
import 'package:farmer_app/Ui/search/search_profile_item.dart';
import 'package:farmer_app/Ui/posts/post_item.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:flutter/material.dart';
import 'package:farmer_app/providers/social/social_provider.dart';
import 'package:provider/provider.dart';

class SearchScreenSheet extends StatefulWidget {
  const SearchScreenSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchScreenSheet> createState() => _SearchScreenSheetState();
}

class _SearchScreenSheetState extends State<SearchScreenSheet> {
  TextEditingController searchFieldController = TextEditingController();
  String searchString = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 12),
            child: Container(
              height: 42,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Users',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 16),
            child: TextField(
              controller: searchFieldController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, -2, -2, -2),
                fillColor: kGreyColor,
                filled: true,
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        searchString = searchFieldController.text;
                      });
                    },
                    icon: Icon(Icons.search)),
                label: Text('Search'),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Expanded(
            // height: getHeight(context) - 80,
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SearchProfilesArea(
                searchString: searchString,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SocialScreenSheet extends StatefulWidget {
  static const String routeName = "/social";

  const SocialScreenSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<SocialScreenSheet> createState() => _SocialScreenSheetState();
}

class _SocialScreenSheetState extends State<SocialScreenSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 12),
            child: Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      "assets/icons/back-arrow.png",
                      height: 25,
                    )),
                Container(
                  height: 42,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      context.watch<SocialProvider>().type == 'followers'
                          ? 'Followers'
                          : 'Following',
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            // height: getHeight(context) - 80,
            child: SocialProfilesArea(),
          ),
        ],
      ),
    );
  }
}
