import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ibadahku/components/custom_button.dart';
import 'package:ibadahku/components/custom_checkbox.dart';
import 'package:ibadahku/constants/box_storage.dart';
import 'package:ibadahku/controllers/login_controller.dart';
import 'package:ibadahku/utils/utils.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();

  var loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    BoxStorage().get("email").then((value) {
      if (value != null) {
        loginController.emailController.text = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(IconsaxPlusLinear.close_circle),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Utils.kWhiteColor,
      body: ListView(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).padding.top + 14, horizontal: 14),
        children: [
          // Padding(
          //   padding: EdgeInsets.only(
          //     top: MediaQuery.of(context).padding.top + 14,
          //   ),
          //   child: Center(
          //     child: Image.asset(
          //       "assets/images/logo-stai.png",
          //       width: 120,
          //       height: 120,
          //     ),
          //   ),
          // ),
          const Text(
            "Welcome",
            style: TextStyle(
                color: Utils.kPrimaryColor,
                fontSize: 42,
                fontWeight: FontWeight.w900),
          ),
          const Text(
            "back!",
            style: TextStyle(
                color: Colors.black, fontSize: 40, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 20),
          const Text(
            "Sign in to access your feed and stay connected with your community through real-time updates.",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
          const SizedBox(height: 30),
          Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: loginController.emailController,
                  keyboardType: TextInputType.emailAddress,
                  focusNode: loginController.emailFocusNOde,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      IconsaxPlusLinear.sms,
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
                const SizedBox(height: 20),
                Obx(
                  () => TextFormField(
                    controller: loginController.passwordController,
                    obscureText: loginController.isHidePassword.value,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        IconsaxPlusLinear.lock,
                        color: Colors.black,
                        size: 20,
                      ),
                      hintText: "Input your password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22.0),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          loginController.isHidePassword.value
                              ? IconsaxPlusLinear.eye
                              : IconsaxPlusLinear.eye_slash,
                          color: Colors.grey,
                          size: 20,
                        ),
                        onPressed: () {
                          loginController.isHidePassword.value =
                              !loginController.isHidePassword.value;
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 8),
                        Obx(
                          () => CustomCheckbox(
                            checkColor: Utils.kPrimaryColor,
                            height: 24,
                            width: 24,
                            isChecked: loginController.isRemember.value,
                            color: Colors.grey.shade500,
                            iconSize: 20,
                            onChanged: (val) {
                              loginController.isRemember.value = val!;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Utils.kWhiteColor,
                          showDragHandle: true,
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width,
                            maxHeight: MediaQuery.of(context).size.height * 0.3,
                          ),
                          context: context,
                          builder: (context) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 20,
                            ),
                            child: Row(
                              spacing: 8,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: () {
                                      double percentage = 8.70123;
                                      var int = percentage.round();

                                      debugPrint(int.toString()); // 9

                                      try {
                                        launchUrl(Uri.parse(
                                            "https://ibadahku-web.vercel.app/users"));
                                      } catch (e, stackTrace) {
                                        debugPrint("Error: $e $stackTrace");
                                      }
                                    },
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        color: Utils.kWhiteColor,
                                        border: Border.all(
                                          color: Utils.kPrimaryColor,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(IconsaxPlusBold.sms,
                                              color: Utils.kPrimaryColor),
                                          Text(
                                            "Lupa Email?",
                                            style: TextStyle(
                                              color: Utils.kPrimaryColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: () async {
                                      // forgot password supabase
                                      if (loginController
                                          .emailController.text.isEmpty) {
                                        Get.back();

                                        ScaffoldMessenger.of(Get.context!)
                                          ..clearSnackBars()
                                          ..showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Please enter your email",
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              showCloseIcon: true,
                                            ),
                                          );

                                        loginController.emailFocusNOde
                                            .requestFocus();

                                        return;
                                      }
                                      loginController.isSendingEmail.value =
                                          true;

                                      // send message to whatsapp
                                      try {
                                        await launchUrl(Uri.parse(
                                            "https://api.whatsapp.com/send?phone=6283852137645&text=Halo%20saya%20lupa%20password%20akun%20saya%20${loginController.emailController.text}"));
                                      } catch (e, stackTrace) {
                                        debugPrint("Error: $e $stackTrace");
                                      }

                                      // await Supabase.instance.client.auth
                                      //     .resetPasswordForEmail(loginController
                                      //         .emailController.text)
                                      //     .then((value) {
                                      //   Get.back();
                                      //   ScaffoldMessenger.of(Get.context!)
                                      //     ..clearSnackBars()
                                      //     ..showSnackBar(
                                      //       const SnackBar(
                                      //         content: Text(
                                      //             "Check your email to reset password"),
                                      //         behavior:
                                      //             SnackBarBehavior.floating,
                                      //         showCloseIcon: true,
                                      //       ),
                                      //     );
                                      // }).onError((error, stackTrace) {
                                      //   log("Error: when reset password $error $stackTrace");
                                      //   Get.back();
                                      //   ScaffoldMessenger.of(Get.context!)
                                      //     ..clearSnackBars()
                                      //     ..showSnackBar(
                                      //       const SnackBar(
                                      //         content: Text(
                                      //             "Failed to reset password"),
                                      //         behavior:
                                      //             SnackBarBehavior.floating,
                                      //         showCloseIcon: true,
                                      //       ),
                                      //     );
                                      // });
                                      loginController.isSendingEmail.value =
                                          false;
                                    },
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        color: Utils.kPrimaryColor,
                                        border: Border.all(
                                            color: Utils.kWhiteColor),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Obx(
                                        () => Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            if (loginController
                                                .isSendingEmail.value)
                                              const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Utils.kWhiteColor,
                                                  semanticsLabel: 'Loading',
                                                ),
                                              )
                                            else
                                              const Icon(IconsaxPlusBold.lock,
                                                  color: Utils.kWhiteColor),
                                            const Text(
                                              "Lupa Password?",
                                              style: TextStyle(
                                                color: Utils.kWhiteColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Lupa Akun?",
                        style: TextStyle(color: Colors.blue, fontSize: 14),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 28),

                Obx(
                  () => CustomButton(
                    backgroundColor: Utils.kPrimaryColor,
                    textColor: Colors.white,
                    onTap: () {
                      if (loginController.isLoading.value) return;
                      if (formKey.currentState!.validate()) {
                        loginController.login();
                      }
                    },
                    isLoading: loginController.isLoading.value,
                    text: "Sign in",
                  ),
                ),
                const SizedBox(height: 12),
                // Obx(
                //   () => ElevatedButton(
                //     style: ButtonStyle(
                //       elevation: WidgetStateProperty.all(0),
                //       backgroundColor:
                //           WidgetStateProperty.all(Utils.kPrimaryColor),
                //       foregroundColor: WidgetStateProperty.all(Colors.white),
                //       shape: WidgetStateProperty.all(
                //         RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(12.0),
                //         ),
                //       ),
                //       minimumSize: WidgetStateProperty.all(
                //           const Size(double.infinity, 50)), // Custom height
                //     ),
                //     onPressed: () {
                //       if (loginController.isLoading.value) return;
                //       loginController.register();
                //     },
                //     child: loginController.isLoading.value
                //         ? const SizedBox(
                //             height: 20,
                //             width: 20,
                //             child: CircularProgressIndicator(
                //               color: Colors.white,
                //               semanticsLabel: 'Loading',
                //             ),
                //           )
                //         : const Text(
                //             "Sign up all",
                //             style: TextStyle(
                //               fontSize: 16,
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //   ),
                // ),
              ],
            ),
          ),
          // const SizedBox(height: 28),
          // const Row(
          //   children: [
          //     Expanded(child: Divider()),
          //     SizedBox(width: 12),
          //     Text("Or"),
          //     SizedBox(width: 12),
          //     Expanded(child: Divider())
          //   ],
          // ),
          // const SizedBox(height: 28),
          // ElevatedButton(
          //     style: ButtonStyle(
          //       elevation: WidgetStateProperty.all(0),
          //       backgroundColor: WidgetStateProperty.all(Colors.white),
          //       foregroundColor: WidgetStateProperty.all(Colors.black),
          //       shape: WidgetStateProperty.all(
          //         RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(12.0),
          //           side: const BorderSide(
          //             color: Colors.black,
          //             width: .8,
          //           ),
          //         ),
          //       ),
          //       minimumSize:
          //           WidgetStateProperty.all(const Size(double.infinity, 50)),
          //     ),
          //     onPressed: () {},
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Image.asset(
          //           "assets/images/google.png",
          //           width: 20,
          //         ),
          //         const SizedBox(width: 20),
          //         const Text(
          //           "Continue with Google",
          //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          //         ),
          //       ],
          //     )),
          // const SizedBox(height: 28),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     const Text(
          //       "Don't have an account?",
          //       style: TextStyle(color: Colors.black, fontSize: 14),
          //     ),
          //     const SizedBox(width: 8),
          //     InkWell(
          //       onTap: () {
          //         Get.toNamed(Routes.sign);
          //       },
          //       child: const Text(
          //         "Create an account",
          //         style: TextStyle(color: Colors.blue, fontSize: 14),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
