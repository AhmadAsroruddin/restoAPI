import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_api/api/api_service.dart';
import 'package:restaurant_api/models/restaurant.dart';
import 'package:restaurant_api/screens/restaurant_list_page.dart';
import 'package:restaurant_api/screens/search_page.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import '../main.dart';
import '../provider/restaurant_provider.dart';
import '../services/notify_helper.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
  static const routeName = '/homePage';
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  var notificationHelper = NotificationHelper();
  var _notifSetting = false;

  void _showNotification() async {
    List<Restaurant> res =
        await Provider.of<RestaurantProvider>(context, listen: false)
            .result
            .restaurants;

    var randomIndex = Random().nextInt(res.length);

    notificationHelper.scheduleNotification(flutterLocalNotificationsPlugin, 20,
        20, res[randomIndex].name, res[randomIndex].city);
    print("Notification Set");
  }

  @override
  void initState() {
    notificationHelper.initNotifications(flutterLocalNotificationsPlugin);
    notificationHelper.configureDidReceiveLocalNotificationSubject(context, '');
    notificationHelper.configureSelectNotificationSubject(context, '');
    notifSetting();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  void notifSetting() async {
    final prefs = await SharedPreferences.getInstance();
    bool data = prefs.getBool("notificationSetting") ?? false;
    setState(() {
      _notifSetting = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if (_notifSetting) {
      _showNotification();
    }

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
