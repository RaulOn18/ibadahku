import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibadahku/controllers/login_controller.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    var loginController = Get.put(LoginController());
    return Container(
      width: Get.width,
      height: Get.height,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: Get.height * 0.18),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Forgot Password?",
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Please fill the information below.",
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: loginController.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  IconsaxPlusBroken.sms,
                  color: Colors.black,
                  size: 20,
                ),
                hintText: "Input your email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.0),
                  borderSide: const BorderSide(
                    color: Colors.black,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
