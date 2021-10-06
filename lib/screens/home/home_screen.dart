import 'dart:math';
import 'package:flappy_search_bar/scaled_tile.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:grocery_app/models/grocery.dart';
import 'package:grocery_app/widgets/grocery_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SearchBarController<Grocery> _searchBarController = SearchBarController();
  bool isReplay = false;

  Future<List<Grocery>> _getGroceries(String text) async {
    List<Grocery> groceries = [];
    text = text.replaceAll(' ', '+');

    final response = await http
        .get(Uri.parse('http://vribli.pythonanywhere.com/?keyword=' + text + '&n=10'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      var decoded = jsonDecode(response.body);
      for (var json in decoded) {
        groceries.add(Grocery.fromJson(json));
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

    return groceries;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SearchBar<Grocery>(
          minimumChars: 1,
          searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
          headerPadding: EdgeInsets.symmetric(horizontal: 10),
          listPadding: EdgeInsets.symmetric(horizontal: 10),
          onSearch: _getGroceries,
          searchBarController: _searchBarController,
          placeHolder: Center(
              child: Text(
                "Welcome to Ask Auntie!",
                style: TextStyle(fontSize: 30),
              )),
          cancellationWidget: Text("Cancel"),
          emptyWidget: Text("empty"),
          onCancelled: () {
            print("Cancelled triggered");
          },
          mainAxisSpacing: 10,
          onItemFound: (Grocery grocery, int index) {
            return GroceryWidget(item: grocery);
          },
          crossAxisCount: 2,
        ),
      ),
    );
  }
}

class Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(child: Text("Detail", style: TextStyle(fontSize: 30),)),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:grocery_app/models/grocery_item.dart';
// import 'package:grocery_app/screens/product_details/product_details_screen.dart';
// import 'package:grocery_app/styles/colors.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:grocery_app/widgets/grocery_item_card_widget.dart';
// import 'package:grocery_app/widgets/search_bar_widget.dart';
//
// import 'grocery_featured_Item_widget.dart';
// import 'home_banner_widget.dart';
// import 'package:dio/dio.dart';
// import 'package:flappy_search_bar/flappy_search_bar.dart';
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => new _HomeScreenState();
// }
// class _HomeScreenState extends State<HomeScreen> {
//   // final formKey = new GlobalKey<FormState>();
//   // final key = new GlobalKey<ScaffoldState>();
//   final TextEditingController _filter = new TextEditingController();
//   final dio = new Dio();
//   String _searchText = "";
//   List names = new List();
//   List filteredNames = new List();
//   Icon _searchIcon = new Icon(Icons.search);
//   Widget _appBarTitle = new Text('Search Example');
//
//   _HomeScreenState() {
//     _filter.addListener(() {
//       if (_filter.text.isEmpty) {
//         setState(() {
//           _searchText = "";
//           filteredNames = names;
//         });
//       } else {
//         setState(() {
//           _searchText = _filter.text;
//         });
//       }
//     });
//   }
//
//   @override
//   void initState() {
//     this._getNames();
//     super.initState();
//   }
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           child: SingleChildScrollView(
//             child: Center(
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: 15,
//                   ),
//                   SvgPicture.asset("assets/icons/app_icon_color.svg"),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   padded(SearchBarWidget()),
//                   _buildBar(context),
//                   SizedBox(
//                     height: 25,
//                   ),
//                   _buildList(),
//                   SearchBar<String>(
//                     minimumChars: 1,
//                     searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
//                     headerPadding: EdgeInsets.symmetric(horizontal: 10),
//                     listPadding: EdgeInsets.symmetric(horizontal: 10),
//                     onSearch: _getALlPosts,
//                     searchBarController: _searchBarController,
//                     placeHolder: Center(
//                         child: Text(
//                           "PlaceHolder",
//                           style: TextStyle(fontSize: 30),
//                         )),
//                     cancellationWidget: Text("Cancel"),
//                     emptyWidget: Text("empty"),
//                     onCancelled: () {
//                       print("Cancelled triggered");
//                     },
//                     mainAxisSpacing: 10,
//                     onItemFound: (Post post, int index) {
//                       return Container(
//                         color: Colors.lightBlue,
//                         child: ListTile(
//                           title: Text(post.title),
//                           isThreeLine: true,
//                           subtitle: Text(post.body),
//                           onTap: () {
//                             Navigator.of(context)
//                                 .push(MaterialPageRoute(builder: (context) => Detail()));
//                           },
//                         ),
//                       );
//                     },
//                   ),
//
//
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//   //
//   // return Scaffold(
//   //   appBar: _buildBar(context),
//   //   body: Container(
//   //     child: _buildList(),
//   Widget _buildBar(BuildContext context) {
//     return new AppBar(
//       centerTitle: true,
//       title: _appBarTitle,
//       leading: new IconButton(
//         icon: _searchIcon,
//         onPressed: _searchPressed,
//
//       ),
//     );
//   }
//
//   Widget _buildList() {
//     if (!(_searchText.isEmpty)) {
//       List tempList = new List();
//       for (int i = 0; i < filteredNames.length; i++) {
//         if (filteredNames[i]['name'].toLowerCase().contains(
//             _searchText.toLowerCase())) {
//           tempList.add(filteredNames[i]);
//         }
//       }
//       filteredNames = tempList;
//     }
//     return ListView.builder(
//       itemCount: names == null ? 0 : filteredNames.length,
//       itemBuilder: (BuildContext context, int index) {
//         return new ListTile(
//           title: Text(filteredNames[index]['name']),
//           onTap: () => print(filteredNames[index]['name']),
//         );
//       },
//     );
//   }
//
//   void _searchPressed() {
//     setState(() {
//       if (this._searchIcon.icon == Icons.search) {
//         this._searchIcon = new Icon(Icons.close);
//         this._appBarTitle = new TextField(
//           controller: _filter,
//           decoration: new InputDecoration(
//               prefixIcon: new Icon(Icons.search),
//               hintText: 'Search...'
//           ),
//         );
//       } else {
//         this._searchIcon = new Icon(Icons.search);
//         this._appBarTitle = new Text('Search Example');
//         filteredNames = names;
//         _filter.clear();
//       }
//     });
//   }
//
//   void _getNames() async {
//     final response = await dio.get('https://swapi.co/api/people');
//     List tempList = new List();
//     for (int i = 0; i < response.data['results'].length; i++) {
//       tempList.add(response.data['results'][i]);
//     }
//     setState(() {
//       names = tempList;
//       names.shuffle();
//       filteredNames = names;
//     });
//   }
//
//   Widget padded(Widget widget) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 25),
//       child: widget,
//     );
//   }
// }
// //
// // class HomeScreen extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: SafeArea(
// //         child: Container(
// //           child: SingleChildScrollView(
// //             child: Center(
// //               child: Column(
// //                 children: [
// //                   SizedBox(
// //                     height: 15,
// //                   ),
// //                   SvgPicture.asset("assets/icons/app_icon_color.svg"),
// //                   SizedBox(
// //                     height: 5,
// //                   ),
// //                   padded(locationWidget()),
// //                   SizedBox(
// //                     height: 15,
// //                   ),
// //                   padded(SearchBarWidget()),
// //                   SizedBox(
// //                     height: 25,
// //                   ),
// //                   padded(HomeBanner()),
// //                   SizedBox(
// //                     height: 25,
// //                   ),
// //                   padded(subTitle("Exclusive Order")),
// //                   getHorizontalItemSlider(exclusiveOffers),
// //                   SizedBox(
// //                     height: 15,
// //                   ),
// //                   padded(subTitle("Best Selling")),
// //                   getHorizontalItemSlider(bestSelling),
// //                   SizedBox(
// //                     height: 15,
// //                   ),
// //                   padded(subTitle("Groceries")),
// //                   SizedBox(
// //                     height: 15,
// //                   ),
// //                   Container(
// //                     height: 105,
// //                     child: ListView(
// //                       padding: EdgeInsets.zero,
// //                       scrollDirection: Axis.horizontal,
// //                       children: [
// //                         SizedBox(
// //                           width: 20,
// //                         ),
// //                         GroceryFeaturedCard(
// //                           groceryFeaturedItems[0],
// //                           color: Color(0xffF8A44C),
// //                         ),
// //                         SizedBox(
// //                           width: 20,
// //                         ),
// //                         GroceryFeaturedCard(
// //                           groceryFeaturedItems[1],
// //                           color: AppColors.primaryColor,
// //                         ),
// //                         SizedBox(
// //                           width: 20,
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   SizedBox(
// //                     height: 15,
// //                   ),
// //                   getHorizontalItemSlider(groceries),
// //                   SizedBox(
// //                     height: 15,
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget padded(Widget widget) {
// //     return Padding(
// //       padding: EdgeInsets.symmetric(horizontal: 25),
// //       child: widget,
// //     );
// //   }
// //
// //   Widget getHorizontalItemSlider(List<GroceryItem> items) {
// //     return Container(
// //       margin: EdgeInsets.symmetric(vertical: 10),
// //       height: 250,
// //       child: ListView.separated(
// //         padding: EdgeInsets.symmetric(horizontal: 20),
// //         itemCount: items.length,
// //         scrollDirection: Axis.horizontal,
// //         itemBuilder: (context, index) {
// //           return GestureDetector(
// //             onTap: () {
// //               onItemClicked(context, items[index]);
// //             },
// //             child: GroceryItemCardWidget(
// //               item: items[index],
// //             ),
// //           );
// //         },
// //         separatorBuilder: (BuildContext context, int index) {
// //           return SizedBox(
// //             width: 20,
// //           );
// //         },
// //       ),
// //     );
// //   }
// //
// //   void onItemClicked(BuildContext context, GroceryItem groceryItem) {
// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //           builder: (context) => ProductDetailsScreen(groceryItem)),
// //     );
// //   }
// //
// //   Widget subTitle(String text) {
// //     return Row(
// //       children: [
// //         Text(
// //           text,
// //           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// //         ),
// //         Spacer(),
// //         Text(
// //           "See All",
// //           style: TextStyle(
// //               fontSize: 18,
// //               fontWeight: FontWeight.bold,
// //               color: AppColors.primaryColor),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget locationWidget() {
// //     String locationIconPath = "assets/icons/location_icon.svg";
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.center,
// //       children: [
// //         SvgPicture.asset(
// //           locationIconPath,
// //         ),
// //         SizedBox(
// //           width: 8,
// //         ),
// //         Text(
// //           "Khartoum,Sudan",
// //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //         )
// //       ],
// //     );
// //   }
// // }
