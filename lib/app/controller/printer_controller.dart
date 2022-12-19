import 'dart:developer';

import 'package:get/get.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class PrinterController extends GetxController {
  RxBool bluetoothEnable = false.obs;
  RxBool permissionBluetoothGranted = false.obs;
  RxBool connectionStatus = false.obs;
  RxList<BluetoothInfo> listResult = <BluetoothInfo>[].obs;

  RxString currentPrinter = "".obs;

  Future<bool> isBluetoothEnable() async {
    return await PrintBluetoothThermal.bluetoothEnabled;
  }

  Future<bool> isPermissionBluetoothGranted() async {
    return await PrintBluetoothThermal.isPermissionBluetoothGranted;
  }

  Future<bool> printerConnectionStatus() async {
    return await PrintBluetoothThermal.connectionStatus;
  }

  searchDevice() async {
    listResult.value = await PrintBluetoothThermal.pairedBluetooths;
    update();
  }

  disconnectDevice() async {
    await PrintBluetoothThermal.disconnect;
    currentPrinter.value = '';
    update();
  }

  connectDevice(String macPrinterAddress) async {
    final result = await PrintBluetoothThermal.connect(macPrinterAddress: macPrinterAddress);
    if (result == true) {
      currentPrinter.value = macPrinterAddress;
    } else {
      Get.snackbar('Error', 'Cannot connect');
    }
    update();
  }

  @override
  void onClose() {
    log("close");
    super.onClose();
  }
}
