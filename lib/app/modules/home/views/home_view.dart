import 'package:barcode_widget/barcode_widget.dart';
import 'package:barcode/barcode.dart' as barcodeWidget;
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_btprinter/app/controller/printer_controller.dart';

import 'package:get/get.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image/image.dart' as imageLib;

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<PrinterController> {
  HomeView({Key? key}) : super(key: key);

  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.SETTING),
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: ListView(
        children: [
          // test print ticket
          ListTile(
            leading: const Icon(Icons.print),
            title: const Text("Print ticket"),
            onTap: () {
              // print ticket
              printTicket();
            },
          ),
        ],
      ),
    );
  }

  void printTicket() {
    screenshotController
        .captureFromWidget(
            SizedBox(
              width: 140,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 140 * 0.5,
                    child: Image.network("https://img.icons8.com/windows/512/flutter.png"),
                  ),
                  Text(
                    "ราเมน นางแบบออดิทอเรียมอพาร์ทเมนท์อัลบัมแล็บ ติว ไฮบริด ภคันทลาพาธสตาร์ทศึกษาศาสตร์ซัพพลาย ລາເມງໂມບາຍນາງແບບອໍດິທອລ ມໍ ພັດທະເມັນ ອັລບັ້ມແລັບຕິວ ໄຮບຼິດ ພັດຄັນທະລາພັດສະຕາດ ສຶກສາສາດສະພັດໄລ",
                    maxLines: 20,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    width: 140 * 0.5,
                    child: BarcodeWidget(
                      barcode: barcodeWidget.Barcode.qrCode(),
                      data: 'Hello Flutter I Love You!',
                    ),
                  )
                ],
              ),
            ),
            delay: Duration(seconds: 3))
        .then(
      (capturedImage) async {
        List<int> bytes = [];
        // Using default profile
        final profile = await CapabilityProfile.load();
        final generator = Generator(PaperSize.mm58, profile);
        bytes += generator.reset();
        // Handle captured image
        final imageLib.Image? image = imageLib.decodeImage(capturedImage);
        bytes += generator.image(image!);
        bytes += generator.feed(1);
        //bytes += generator.cut();
        await PrintBluetoothThermal.writeBytes(bytes);
      },
    );
  }
}
