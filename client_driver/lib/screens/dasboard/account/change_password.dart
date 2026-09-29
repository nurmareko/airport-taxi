import 'package:client_driver/blocs/driver/changePassword/change_password_bloc.dart';
import 'package:client_driver/components/confirmation_bottom_sheet.dart';
import 'package:client_driver/components/error_message.dart';
import 'package:client_driver/components/loading.dart';
import 'package:client_driver/data/models/request/change_password_request_model.dart';
import 'package:client_driver/screens/dasboard/dasboard_template_screen.dart';
import 'package:client_driver/theme/colors.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _errorMessage;

  // text controller
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  // set error text

  String? validateOldPassword(String password) {
    if (password.isEmpty) {
      return 'Password lama harus diisi';
    } else {
      return null;
    }
  }

  String? validateNewPassword(String password) {
    if (password.isEmpty) {
      return 'Password harus diisi';
    } else if (password.length < 8) {
      return 'Password minimal 8 karakter';
    } else if (!RegExp(r'(?=.*[a-z])(?=.*\d)').hasMatch(password) ||
        !RegExp(r'(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(password)) {
      return 'Gunakan kombinasi huruf, angka, dan karakter khusus';
    } else {
      return null;
    }
  }

  String? validateConfirmNewPassword(
      String newPassword, String confirmNewPassword) {
    if (confirmNewPassword.isEmpty) {
      return 'Konfirmasi password harus diisi';
    } else if (confirmNewPassword != newPassword) {
      return 'Konfirmasi password tidak cocok';
    } else {
      return null;
    }
  }

  // Validasi apakah semua field sudah valid
  bool isFormValid() {
    return validateOldPassword(oldPasswordController.text) == null &&
        validateNewPassword(newPasswordController.text) == null &&
        validateConfirmNewPassword(confirmNewPasswordController.text,
                newPasswordController.text) ==
            null;
  }

  // widget loading
  Widget _buildLoadingModal(BuildContext context) {
    return const LoadingModal();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) async {
        if (state is ChangePasswordSuccess) {
          AnimatedSnackBar.removeAll();
          AnimatedSnackBar.material(
            'Password anda berhasil diperbarui!',
            type: AnimatedSnackBarType.success,
            mobileSnackBarPosition: MobileSnackBarPosition.bottom,
          ).show(context);

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const DasboardTemplate(initialPageIndex: 4),
            ),
          );
        } else if (state is ChangePasswordFailure) {
          _errorMessage = state.errorMessage;
        }
      },
      builder: (context, state) {
        return Stack(children: [
          Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.darkBackgroundBodyColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  CustomBottomSheet.displayConfirmationBottomSheet(
                    context,
                    'Yakin ingin meninggalkan halaman?',
                    'Perubahan yang kamu buat tidak akan tersimpan!',
                    'images/warning-sign.png',
                    () {
                      Navigator.of(context).pop();
                      Navigator.pop(context, true);
                    },
                  );
                },
              ),
              title: const Text("Ganti Password"),
              elevation: 0,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Masukkan password lama dan baru untuk mengganti pasword',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Image(
                      image: AssetImage('images/change_password.png'),
                      width: 100,
                      height: 100,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_errorMessage != null)
                    ErrorWidgets.buildErrorMessageWidget(
                      'error',
                      _errorMessage.toString(),
                      Icons.error,
                      const Color.fromARGB(255, 155, 120, 118),
                      Colors.red,
                      Colors.red,
                      Colors.red,
                    ),
                  const SizedBox(height: 20),
                  const Text('Password Lama',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Stack(
                    children: [
                      TextField(
                        controller: oldPasswordController,
                        style: Theme.of(context).textTheme.titleMedium,
                        keyboardType: TextInputType.text,
                        obscureText: !_isOldPasswordVisible,
                        onChanged: (text) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: "masukkan password",
                          hintStyle:
                              const TextStyle(fontSize: 15, color: Colors.grey),
                          contentPadding: const EdgeInsets.only(right: 40),
                          errorText:
                              validateOldPassword(oldPasswordController.text),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(
                            _isOldPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isOldPasswordVisible = !_isOldPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Password Baru',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Stack(
                    children: [
                      TextField(
                        controller: newPasswordController,
                        style: Theme.of(context).textTheme.titleMedium,
                        keyboardType: TextInputType.text,
                        obscureText: !_isNewPasswordVisible,
                        onChanged: (text) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: "masukkan password baru",
                          hintStyle:
                              const TextStyle(fontSize: 15, color: Colors.grey),
                          contentPadding: const EdgeInsets.only(right: 40),
                          errorText:
                              validateNewPassword(newPasswordController.text),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(
                            _isNewPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isNewPasswordVisible = !_isNewPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Konfirmasi Password Baru',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Stack(
                    children: [
                      TextField(
                        controller: confirmNewPasswordController,
                        style: Theme.of(context).textTheme.titleMedium,
                        keyboardType: TextInputType.text,
                        obscureText: !_isConfirmPasswordVisible,
                        onChanged: (text) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: "konfirmasi password baru",
                          hintStyle:
                              const TextStyle(fontSize: 15, color: Colors.grey),
                          contentPadding: const EdgeInsets.only(right: 40),
                          errorText: validateConfirmNewPassword(
                              newPasswordController.text,
                              confirmNewPasswordController.text),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              height: 100.h,
              color: AppColors.darkBackgroundBodyColor,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isFormValid()
                            ? () {
                                final requestModel = ChangePasswordRequestModel(
                                    oldPassword: oldPasswordController.text,
                                    newPassword: newPasswordController.text);

                                context.read<ChangePasswordBloc>().add(
                                      SubmitChangePasswordEvent(
                                          request: requestModel),
                                    );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.r),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 33, 156, 144),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (state is ChangePasswordLoading) _buildLoadingModal(context),
        ]);
      },
    );
  }
}
