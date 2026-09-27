import 'dart:io';

import 'package:airport_taxi_sharing_driver_client/blocs/driver/getDriver/get_driver_bloc.dart';
import 'package:airport_taxi_sharing_driver_client/blocs/driver/updateDriver/update_driver_bloc.dart';
import 'package:airport_taxi_sharing_driver_client/components/confirmation_bottom_sheet.dart';
import 'package:airport_taxi_sharing_driver_client/components/loading.dart';
import 'package:airport_taxi_sharing_driver_client/components/loading_data_background.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/request/update_driver_request_model.dart';
import 'package:airport_taxi_sharing_driver_client/screens/dasboard/dasboard_template_screen.dart';
import 'package:airport_taxi_sharing_driver_client/theme/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  String? name;
  String? email;
  String? noMembership;
  String? licensePlate;
  String? phoneNumber;
  File? _image;
  String? photo;

  late final TextEditingController emailController;
  late final TextEditingController nameController;
  late final TextEditingController noMembershipController;
  late final TextEditingController licensePlateController;
  late final TextEditingController phoneNumberController;

  @override
  void initState() {
    super.initState();
    context.read<GetDriverBloc>().add(LoadGetDriver());
    emailController = TextEditingController(text: email);
    nameController = TextEditingController(text: name);
    noMembershipController = TextEditingController(text: noMembership);
    licensePlateController = TextEditingController(text: licensePlate);
    phoneNumberController = TextEditingController(text: phoneNumber);
  }

  //  Fungsi untuk memeriksa dan meminta izin akses camera
  Future<bool> _requestCameraPermission() async {
    if (await Permission.camera.request().isGranted) {
      return true;
    } else {
      return false;
    }
  }

// Fungsi untuk memeriksa dan meminta izin akses galeri
  Future<bool> _requestGalleryPermission() async {
    if (await Permission.storage.request().isGranted) {
      return true;
    } else {
      return false;
    }
  }

