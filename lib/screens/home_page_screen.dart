import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_api/api/api_service.dart';
import 'package:restaurant_api/screens/restaurant_list_page.dart';
import 'package:restaurant_api/screens/search_page.dart';

import '../provider/restaurant_provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
  static const routeName = '/homePage';
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: ((context) => RestaurantProvider(apiService: ApiService())),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Restaurant App"),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Mau makan apa?",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                controller: searchController,
                onTap: () {
                  Navigator.of(context).pushNamed(SearchPage.routeName);
                },
              ),
            ),
            const Expanded(child: RestaurantListPage()),
          ],
        ),
      ),
    );
  }
}
