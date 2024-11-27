import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kosan_ku/constants/constant_colors.dart';
import 'package:kosan_ku/constants/constant_text_style.dart';
import 'package:kosan_ku/controllers/auth_controller.dart';
import 'package:kosan_ku/routes/route_name.dart';
import 'package:kosan_ku/widgets/text_form_field_widget.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController passC = TextEditingController();
  final TextEditingController usernameC = TextEditingController();
  final authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
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
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: PoppinsStyle.stylePoppins(
                  color: fontBlue,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormFieldWidget(
                        controller: usernameC, label: 'Username'),
                    const SizedBox(height: 20),
                    TextFormFieldWidget(
                        controller: passC, label: 'Password', isPassword: true),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Belum punya akun? ",
                          style: PoppinsStyle.stylePoppins(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed(RouteName.register),
                          child: Text(
                            "Register",
                            style: PoppinsStyle.stylePoppins(
                              color: fontBlue,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        height: 50,
                        width: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: blue,
                            disabledBackgroundColor: blueLight,
                          ),
                          onPressed: () => authController.login(usernameC.text, passC.text),
                          child: Text('Login',
                              style: PoppinsStyle.stylePoppins(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              )),
                              
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
