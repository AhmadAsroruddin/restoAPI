import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_api/api/api_service.dart';
import 'package:restaurant_api/provider/db_provider.dart';
import 'package:restaurant_api/provider/restaurantDetail_provider.dart';
import 'package:restaurant_api/provider/restaurant_provider.dart';
import 'package:restaurant_api/provider/search_provider.dart';
import 'package:restaurant_api/screens/search_page.dart';

import './screens/home_page_screen.dart';
import './screens/detail_page.dart';
import './models/restaurant.dart';
import 'screens/tab_screen.dart';
import 'services/notify_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper notificationHelper = NotificationHelper();
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);
  notificationHelper.requestIOSPermissions(flutterLocalNotificationsPlugin);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: ((context) => SearchProvider(apiService: ApiService())),
        ),
        ChangeNotifierProvider(
          create: ((context) =>
              RestaurantDetailProvider(apiService: ApiService())),
        ),
        ChangeNotifierProvider(
          create: (context) => DBProvider(),
        ),
        ChangeNotifierProvider(
            create: (context) => RestaurantProvider(apiService: ApiService()))
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: TabScreen.routeName,
        routes: {
          HomePage.routeName: (context) => HomePage(),
          TabScreen.routeName: (context) => TabScreen(),
          DetailPage.routeName: (context) => DetailPage(),
          SearchPage.routeName: (context) => SearchPage()
        },
      ),
    );
  }
}
