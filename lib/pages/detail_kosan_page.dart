import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kosan_ku/constants/constant_colors.dart';
import 'package:kosan_ku/constants/constant_text_style.dart';
import 'package:kosan_ku/routes/route_name.dart';
import 'package:link_text/link_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class DetailKosanPage extends StatelessWidget {
  const DetailKosanPage({super.key});

  @override
  Widget build(BuildContext context) {
    var arguments = Get.arguments;
    String username = '';
    if (arguments is Map && arguments.containsKey('username')) {
      username = arguments['username'] ?? '';
    }
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
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      arguments['nama_kost'],
                      style: PoppinsStyle.stylePoppins(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.275,
                    child:  ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: arguments['images'].length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Image.network(arguments['images'][index]),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Kos ${arguments['kategori']}',
                        style: PoppinsStyle.stylePoppins(
                          color: fontBlue,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Sisa ${arguments['jumlah_kamar']} kamar',
                        style: PoppinsStyle.stylePoppins(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Deskripsi',
                    style: PoppinsStyle.stylePoppins(
                      color: fontBlue,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    arguments['deskripsi'],
                    style: PoppinsStyle.stylePoppins(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 10),
                  Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Peraturan',
                    style: PoppinsStyle.stylePoppins(
                      color: fontBlue,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    arguments['peraturan'],
                    style: PoppinsStyle.stylePoppins(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Alamat',
                    style: PoppinsStyle.stylePoppins(
                      color: fontBlue,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    arguments['alamat'],
                    style: PoppinsStyle.stylePoppins(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Informasi Lainnya',
                    style: PoppinsStyle.stylePoppins(
                      color: fontBlue,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Range Harga: Rp.${arguments['min_harga']} - Rp.${arguments['max_harga']}',
                    overflow: TextOverflow.ellipsis,
                    style: PoppinsStyle.stylePoppins(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Kontak Pemilik: ',
                        style: PoppinsStyle.stylePoppins(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await Clipboard.setData(ClipboardData(text: arguments['kontak']));
                          Get.snackbar(
                            'Kontak disalin ke clipboard',
                            'Silahkan hubungi pemilik kosan',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                        },
                        child: Text(
                          '${arguments['kontak']}',
                          style: PoppinsStyle.stylePoppins(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  LinkText(
                    'Maps : ${arguments['link_gmaps']}',
                    textStyle: PoppinsStyle.stylePoppins(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    linkStyle: PoppinsStyle.stylePoppins(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    onLinkTap: (link) async {
                      String link = arguments['link_gmaps'] ?? '';
                      try {
                        // Resolusi shortened link
                        if (await canLaunchUrl(Uri.parse(link))) {
                          await launchUrl(
                            Uri.parse(link),
                            mode: LaunchMode.externalApplication,
                            webViewConfiguration: const WebViewConfiguration(
                              enableJavaScript: true,
                            ),
                          );
                        } else {
                          throw 'Could not launch $link';
                        }
                      } catch (e) {
                        log('Error: $e');
                        await Clipboard.setData(ClipboardData(text: link));
                        // Menampilkan error menggunakan SnackBar
                        Get.snackbar(
                          'Link google maps disalin ke clipboard',
                          'Gagal membuka google maps, silahkan buka link secara manual',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  if (username != '')
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blue,
                          disabledBackgroundColor: blueLight,
                        ),
                        onPressed: () => Get.toNamed(
                          RouteName.editKosan,
                          arguments: arguments,
                        ),
                        child: Text('Edit Kos',
                            style: PoppinsStyle.stylePoppins(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                ],
              ))),
    );
  }
}
