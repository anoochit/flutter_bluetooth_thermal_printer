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
            icon: const Icon(Icons.settings),
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
                  SizedBox(
                    width: 140 * 0.5,
                    child: Image.asset("assets/flutter.png"),
                  ),
                  const Text(
                    "ราเมน นางแบบออดิทอเรียมอพาร์ทเมนท์อัลบัมแล็บ ติว ไฮบริด ภคันทลาพาธสตาร์ทศึกษาศาสตร์ซัพพลาย",
                    maxLines: 5,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    "ລາເມງໂມບາຍນາງແບບອໍດິທອລ ມໍ ພັດທະເມັນ ອັລບັ້ມແລັບຕິວ ໄຮບຼິດ ພັດຄັນທະລາພັດສະຕາດ ສຶກສາສາດສະພັດໄລ",
                    maxLines: 5,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    "រ៉ាមេន មនុស្សយន្ត សាលប្រជុំ ផ្ទះល្វែ អាល់ប៊ុម មន្ទីរពិសោធន៍ ការបង្រៀន កូនកាត់ ផាកនថាឡា ផ្លូវ ចាប់ផ្តើម សិក្សា វិទ្យាសាស្ត្រ ការផ្គត់ផ្គង់",
                    maxLines: 5,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: 140 * 0.5,
                    child: BarcodeWidget(
                      barcode: barcodeWidget.Barcode.qrCode(),
                      data: 'Hello Flutter I Love You!',
                    ),
                  )
                ],
              ),
            ),
            delay: const Duration(milliseconds: 500))
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
