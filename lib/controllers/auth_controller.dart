import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kosan_ku/constants/constant_db_url.dart';
import 'package:kosan_ku/routes/route_name.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  
  var dataUsers = {}.obs;
  Future takeDataUsers() {
    Uri uri = Uri.parse('${rootRealTimeDB}Users.json');
    return http.get(uri).then((response) {
      dataUsers.value = json.decode(response.body) as Map<String, dynamic>;
    }).catchError((error) {
      log('error: $error');
    });
  }

  void login(String username, String password) {
    takeDataUsers().then((value) {
      if (dataUsers.isNotEmpty) {
        bool isMatch = false;
        dataUsers.forEach((key, value) {
          if (value['username'] == username && value['password'] == password) {
            isMatch = true;
            Get.snackbar(
              'Login berhasil',
              'Selamat datang $username',
              backgroundColor: Colors.green,
              snackPosition: SnackPosition.BOTTOM,
              colorText: Colors.white,
            );
            Get.offAllNamed(RouteName.mainPage, arguments: username);
            return;
          }
        });
        if (!isMatch) {
          Get.snackbar(
            'Error',
            'Username atau password salah',
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
          );
          return;
        }
      } else {
        Get.snackbar(
          'Error',
          'Username atau password salah',
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
        );
        return;
      }
    });
  }

  void register(String username, String password, String confirmPassword) async {
    if (password != confirmPassword) {
      Get.snackbar(
        'Error',
        'Password tidak sama',
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
      );
      return;
    }
    await takeDataUsers().then((value) {
      if (dataUsers.isNotEmpty) {
        dataUsers.forEach((key, value) {
          if (value['username'] == username) {
            Get.snackbar(
              'Error',
              'Username sudah terdaftar',
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.BOTTOM,
              colorText: Colors.white,
            );
            return;
          }
          Uri uri = Uri.parse('${rootRealTimeDB}Users.json');
          http
              .post(uri,
                  body: json.encode({
                    'username': username,
                    'password': password,
                  }))
              .then((response) {
            log('response: ${response.body}');
          }).catchError((error) {
            log('error: $error');
          }).whenComplete(() {
            Get.snackbar(
              'Register berhasil',
              'Silahkan login dengan username dan password yang sudah didaftarkan',
              backgroundColor: Colors.green,
              snackPosition: SnackPosition.BOTTOM,
              colorText: Colors.white,
            );
            Get.offNamed(RouteName.login);
          });
        });
      } else {
        Uri uri = Uri.parse('${rootRealTimeDB}Users.json');
        http
            .post(uri,
                body: json.encode({
                  'username': username,
                  'password': password,
                }))
            .then((response) {
          log('response: ${response.body}');
        }).catchError((error) {
          log('error: $error');
        }).whenComplete(() {
          Get.snackbar(
            'Register berhasil',
            'Silahkan login dengan username dan password yang sudah didaftarkan',
            backgroundColor: Colors.green,
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
          );
          Get.offNamed(RouteName.login);
        });
      }
    });
  }
}
