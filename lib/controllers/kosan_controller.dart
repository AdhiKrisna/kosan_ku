import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kosan_ku/constants/constant_db_url.dart';
import 'package:kosan_ku/constants/constant_text_style.dart';
import 'package:kosan_ku/routes/route_name.dart';
import 'package:latlong2/latlong.dart';

class KosanController extends GetxController {
  final TextEditingController namaKostC = TextEditingController();
  final RxString kategoriC = ''.obs;
  final TextEditingController jumlahKamarC = TextEditingController();
  final TextEditingController minHargaC = TextEditingController();
  final TextEditingController maxHargaC = TextEditingController();
  final TextEditingController deskripsiC = TextEditingController();
  final TextEditingController peraturanC = TextEditingController();
  final TextEditingController kontakC = TextEditingController();
  final TextEditingController alamatC = TextEditingController();
  final TextEditingController linkGMapsC = TextEditingController();
  RxList<String> kategori = ['Putra', 'Putri', 'Campur', 'Pasutri'].obs;
  Rx<LatLng?> selectedLatLong = Rx<LatLng?>(null);
  final ImagePicker picker = ImagePicker();
  RxList<Map<String, dynamic>> kosanList = <Map<String, dynamic>>[].obs;
  final RxList<String> remoteImageUrls =  <String>[].obs; // Menyimpan URL gambar dari Firebase
  final RxList<XFile> imageFiles = <XFile>[].obs;

