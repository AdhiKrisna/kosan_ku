import 'package:get/get.dart';
import 'package:kosan_ku/pages/auth_pages/login_page.dart';
import 'package:kosan_ku/pages/auth_pages/register_page.dart';
import 'package:kosan_ku/pages/detail_kosan_page.dart';
import 'package:kosan_ku/pages/main_map_page.dart';
import 'package:kosan_ku/pages/pemilik/edit_kosan_page.dart';
import 'package:kosan_ku/pages/pemilik/list_kosan_page.dart';
import 'package:kosan_ku/pages/pemilik/map_page/map_picker_page.dart';
import 'package:kosan_ku/pages/pemilik/tambah_kosan_page.dart';
import 'package:kosan_ku/pages/home_page.dart';
import 'package:kosan_ku/pages/pemilik/main_page.dart';
import 'package:kosan_ku/pages/splash_screen.dart';
import 'package:kosan_ku/routes/route_name.dart';

class RoutePages{
  List<GetPage<dynamic>> routes = [
    GetPage(name: RouteName.splash, page: () => const SplashScreen()),
    GetPage(name: RouteName.home, page: () => const HomePage()),
    //pemilik
    GetPage(name: RouteName.register, page: () => RegisterPage()),
    GetPage(name: RouteName.login, page: () =>  LoginPage()),
    GetPage(name: RouteName.mainPage, page: () =>  const MainPage()),
    GetPage(name: RouteName.tambahKosan, page: () =>  TambahKosan()),
    GetPage(name: RouteName.editKosan, page: () =>  EditKosan()),
    GetPage(name: RouteName.listKosan, page: () =>  const ListKosanPage()),
    //user
    GetPage(name: RouteName.mainMapPage, page: () =>  const MainMapPage()),
    GetPage(name: RouteName.detailKosan, page: () =>  const DetailKosanPage()),
    GetPage(name: RouteName.mapPicker, page: () =>  const MapPickerPage()),

  ];
}