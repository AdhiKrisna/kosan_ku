import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kosan_ku/constants/constant_colors.dart';
import 'package:kosan_ku/constants/constant_text_style.dart';
import 'package:kosan_ku/routes/route_name.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    var arguments = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('KosanKu',
            style: PoppinsStyle.stylePoppins(
              color: fontBlue,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hai, $arguments",
              style: PoppinsStyle.stylePoppins(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: blue,
                  disabledBackgroundColor: blueLight,
                ),
                onPressed: () =>
                    Get.toNamed(RouteName.tambahKosan, arguments: arguments),
                child: Text('Tambah Kos',
                    style: PoppinsStyle.stylePoppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: blue,
                  disabledBackgroundColor: blueLight,
                ),
                onPressed: () =>
                    Get.toNamed(RouteName.listKosan, arguments: arguments),
                child: Text('List Kos',
                    style: PoppinsStyle.stylePoppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  disabledBackgroundColor: Colors.red,
                ),
                onPressed: () {
                  Get.snackbar(
                    'Logout',
                    'You have been logged out successfully',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                  Get.offNamed(RouteName.home);

                },
                child: Text('Logout',
                    style: PoppinsStyle.stylePoppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
