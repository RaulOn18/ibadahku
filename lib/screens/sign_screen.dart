import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ibadahku/components/custom_drop_down_with_label.dart';
import 'package:ibadahku/constants/routes.dart';
import 'package:ibadahku/controllers/login_controller.dart';
import 'package:ibadahku/utils/utils.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignScreen extends StatefulWidget {
  const SignScreen({super.key});

  @override
  State<SignScreen> createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  final SupabaseClient client = Supabase.instance.client;
  var formKey = GlobalKey<FormState>();

  var loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
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
            "Assalmualaikum!",
            style: TextStyle(
                color: Utils.kPrimaryColor,
                fontSize: 32,
                fontWeight: FontWeight.w900),
          ),
          const Text(
            "Welcome to Ibadahku",
            style: TextStyle(
                color: Colors.black, fontSize: 28, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 20),
          const Text(
            "Tolong perhatikan semua inputan anda!. Semua inputan diatas harus diisi. pastikan semua inputan sudah benar.",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
          const SizedBox(height: 30),
          Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: loginController.nameController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      IconsaxPlusLinear.user,
                      color: Colors.black,
                      size: 20,
                    ),
                    hintText: "Masukan nama lengkap",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22.0),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: loginController.emailSignUpController,
                  keyboardType: TextInputType.emailAddress,
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
                    controller: loginController.passwordSignUpController,
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
                          loginController.isHidePassword.toggle();
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
                const SizedBox(height: 18),
                CustomDropDownWithLabel(
                  label: "Angkatan",
                  isShowLabel: false,
                  selectedValue: "",
                  items: const [],
                  onChanged: (v) {},
                ),
                const SizedBox(height: 22),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Row(
                //       children: [
                //         const SizedBox(width: 8),
                //         Obx(
                //           () => CustomCheckbox(
                //             checkColor: Utils.kPrimaryColor,
                //             height: 24,
                //             width: 24,
                //             isChecked: loginController.isRemember.value,
                //             color: Colors.grey.shade500,
                //             iconSize: 20,
                //             onChanged: (val) {
                //               loginController.isRemember.value = val!;
                //             },
                //           ),
                //         ),
                //         const SizedBox(width: 8),
                //       ],
                //     ),
                //     InkWell(
                //       onTap: () {
                //         ScaffoldMessenger.of(context)
                //           ..clearSnackBars()
                //           ..showSnackBar(
                //             const SnackBar(
                //               content: Text("Coming Soon"),
                //               behavior: SnackBarBehavior.floating,
                //               showCloseIcon: true,
                //             ),
                //           );
                //       },
                //       child: const Text(
                //         "Forgot Password",
                //         style: TextStyle(color: Colors.blue, fontSize: 14),
                //       ),
                //     )
                //   ],
                // ),
                Obx(
                  () => ElevatedButton(
                    style: ButtonStyle(
                      elevation: WidgetStateProperty.all(0),
                      backgroundColor:
                          WidgetStateProperty.all(Utils.kPrimaryColor),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      minimumSize: WidgetStateProperty.all(
                          const Size(double.infinity, 50)), // Custom height
                    ),
                    onPressed: () {
                      if (loginController.isSignUp.value) return;
                      if (formKey.currentState!.validate()) {
                        loginController.regsiter();
                      }
                    },
                    child: loginController.isSignUp.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              semanticsLabel: 'Loading',
                            ),
                          )
                        : const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                // const SizedBox(height: 12),
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
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Already have an account?",
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  Get.offAllNamed(Routes.login);
                },
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.blue, fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
