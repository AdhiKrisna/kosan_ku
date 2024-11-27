import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:kosan_ku/constants/constant_colors.dart';
import 'package:kosan_ku/constants/constant_text_style.dart';
import 'package:kosan_ku/controllers/kosan_controller.dart';
import 'package:kosan_ku/controllers/location_controller.dart';
import 'package:kosan_ku/routes/route_name.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

class MainMapPage extends StatelessWidget {
  const MainMapPage({super.key});
  @override
  Widget build(BuildContext context) {
    final KosanController kosanController = Get.put(KosanController());
    final locationController = Get.put(LocationController());

    kosanController.fetchAllKosan();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'KosanKu',
          style: PoppinsStyle.stylePoppins(
            color: fontBlue,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        // Loading indikator jika lokasi pengguna belum tersedia atau data kosan belum di-fetch
        if (kosanController.kosanList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // Daftar marker
        final markers = [
          // Marker untuk lokasi pengguna
          Marker(
            point: locationController.userLocation.value,
            width: 80,
            height: 80,
            rotate: true,
            child: Transform.rotate(
              angle: locationController.userHeading.value * (math.pi / 180), // Rotasi marker
              child: const Icon(
                Icons.navigation,
                size: 20,
                color: Colors.blue,
              ),
            ),
          ),
          // Marker untuk semua kosan
          ...kosanController.kosanList.map((kosan) {
            return Marker(
              point: LatLng(kosan['lat'], kosan['long']),
              width: 80,
              height: 80,
              child: IconButton(
                icon: const Icon(
                  Icons.home,
                  size: 25,
                  color: fontBlue,
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: NetworkImage(kosan['images'][0]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: Text(
                                kosan['nama_kost'],
                                style: PoppinsStyle.stylePoppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: fontBlue,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              kosan['alamat'],
                              style: PoppinsStyle.stylePoppins(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Kos ${kosan['kategori']}',
                              style: PoppinsStyle.stylePoppins(
                                  fontSize: 16, color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: blue,
                                  disabledBackgroundColor: blueLight,
                                ),
                                onPressed: () => Get.toNamed(
                                  RouteName.detailKosan,
                                  arguments: kosan,
                                ),
                                child: Text(
                                  'Detail',
                                  style: PoppinsStyle.stylePoppins(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }),
        ];

        // Tampilkan FlutterMap dengan markers
        return FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(-7.784400383966617, 110.4030054821096),
            initialZoom: 13.0,
            minZoom: 5.0,
            maxZoom: 20.0,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            ),
            MarkerLayer(markers: markers),
          ],
        );
      }),
    );
  }
}