// Fungsi untuk mengambil foto dari kamera
  Future<void> _takePicture() async {
    bool cameraPermissionGranted = await _requestCameraPermission();
    if (!cameraPermissionGranted) {
      // Izin akses kamera tidak diberikan
      return;
    }

    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

// Fungsi untuk mengambil foto dari galeri
  Future<void> _pickImage() async {
    bool galleryPermissionGranted = await _requestGalleryPermission();
    if (!galleryPermissionGranted) {
      // Izin akses galeri tidak diberikan
      return;
    }

    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  // Fungsi untuk memilih pengambilan gambar

  void _showImagePickerOptions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ambil Foto dari Kamera'),
              onTap: () {
                Navigator.pop(context);
                _takePicture();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
            title: const Text("Edit Profil"),
            elevation: 0,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              _showImagePickerOptions();
                            },
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: 120,
                                  height: 120,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: _image != null
                                        ? Image.file(_image!, fit: BoxFit.cover)
                                        : CachedNetworkImage(
                                            imageUrl: photo ?? '',
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromARGB(255, 33, 156, 144),
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Informasi Profil',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 20),
                        BlocListener<GetDriverBloc, GetDriverState>(
                          listener: (context, state) {
                            if (state is GetDriverFailure) {
                              Navigator.pushReplacementNamed(
                                context,
                                '/onBoarding',
                              );
                            }
                            if (state is GetDriverLoaded) {
                              setState(() {
                                email = state.model.email;
                                name = state.model.name;
                                noMembership = state.model.noMembership;
                                licensePlate = state.model.licensePlate;
                                phoneNumber = state.model.phoneNumber;
                                emailController.text = email!;
                                nameController.text = name!;
                                noMembershipController.text = noMembership!;
                                licensePlateController.text = licensePlate!;
                                phoneNumberController.text = phoneNumber!;
                                photo = state.model.photo;
                              });
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.email,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Email ',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' *',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 209, 19, 5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(color: Colors.grey),
                                      readOnly: true,
                                      keyboardType: TextInputType.name,
                                      controller: emailController,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Nama ',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' *',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 209, 19, 5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                      keyboardType: TextInputType.name,
                                      controller: nameController,
                                      onChanged: (text) {
                                        setState(() {});
                                      },
                                      decoration: InputDecoration(
                                          errorText: validateName(
                                              nameController.text)),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Nomor Anggota ',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' *',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 209, 19, 5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                      keyboardType: TextInputType.text,
                                      controller: noMembershipController,
                                      onChanged: (text) {
                                        setState(() {});
                                      },
                                      decoration: InputDecoration(
                                          errorText: validateNoMembership(
                                              noMembershipController.text)),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Nomor Plat Kendaraan ',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' *',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 209, 19, 5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                      keyboardType: TextInputType.text,
                                      controller: licensePlateController,
                                      onChanged: (text) {
                                        setState(() {});
                                      },
                                      decoration: InputDecoration(
                                          errorText: validateLicensePlate(
                                              licensePlateController.text)),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.phone,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Nomor HP ',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' *',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 209, 19, 5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(3.0),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 244, 242, 242),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    width: 70,
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'images/indonesia.png',
                                          width: 20,
                                          height: 25,
                                        ),
                                        const SizedBox(width: 5),
                                        const Text(
                                          "+ 62",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                      keyboardType: TextInputType.number,
                                      controller: phoneNumberController,
                                      onChanged: (text) {
                                        setState(() {});
                                      },
                                      decoration: InputDecoration(
                                          errorText: validatePhoneNumber(
                                              phoneNumberController.text)),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                        BlocListener<UpdateDriverBloc, UpdateDriverState>(
                          listener: (context, state) {
                            if (state is UpdateDriverFailure) {
                              AnimatedSnackBar.removeAll();
                              AnimatedSnackBar.material(
                                'Data profil anda gagal diperbarui!',
                                type: AnimatedSnackBarType.error,
                                mobileSnackBarPosition:
                                    MobileSnackBarPosition.bottom,
                              ).show(context);
                            }
                            if (state is UpdateDriverSuccess) {
                              AnimatedSnackBar.removeAll();

                              AnimatedSnackBar.material(
                                'Data profil anda berhasil diperbarui!',
                                type: AnimatedSnackBarType.success,
                                mobileSnackBarPosition:
                                    MobileSnackBarPosition.bottom,
                              ).show(context);

                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const DasboardTemplate(
                                      initialPageIndex: 4),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            }
                          },
                          child: ElevatedButton(
                            onPressed: isFormValid()
                                ? () {
                                    final requestModel =
                                        UpdateDriverRequestModel(
                                            name: nameController.text,
                                            noMembership:
                                                noMembershipController.text,
                                            licensePlate:
                                                licensePlateController.text,
                                            phoneNumber:
                                                phoneNumberController.text,
                                            image: _image);

                                    context.read<UpdateDriverBloc>().add(
                                          SubmitUpdateDriverEvent(
                                              request: requestModel),
                                        );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 33, 156, 144),
                            ),
                            child: const Text(
                              'Simpan',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              BlocBuilder<GetDriverBloc, GetDriverState>(
                builder: (context, state) {
                  if (state is GetDriverLoading) {
                    return const LoadingModalDataBackground();
                  }
                  if (state is GetDriverFailure) {
                    return const Scaffold(
                      body: Center(
                        child: Text('Gagal memuat data'),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
        BlocBuilder<UpdateDriverBloc, UpdateDriverState>(
          builder: (context, state) {
            if (state is UpdateDriverLoading) {
              return const LoadingModal();
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }

  // Validasi apakah semua field sudah valid
  bool isFormValid() {
    return validateNoMembership(noMembershipController.text) == null &&
        validateLicensePlate(licensePlateController.text) == null &&
        validateName(nameController.text) == null &&
        validatePhoneNumber(phoneNumberController.text) == null;
  }

  // validate form field

  String? validateNoMembership(String name) {
    if (name.isEmpty) {
      return 'Nomor Keanggotaan harus diisi';
    } else {
      return null;
    }
  }

  String? validateLicensePlate(String name) {
    if (name.isEmpty) {
      return 'Nomor plat kendaraan harus diisi';
    } else {
      return null;
    }
  }

  String? validateName(String name) {
    if (name.isEmpty) {
      return 'Nama harus diisi';
    } else if (name.length < 3) {
      return 'Nama terlalu pendek';
    } else if (name.length > 15) {
      return 'Nama terlalu panjang';
    } else {
      return null;
    }
  }

  String? validatePhoneNumber(String phoneNumber) {
    // Menghapus karakter selain digit dari nomor telepon
    phoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    if (phoneNumber.isEmpty) {
      return 'Nomor HP harus diisi';
    } else if (!RegExp(r'^08[0-9]+$').hasMatch(phoneNumber) ||
        phoneNumber.length < 12 ||
        phoneNumber.length > 15) {
      return 'Format atau panjang nomor HP tidak valid';
    } else {
      return null;
    }
  }
}
