import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:kosan_ku/constants/constant_colors.dart';
import 'package:kosan_ku/constants/constant_text_style.dart';
import 'package:kosan_ku/controllers/kosan_controller.dart';
import 'package:kosan_ku/controllers/location_controller.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

class MapPickerPage extends StatelessWidget {
  const MapPickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final double? lat = arguments != null && arguments.containsKey('lat') ? arguments['lat'] : null;
    final double? long = arguments != null && arguments.containsKey('long') ? arguments['long'] : null;
    final Rx<LatLng> selectedPosition = const LatLng(-7.782025941031709, 110.41462355863953).obs;
    
    if (lat != null && long != null) {
      selectedPosition.value = LatLng(lat, long);
    }
    final locationController = Get.put(LocationController());
    final kosanController = Get.find<KosanController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Lokasi Kos"),
      ),
      body: Stack(
        children: [
          // Flutter Map
          Obx(
            () => FlutterMap(
              options: MapOptions(
                initialCenter: locationController.userLocation.value,
                onTap: (tapPosition, point) {
                  // Update lokasi marker jika peta diklik
                  selectedPosition.value = point;
                },
                initialZoom: 13.0,
                minZoom: 5.0,
                maxZoom: 20.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: selectedPosition.value,
                      width: 80,
                      height: 80,
                      child: const Icon(
                        Icons.home,
                        size: 25,
                        color: fontBlue,
                      ),
                    ),
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
                  ],
                ),
              ],
            ),
          ),
          // Tombol "Pilih Lokasi"
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: blue,
                  disabledBackgroundColor: blueLight,
                ),
                onPressed: () {
                  // Kirim lokasi yang dipilih ke callback
                  kosanController
                      .setLatLong(selectedPosition.value);
                  Get.back();
                },
                child: Text("Pilih Lokasi",
                    style: PoppinsStyle.stylePoppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
