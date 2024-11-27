import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kosan_ku/constants/constant_colors.dart';
import 'package:kosan_ku/constants/constant_text_style.dart';
import 'package:kosan_ku/controllers/kosan_controller.dart';
import 'package:kosan_ku/routes/route_name.dart';
import 'package:kosan_ku/widgets/text_form_field_widget.dart';
import 'package:latlong2/latlong.dart';

class EditKosan extends StatelessWidget {
  EditKosan({super.key});
  final controller = Get.put(KosanController());

  @override
  Widget build(BuildContext context) {
    var arguments = Get.arguments;
    log('pemilik : ${arguments['pemilik']}'); 
    if (Get.previousRoute == RouteName.detailKosan &&
        arguments != null &&
        arguments is Map<String, dynamic>) {
      controller.namaKostC.text = arguments['nama_kost'] ?? '';
      controller.kategoriC.value = arguments['kategori'] ?? '';
      controller.jumlahKamarC.text =
          arguments['jumlah_kamar']?.toString() ?? '';
      controller.minHargaC.text = arguments['min_harga']?.toString() ?? '';
      controller.maxHargaC.text = arguments['max_harga']?.toString() ?? '';
      controller.deskripsiC.text = arguments['deskripsi'] ?? '';
      controller.peraturanC.text = arguments['peraturan'] ?? '';
      controller.kontakC.text = arguments['kontak']?.toString() ?? '';
      controller.alamatC.text = arguments['alamat'] ?? '';
      controller.linkGMapsC.text = arguments['link_gmaps'] ?? '';
      if (arguments['lat'] != null && arguments['long'] != null) {
        controller.selectedLatLong.value =
            LatLng(arguments['lat'], arguments['long']);
      }
      if (arguments['images'] != null) {
        log(arguments['images'].toString());
        controller.remoteImageUrls.clear();
        controller.remoteImageUrls.value =
            (arguments['images'] as List<dynamic>)
                .map((url) => url.toString())
                .toList();
        log(controller.remoteImageUrls.length.toString());
      }
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormFieldWidget(
                  controller: controller.namaKostC, label: 'Nama Kos'),
              Text(
                'Kategori',
                style: PoppinsStyle.stylePoppins(
                  color: fontBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Obx(() {
                return DropdownButtonFormField<String>(
                  value:
                      controller.kategori.contains(controller.kategoriC.value)
                          ? controller.kategoriC.value
                          : null,
                  items: controller.kategori.map((kategori) {
                    return DropdownMenuItem<String>(
                      value: kategori,
                      child: Text(kategori,
                          style: PoppinsStyle.stylePoppins(
                            color: fontBlue,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          )),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    controller.kategoriC.value = newValue!;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: blue,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    hintStyle: PoppinsStyle.stylePoppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    hintText: 'Pilih Kategori',
                  ),
                );
              }),
              const SizedBox(height: 10),
              TextFormFieldWidget(
                  controller: controller.jumlahKamarC,
                  label: 'Jumlah Kamar',
                  isNumber: true),
              TextFormFieldWidget(
                  controller: controller.minHargaC,
                  label: 'Harga Terendah',
                  isNumber: true),
              TextFormFieldWidget(
                  controller: controller.maxHargaC,
                  label: 'Harga Tertinggi',
                  isNumber: true),
              Text(
                'Deskripsi',
                style: PoppinsStyle.stylePoppins(
                  color: fontBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: controller.deskripsiC,
                maxLines: 5,
                style: PoppinsStyle.stylePoppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                decoration: const InputDecoration(
                  fillColor: blue,
                  filled: true,
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(color: blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(color: blue),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Peraturan',
                style: PoppinsStyle.stylePoppins(
                  color: fontBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: controller.peraturanC,
                maxLines: 5,
                style: PoppinsStyle.stylePoppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                decoration: const InputDecoration(
                  fillColor: blue,
                  filled: true,
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(color: blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(color: blue),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormFieldWidget(
                  controller: controller.kontakC,
                  label: 'Kontak Pemilik',
                  isNumber: true),
              TextFormFieldWidget(
                  controller: controller.alamatC, label: 'Alamat'),
              TextFormFieldWidget(
                  controller: controller.linkGMapsC, label: 'Link Google Maps'),
              const SizedBox(height: 10),
              Text(
                'Pilih Lokasi Kos',
                style: PoppinsStyle.stylePoppins(
                  color: fontBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blue,
                      disabledBackgroundColor: blueLight,
                    ),
                    onPressed: () {
                      Get.toNamed(RouteName.mapPicker, arguments: {
                        'lat': controller.selectedLatLong.value?.latitude,
                        'long': controller.selectedLatLong.value?.longitude,
                      });
                    },
                    child: Text("Buka Peta",
                        style: PoppinsStyle.stylePoppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  const SizedBox(width: 10),
                  Obx(() => controller.selectedLatLong.value == null
                      ? const SizedBox.shrink()
                      : Text(
                          'Latitude: ${controller.selectedLatLong.value!.latitude.toStringAsFixed(6)}\nLongitude: ${controller.selectedLatLong.value!.longitude.toStringAsFixed(6)}',
                          style: PoppinsStyle.stylePoppins(
                            color: fontBlue,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Upload Gambar',
                style: PoppinsStyle.stylePoppins(
                  color: fontBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(
                        controller.remoteImageUrls.length,
                        (index) => Stack(
                          children: [
                            Image.network(
                              controller.remoteImageUrls[index],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: GestureDetector(
                                onTap: () => controller.removeImageFromFirebase(
                                    index, arguments['id']),
                                child: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(() {
                      return Text(
                        'Foto Terkini: ${controller.remoteImageUrls.length} / 10',
                        style: PoppinsStyle.stylePoppins(
                          color: fontBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                    Obx(() => Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(
                            controller.imageFiles.length,
                            (index) => Stack(
                              children: [
                                Image.file(
                                  File(controller.imageFiles[index].path),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: GestureDetector(
                                    onTap: () => controller.removeImage(index),
                                    child: const Icon(
                                      Icons.remove_circle,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                    const SizedBox(height: 20),
                    Obx(() {
                      return Text(
                        'Tambahan Foto: ${controller.imageFiles.length} / 10',
                        style: PoppinsStyle.stylePoppins(
                          color: fontBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                    Obx(() => controller.remoteImageUrls.length +
                                controller.imageFiles.length <
                            10
                        ? SizedBox(
                            width: 150,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: blue,
                                disabledBackgroundColor: blueLight,
                              ),
                              onPressed: () => controller.pickImageFromEdit(),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 30,
                                weight: 50,
                              ),
                            ),
                          )
                        : const SizedBox.shrink()),
                    Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 50,
                            width: 200,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: blue,
                                disabledBackgroundColor: blueLight,
                              ),
                              // onPressed: () => print(controller.kategoriC.value),
                              onPressed: () => controller.editKosan(arguments['pemilik'], arguments['id']),
                              child: Text('Edit Kos',
                                  style: PoppinsStyle.stylePoppins(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}


  // Future<Position> getCurrentPosition() async {
  //   // Pastikan permission telah diberikan
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     throw Exception('Location services are disabled.');
  //   }

  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       throw Exception('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     throw Exception('Location permissions are permanently denied.');
  //   }

  //   // Mendapatkan posisi saat ini
  //   return await Geolocator.getCurrentPosition( desiredAccuracy: LocationAccuracy.high);
  // }