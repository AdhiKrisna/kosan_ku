import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kosan_ku/constants/constant_colors.dart';
import 'package:kosan_ku/constants/constant_text_style.dart';
import 'package:kosan_ku/controllers/kosan_controller.dart';
import 'package:kosan_ku/routes/route_name.dart';

class ListKosanPage extends StatelessWidget {
  const ListKosanPage({super.key});

  @override
  Widget build(BuildContext context) {
    var arguments = Get.arguments;
    // String username = arguments ?? '';
    final kosanController = Get.put(KosanController());
    kosanController.fetchAllKosan();
    return Scaffold(
      appBar: AppBar(
        title: Text('KosanKu',
            style: PoppinsStyle.stylePoppins(
              color: fontBlue,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // List Kosan
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Obx(() {
                return ListView.builder(
                  itemCount: kosanController.kosanList.length,
                  itemBuilder: (context, index) {
                    if (kosanController.kosanList[index]['pemilik'] == arguments) {
                      return ListTile(
                        title: Text(
                          kosanController.kosanList[index]['nama_kost'],
                          style: PoppinsStyle.stylePoppins(
                            color: fontBlue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              overflow: TextOverflow.ellipsis,  
                              '${kosanController.kosanList[index]['alamat']}',
                              style: PoppinsStyle.stylePoppins(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              'Sisa ${kosanController.kosanList[index]['jumlah_kamar'].toString()} Kamar',
                              style: PoppinsStyle.stylePoppins(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Get.toNamed(
                            RouteName.detailKosan,
                            arguments: {
                              'username': arguments,
                              ...kosanController.kosanList[index],
                            },
                          );
                        },
                      );
                    }
                    return const SizedBox();
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
