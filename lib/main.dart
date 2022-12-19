import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  // init storage
  await GetStorage.init();

  // run app
  runApp(
    GetMaterialApp(
      title: "Bluetooth Printer",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
