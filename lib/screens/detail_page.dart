import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_api/provider/restaurantDetail_provider.dart';

import '../models/restaurant.dart';
import '../models/restaurantDetail.dart';

class DetailPage extends StatelessWidget {
  static const routeName = '/detailPage';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    Icon iconStar = Icon(Icons.star);
    return Consumer<RestaurantDetailProvider>(
      builder: (context, value, child) {
        if (value.state == ResultState.loading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (value.state == ResultState.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(value.result.restaurant.name),
            ),
            body: Column(
              children: <Widget>[
                Container(
                  // margin: EdgeInsets.only(bottom: mediaQuery.height * 0.03),
                  width: double.infinity,
                  height: mediaQuery.height * 0.2,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://restaurant-api.dicoding.dev/images/large/${value.result.restaurant.pictureId}'),
                        fit: BoxFit.cover),
                  ),
                ),
                ListTile(
                  title: Text(
                    value.result.restaurant.name,
                    style: const TextStyle(fontSize: 30),
                  ),
                  trailing: Text(
                    " ${value.result.restaurant.rating}",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    value.result.restaurant.description,
                    textAlign: TextAlign.justify,
                    maxLines: 7,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                data(
                  title: "Foods",
                  e: value.result.restaurant.menus.foods,
                ),
                data(
                  title: "Beverages",
                  e: value.result.restaurant.menus.drinks,
                ),
              ],
            ),
          );
        } else if (value.state == ResultState.noData) {
          return Scaffold(
            body: Center(
              child: Material(
                child: Text(value.message),
              ),
            ),
          );
        } else if (value.state == ResultState.error) {
          return Scaffold(
            body: Center(
              child: Material(
                child: Text(value.message),
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: Material(
                child: Text(''),
              ),
            ),
          );
        }
      },
    );
  }
}

class data extends StatelessWidget {
  data({
    required this.e,
    required this.title,
    super.key,
  });

  List<Category> e;
  String title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Text(
              title,
              style: TextStyle(fontSize: 25),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: e.length,
              itemBuilder: ((context, index) {
                return Container(
                  padding: EdgeInsets.all(9),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey),
                  child: Center(
                    child: Text(e[index].name),
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
