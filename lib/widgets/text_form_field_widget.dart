import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kosan_ku/constants/constant_colors.dart';
import 'package:kosan_ku/constants/constant_text_style.dart';

class TextFormFieldWidget extends StatelessWidget {
  final LocalController localC = LocalController();
  final TextEditingController controller;
  final String label;
  final bool isNumber, isPassword;

  TextFormFieldWidget({
    required this.controller,
    required this.label,
    this.isNumber = false,
    this.isPassword = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: PoppinsStyle.stylePoppins(
            color: fontBlue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Obx(()=>
          TextFormField(
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            controller: controller,
            // obscureText: (isPassword && localC.isShowPassword.isFalse) ? true : false, //line code sakral (error)
            obscureText: (localC.isShowPassword.isFalse && isPassword) ? true : false,
            style: PoppinsStyle.stylePoppins(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              suffixIcon: isPassword
                ? IconButton(
                    onPressed: localC.togglePassword,
                    icon: Icon(
                      localC.isShowPassword.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    ),
                  ) : null,
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(color: blue),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(color: blue),
              ),
              fillColor: blue,
              filled: true,
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class LocalController extends GetxController {
  RxBool isShowPassword = false.obs;
  @override
  void onClose() {
    isShowPassword.close();
    super.onClose();
  }

  void togglePassword() {
    isShowPassword.value = !isShowPassword.value;
  }
}
