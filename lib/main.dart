import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kosan_ku/routes/route_name.dart';
import 'package:kosan_ku/routes/route_page.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kosan Ku',
      debugShowCheckedModeBanner: false,
      getPages: RoutePages().routes,
      initialRoute: RouteName.splash,
    );
  }
}