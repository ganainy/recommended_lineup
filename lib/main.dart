import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:recommended_lineup/screens/home/home.dart';
import 'package:recommended_lineup/screens/home/home_controller.dart';

import 'customization/my_theme.dart';
import 'network/dio_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //initialize dio
  await DioHelper.init();
  //initialize get storage
  await GetStorage.init();
  //initialize getx controller
  Get.put(HomeController());

  //disable landscape mode
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recommended Lineup',
      theme: MyTheme.lightTheme,
      home: HomeScreen(),
    );
  }
}
