import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:grocery_app/widgets/search_widget.dart';
import 'package:grocery_app/api/product_api.dart';
import 'package:grocery_app/models/results.dart';
import 'package:grocery_app/screens/product_details/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/screens/welcome_screen.dart';

class FilterListPage extends StatefulWidget {
  final String initquery;
  const FilterListPage(this.initquery);

  @override
  FilterListPageState createState() => FilterListPageState();
}

class FilterListPageState extends State<FilterListPage> {
  List<ApiSearchResult> results = [];
  String query;
  Timer debouncer;
  String hint = 'Product Name or Brand';

  @override
  void initState() {
    super.initState();
    query = widget.initquery;
    if (query != "") hint = query;
    init();
  }

  // After ever search, timer for debouncer resets in case user types again
  @override
  void dispose() {
    debouncer.cancel();
    super.dispose();
  }

  void debounce(
      VoidCallback callback, {
        // Does the search 1s after user finishes typing
        Duration duration = const Duration(milliseconds: 1000),
      }) {
    if (debouncer != null) {
      debouncer.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  Future init() async {
    final resultsList = await ProductApi.getResults(query);

    setState(() => this.results = resultsList);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          onBackClicked(context);
        },
      ),
      title: Text("Search by text"),
      centerTitle: true,
    ),
    body: Column(
      children: <Widget>[
        buildSearch(),
        Expanded(
          child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              return buildResult(result);
            },
          ),
        ),
      ],
    ),
  );

  Widget buildSearch() => SearchWidget(
    text: query,
    hintText: hint,
    onChanged: searchResult,
  );

  Future searchResult(String query) async => debounce(() async {
    final results = await ProductApi.getResults(query);

    if (!mounted) return;

    setState(() {
      this.query = query;
      this.results = results;
    });
  });

  Widget buildResult(ApiSearchResult result) => ListTile(
    leading: Image.network(
      result.image,
      fit: BoxFit.cover,
      width: 50,
      height: 50,
    ),
    title: Text(result.name),
    subtitle: Text(result.productPrice.toString()),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailsScreen(result),
        ),
      );
    },
  );
}

void onBackClicked(BuildContext context) {
  Navigator.of(context).pushReplacement(new MaterialPageRoute(
    builder: (BuildContext context) {
      return WelcomeScreen();
    },
  ));
}