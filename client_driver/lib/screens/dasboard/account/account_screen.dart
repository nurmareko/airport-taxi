import 'package:airport_taxi_sharing_driver_client/blocs/driver/getDriver/get_driver_bloc.dart';
import 'package:airport_taxi_sharing_driver_client/blocs/driver/logout/logout_bloc.dart';
import 'package:airport_taxi_sharing_driver_client/components/confirmation_bottom_sheet.dart';
import 'package:airport_taxi_sharing_driver_client/components/loading_data_background.dart';
import 'package:airport_taxi_sharing_driver_client/screens/dasboard/account/change_password.dart';
import 'package:airport_taxi_sharing_driver_client/screens/dasboard/account/edit_account_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cached_network_image/cached_network_image.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    context.read<GetDriverBloc>().add(LoadGetDriver());
  }

  void _showFullScreenImage(BuildContext context, String photo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: CachedNetworkImage(
                imageUrl: photo,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutBloc, LogoutState>(
      listener: (context, state) {
        if (state is LogoutLoaded) {
          Navigator.pushReplacementNamed(context, '/onBoarding');
        } else if (state is LogoutFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Logout failed: ${state.errorMessage}'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is LogoutLoading) {
          setState(() {
            _loading = true;
          });
        } else {
          setState(() {
            _loading = false;
          });
        }
      },
      child: Stack(
        children: [
          BlocBuilder<GetDriverBloc, GetDriverState>(
            builder: (context, state) {
              return _buildContent(context, state);
            },
          ),
          if (_loading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, GetDriverState state) {
    if (state is GetDriverLoading) {
      return const LoadingModalDataBackground();
    } else if (state is GetDriverLoaded) {
      return _buildLoadedContent(state);
    } else if (state is GetDriverFailure) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, '/onBoarding');
      });
      return const Scaffold(
        body: Center(
          child: Text('Gagal memuat data'),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildLoadedContent(GetDriverLoaded state) {
    final String email = state.model.email;
    final String name = state.model.name;
    final String noMembership = state.model.noMembership;
    final String licensePlate = state.model.licensePlate;
    final String phoneNumber = state.model.phoneNumber;
    final String photo = state.model.photo;

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                width: 120,
                height: 120,
                child: GestureDetector(
                  onTap: () => _showFullScreenImage(context, photo),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: photo,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            const Text(
              'Informasi Profil',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),
            ProfileFields(
              title: 'Email',
              value: email,
              iconData: Icons.email,
            ),
            ProfileFields(
              title: 'Nama',
              value: name,
              iconData: Icons.person,
            ),
            ProfileFields(
              title: 'Nomor Anggota',
              value: noMembership,
              iconData: Icons.card_membership,
            ),
            ProfileFields(
              title: 'Nomor Plat Kendaraan',
              value: licensePlate,
              iconData: Icons.taxi_alert,
            ),

            ProfileFields(
              title: 'No HP (+62)',
              value: phoneNumber,
              iconData: Icons.phone,
            ),

            // Lainnya
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            const Text(
              'Lainnya',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfile()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: const Row(
                  children: [
                    Icon(Icons.settings_outlined, color: Colors.white),
                    SizedBox(width: 20),
                    Text(
                      'Edit Profil',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChangePassword()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: const Row(
                  children: [
                    Icon(Icons.password_outlined, color: Colors.white),
                    SizedBox(width: 20),
                    Text(
                      'Ganti Password',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                CustomBottomSheet.displayConfirmationBottomSheet(
                  context,
                  'Konfirmasi Logout',
                  'Apakah Anda yakin ingin keluar dari sesi Anda dan logout dari akun saat ini?',
                  'images/warning-sign.png',
                  () {
                    Navigator.of(context).pop();
                    context.read<LogoutBloc>().add(PressedLogoutEvent());
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: const Row(
                  children: [
                    Icon(Icons.logout_outlined, color: Colors.white),
                    SizedBox(width: 20),
                    Text(
                      'Logout',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Profile Fields Component
class ProfileFields extends StatelessWidget {
  const ProfileFields({
    super.key,
    required this.title,
    required this.value,
    required this.iconData,
  });

  final String title, value;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(
            iconData,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 15),
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
              softWrap: true,
            ),
          ),
          Expanded(
            flex: 8,
            child: Text(
              value,
              style: const TextStyle(fontSize: 15, color: Colors.grey),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
