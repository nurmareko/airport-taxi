import 'package:flutter/material.dart';

class CustomBottomSheet {
  static Future displayUnverifiedErrorBottomSheet(
    BuildContext context,
    String imagePath,
    VoidCallback onVerifPressed,
    String email,
  ) {
    bool isVerifying = false;

    return showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext innerContext, StateSetter setState) {
          FocusScope.of(innerContext).requestFocus(FocusNode());

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SizedBox(
              height: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Email terdaftar',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    email,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 33, 156, 144),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    imagePath,
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 10),
                  Text(
                    'Akun dengan email ini sudah terdaftar, namun belum diverifikasi',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w300, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isVerifying
                              ? null
                              : () {
                                  Navigator.pop(innerContext, true);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Tidak',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isVerifying
                              ? null
                              : () async {
                                  setState(() {
                                    isVerifying = true;
                                  });

                                  // Call the verification function
                                  onVerifPressed();

                                  Future.delayed(const Duration(seconds: 5),
                                      () {
                                    Navigator.pop(context, true);
                                  });
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 33, 156, 144),
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: isVerifying
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text('Verifikasi',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