  @override
  void onInit() {
    remoteImageUrls.clear();
    super.onInit();
  }

Future<List<Map<String, dynamic>>> fetchAllKosan() async {
    try {
      Uri uri = Uri.parse('${rootRealTimeDB}Kosan.json');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        // Bersihkan data sebelumnya
        kosanList.clear();

        data.forEach((key, value) {
          kosanList.add({
            'id': key,
            ...value,
          });
        });
        // print('Kosan List: $kosanList');
        return kosanList;
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch data: ${response.statusCode}',
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
        );
        return [];
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch data: $e',
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
      );
      return [];
    }
  }

  // Method to pick an image
  Future<void> pickImage() async {
    try {
      final List<XFile>? pickedFiles = await picker.pickMultiImage();
      if (pickedFiles != null) {
        if (imageFiles.length + pickedFiles.length > 10) {
          Get.snackbar(
            'Limit Reached',
            'You can upload a maximum of 10 images.',
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          imageFiles.addAll(pickedFiles);
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick images: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void setLatLong(LatLng location) {
    selectedLatLong.value = location;
  }

  // Method to remove an image
  void removeImage(int index) {
    log('Removing image at index $index');
    try {
      imageFiles.removeAt(index);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to remove image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeImageFromFirebase(int index, String kosanId) async {
    try {
      if(remoteImageUrls.length == 1) {
        Get.snackbar(
          'Error',
          'You must have at least 1 image',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      Uri uri = Uri.parse('${rootRealTimeDB}Kosan/$kosanId.json');
      final String imageUrl = remoteImageUrls[index];
      log(imageUrl);
      String imagePath = Uri.decodeComponent(imageUrl.split('?')[0].split('o/')[1]);
      log('Decoded Image Path: $imagePath');
      String fileName = imagePath.split('/').last; // Extracting the file name (last part of the path)
      log('File Name: $fileName'); // This should be '1732530390574_Mbantul'
      // Show loading dialog
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );
      Reference ref = FirebaseStorage.instance.ref().child('data_kosan').child(kosanId).child(fileName);
      log('ini ref ${ref.fullPath}');
      await ref.delete();

      // Remove image URL from the list
      remoteImageUrls.removeAt(index);
      await http.patch(uri, body: json.encode({'images': remoteImageUrls}));

      // Hide loading dialog
      Get.back();

      // Show success message
      Get.snackbar(
        'Success',
        'Image removed successfully',
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      log(e.toString());
      
      Get.snackbar(
        'Error',
        'Failed to remove image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> pickImageFromEdit() async {
    try {
      final List<XFile>? pickedFiles = await picker.pickMultiImage();
      // imageFiles.clear();
      if (pickedFiles != null) {
        if (remoteImageUrls.length + pickedFiles.length > 10) {
          Get.snackbar(
            'Limit Reached',
            'You can upload a maximum of 10 images.',
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          imageFiles.addAll(pickedFiles);
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick images: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void addKosan(dynamic username) async {
    if (namaKostC.text.isEmpty ||
        jumlahKamarC.text.isEmpty ||
        minHargaC.text.isEmpty ||
        maxHargaC.text.isEmpty ||
        deskripsiC.text.isEmpty ||
        kontakC.text.isEmpty ||
        alamatC.text.isEmpty ||
        selectedLatLong.value == null ||
        peraturanC.text.isEmpty ||
        linkGMapsC.text.isEmpty ||
        kategoriC.value.isEmpty) {
      Get.snackbar(
        'Error',
        'All fields must be filled',
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
      );
      return;
    }
    if (imageFiles.isEmpty) {
      Get.snackbar(
        'Error',
        'Masukkan minimal 1 gambar',
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
      );
      return;
    }
    // print('lat: ${selectedLatLong.value!.latitude}');
    // print('long: ${selectedLatLong.value!.longitude}');
    try {
      // Tampilkan pop-up loading
      Get.dialog(
        Center(
          child: Container(
            color: Colors.white,
            height: 120,
            width: 250,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Sedang mengupload data kosan...',
                    style: PoppinsStyle.stylePoppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false, // Jangan biarkan pengguna menutup dialog
      );

      Uri uniqueKeyUri = Uri.parse('${rootRealTimeDB}Kosan.json');
      final uniqueKeyResponse =
          await http.post(uniqueKeyUri, body: json.encode({}));
      final uniqueKey = json.decode(uniqueKeyResponse.body)['name'];

      Reference ref =  FirebaseStorage.instance.ref().child('data_kosan').child(uniqueKey);

      List<String> imageUrls = [];

      // Upload gambar ke Firebase Storage
      for (XFile xfile in imageFiles) {
        File file = File(xfile.path);
        String uniqueFileName =
            '${DateTime.now().millisecondsSinceEpoch}_${namaKostC.text}';
        final snapshot = await ref.child(uniqueFileName).putFile(file);
        final downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

      // Simpan data kosan ke Firebase Realtime Database
      Uri uri = Uri.parse('${rootRealTimeDB}Kosan/$uniqueKey.json');
      await http.patch(uri,
          body: json.encode({
            'pemilik': username,
            'nama_kost': namaKostC.text,
            'jumlah_kamar': int.parse(jumlahKamarC.text),
            'min_harga': int.parse(minHargaC.text),
            'max_harga': int.parse(maxHargaC.text),
            'deskripsi': deskripsiC.text,
            'kontak': kontakC.text,
            'alamat': alamatC.text,
            'lat': selectedLatLong.value!.latitude,
            'long': selectedLatLong.value!.longitude,
            'images': imageUrls,
            'peraturan': peraturanC.text,
            'link_gmaps': linkGMapsC.text,
            'kategori': kategoriC.value,
          }));

      // Tutup pop-up loading
      Get.back();

      // Tampilkan notifikasi sukses
      Get.snackbar(
        'Success',
        'Kosan berhasil ditambahkan',
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
      );
      Get.offNamed(RouteName.detailKosan, arguments: {
        'username': username,
        'nama_kost': namaKostC.text,
        'jumlah_kamar': int.parse(jumlahKamarC.text),
        'min_harga': int.parse(minHargaC.text),
        'max_harga': int.parse(maxHargaC.text),
        'deskripsi': deskripsiC.text,
        'kontak': kontakC.text,
        'alamat': alamatC.text,
        'lat': selectedLatLong.value!.latitude,
        'long': selectedLatLong.value!.longitude,
        'images': imageUrls,
        'peraturan': peraturanC.text,
        'link_gmaps': linkGMapsC.text,
        'kategori': kategoriC.value,
      });
    } catch (e) {
      // Tutup pop-up loading jika ada error
      Get.back();
      Get.snackbar(
        'Error',
        'Failed to add kosan: $e',
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
      );
      return;
    }
  }

  void editKosan(dynamic username, String kosanId) async {
    if (namaKostC.text.isEmpty ||
        jumlahKamarC.text.isEmpty ||
        minHargaC.text.isEmpty ||
        maxHargaC.text.isEmpty ||
        deskripsiC.text.isEmpty ||
        kontakC.text.isEmpty ||
        alamatC.text.isEmpty ||
        selectedLatLong.value == null ||
        peraturanC.text.isEmpty ||
        linkGMapsC.text.isEmpty ||
        kategoriC.value.isEmpty) {
      Get.snackbar(
        'Error',
        'All fields must be filled',
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
      );
      return;
    }
    try {
      // Tampilkan pop-up loading
      Get.dialog(
        Center(
          child: Container(
            color: Colors.white,
            height: 120,
            width: 250,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Sedang mengupload data kosan...',
                    style: PoppinsStyle.stylePoppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false, // Jangan biarkan pengguna menutup dialog
      );

      Reference ref = FirebaseStorage.instance.ref().child('data_kosan').child(kosanId);

      if(imageFiles.isNotEmpty) {
        // Upload gambar ke Firebase Storage
        for (XFile xfile in imageFiles) {
          File file = File(xfile.path);
          String uniqueFileName =
              '${DateTime.now().millisecondsSinceEpoch}_${namaKostC.text}';
          final snapshot = await ref.child(uniqueFileName).putFile(file);
          final downloadUrl = await snapshot.ref.getDownloadURL();
          remoteImageUrls.add(downloadUrl);
        }
      } 
      // Simpan data kosan ke Firebase Realtime Database
      Uri uri = Uri.parse('${rootRealTimeDB}Kosan/$kosanId.json');
      await http.patch(uri,
          body: json.encode({
            'pemilik': username,
            'nama_kost': namaKostC.text,
            'jumlah_kamar': int.parse(jumlahKamarC.text),
            'min_harga': int.parse(minHargaC.text),
            'max_harga': int.parse(maxHargaC.text),
            'deskripsi': deskripsiC.text,
            'kontak': kontakC.text,
            'alamat': alamatC.text,
            'lat': selectedLatLong.value!.latitude,
            'long': selectedLatLong.value!.longitude,
            'images': remoteImageUrls,
            'peraturan': peraturanC.text,
            'link_gmaps': linkGMapsC.text,
            'kategori': kategoriC.value,
          }));

      // Tutup pop-up loading
      Get.back();
      // Tampilkan notifikasi sukses
      Get.snackbar(
        'Success',
        'Data kosan berhasil diupdate',
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
      );
      Get.offNamed(RouteName.detailKosan, arguments: {
        'username': username,
        'nama_kost': namaKostC.text,
        'jumlah_kamar': int.parse(jumlahKamarC.text),
        'min_harga': int.parse(minHargaC.text),
        'max_harga': int.parse(maxHargaC.text),
        'deskripsi': deskripsiC.text,
        'kontak': kontakC.text,
        'alamat': alamatC.text,
        'lat': selectedLatLong.value!.latitude,
        'long': selectedLatLong.value!.longitude,
        'images': remoteImageUrls,
        'peraturan': peraturanC.text,
        'link_gmaps': linkGMapsC.text,
        'kategori': kategoriC.value,
      });



    } catch (e) {
      // Tutup pop-up loading jika ada error
      Get.back();
      Get.snackbar(
        'Error',
        'Failed to edit kosan: $e',
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
      );
      return;
    }
  } 

  

  // Dispose resources if needed
  @override
  void onClose() {
    super.onClose();
    imageFiles.clear();
  }
}
