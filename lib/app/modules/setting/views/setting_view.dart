// ignore_for_file: unnecessary_string_interpolations

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_btprinter/app/controller/printer_controller.dart';

import 'package:get/get.dart';

class SettingView extends GetView<PrinterController> {
  const SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SettingView'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              final permissionGrant = await controller.isPermissionBluetoothGranted();
              if (permissionGrant) {
                // search device
                await controller.searchDevice();
                log('found = ${controller.listResult.length} devices');
              } else {
                // permission not grant
                Get.snackbar('Error', 'Please enable nearby permission');
              }
            },
            icon: const Icon(
              Icons.search,
            ),
          )
        ],
      ),
      body: GetBuilder<PrinterController>(builder: (context) {
        return ListView.builder(
          itemCount: controller.listResult.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(controller.listResult[index].name),
              subtitle: Text(controller.listResult[index].macAdress),
              trailing: ('${controller.currentPrinter.value}' == '${controller.listResult[index].macAdress}')
                  ? const Icon(Icons.connected_tv)
                  : const SizedBox(),
              onTap: () async {
                if ('${controller.currentPrinter.value}' == '${controller.listResult[index].macAdress}') {
                  // disconnect
                  await controller.disconnectDevice();
                } else {
                  // connect
                  final macPrinterAddress = controller.listResult[index].macAdress;
                  await controller.connectDevice(macPrinterAddress);
                }
              },
            );
          },
        );
      }),
    );
  }
}
