// import 'package:airport_taxi_sharing_user_client/components/auth/app_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dart:async';

// class VerifikasiOTP extends StatefulWidget {
//   const VerifikasiOTP({Key? key}) : super(key: key);

//   @override
//   State<VerifikasiOTP> createState() => _VerifikasiOTPState();
// }

// class _VerifikasiOTPState extends State<VerifikasiOTP> {
//   final _numberField = TextEditingController();
//   int timeLeft = 60; 
//   bool timerVisible = true;

//   void clearNumberField() {
//     _numberField.clear();
//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();

//     // Memulai hitung mundur saat halaman dimuat
//     startCountdown();
//   }

//   void startCountdown() {
//     const oneSec = Duration(seconds: 1);
//     Timer.periodic(oneSec, (Timer timer) {
//       setState(() {
//         if (timeLeft == 0) {
//           timer.cancel();
//           timerVisible = false; // Sembunyikan timer
//         } else {
//           timeLeft--;
//         }
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     int minutes = timeLeft ~/ 60;
//     int seconds = timeLeft % 60;

//     String formattedTime = '$minutes:${seconds < 10 ? '0' : ''}$seconds';

//     return Scaffold(
//       appBar: const AuthAppBar(),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Cek kode melalui SMS',
//               style: TextStyle(fontFamily: 'Roboto', fontSize: 20),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               'Kode OTP telah dikirimkan ke nomor 0895338170582, silahkan masukkan kode untuk verifikasi.',
//               style: TextStyle(fontFamily: 'Roboto-Reguler', fontSize: 16),
//             ),
//             const SizedBox(height: 10),
//              const Center(
//               child: Image(
//                 image: AssetImage('images/password.png'), 
//                 width: 100,
//                 height: 100,
//               ),
//             ),
//             const SizedBox(height: 30),
//             Form(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   SizedBox(
//                     height: 40,
//                     width: 40,
//                     child: TextFormField(
//                       onChanged: (value) {
//                         if (value.length == 1) {
//                           FocusScope.of(context).nextFocus();
//                         }
//                       },
//                       onSaved: (pin1) {},
//                       style: Theme.of(context).textTheme.headlineMedium,
//                       keyboardType: TextInputType.number,
//                       textAlign: TextAlign.center,
//                       inputFormatters: [
//                         LengthLimitingTextInputFormatter(1),
//                         FilteringTextInputFormatter.digitsOnly
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 40,
//                     width: 40,
//                     child: TextFormField(
//                       onChanged: (value) {
//                         if (value.length == 1) {
//                           FocusScope.of(context).nextFocus();
//                         }
//                       },
//                       onSaved: (pin2) {},
//                       style: Theme.of(context).textTheme.headlineMedium,
//                       keyboardType: TextInputType.number,
//                       textAlign: TextAlign.center,
//                       inputFormatters: [
//                         LengthLimitingTextInputFormatter(1),
//                         FilteringTextInputFormatter.digitsOnly
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 40,
//                     width: 40,
//                     child: TextFormField(
//                       onChanged: (value) {
//                         if (value.length == 1) {
//                           FocusScope.of(context).nextFocus();
//                         }
//                       },
//                       onSaved: (pin3) {},
//                       style: Theme.of(context).textTheme.headlineMedium,
//                       keyboardType: TextInputType.number,
//                       textAlign: TextAlign.center,
//                       inputFormatters: [
//                         LengthLimitingTextInputFormatter(1),
//                         FilteringTextInputFormatter.digitsOnly
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 40,
//                     width: 40,
//                     child: TextFormField(
//                       onChanged: (value) {
//                         if (value.length == 1) {
//                           FocusScope.of(context).nextFocus();
//                         }
//                       },
//                       onSaved: (pin4) {},
//                       style: Theme.of(context).textTheme.headlineMedium,
//                       keyboardType: TextInputType.number,
//                       textAlign: TextAlign.center,
//                       inputFormatters: [
//                         LengthLimitingTextInputFormatter(1),
//                         FilteringTextInputFormatter.digitsOnly
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             // Tampilkan hitung mundur di sini di tengah
//             const SizedBox(height: 20),
//             Center(
//               child: Visibility(
//                 visible: timerVisible,
//                 child: Text(
//                   formattedTime,
//                   style: const TextStyle(fontSize: 16, fontFamily: 'Roboto-Reguler'),
//                 ),
//               ),
//             ),
//             Center(
//               child: Visibility(
//                 visible: !timerVisible,
//                 child: TextButton(
//                   onPressed: () {
//                     // Tambahkan aksi untuk mengirim ulang kode di sini
//                     // Anda dapat memulai hitung mundur lagi jika diperlukan
//                     setState(() {
//                       timeLeft = 60; // Atur ulang timer ke 60 detik
//                       timerVisible = true; // Tampilkan timer
//                       startCountdown(); // Memulai hitung mundur lagi
//                     });
//                   },
//                   child: const Text(
//                     'Kirim ulang kode?',
//                     style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 33, 156, 144)),
//                   ),
//                 ),
//               ),
//             ),

//             const Spacer(),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // Tambahkan aksi yang sesuai di sini
//                     },
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(25.0),
//                       ),
//                       backgroundColor: const Color.fromARGB(255, 33, 156, 144)  ,
//                     ),
//                     child: const Padding(
//                       padding: EdgeInsets.all(15.0),
//                       child: Text('SELANJUTNYA'),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
