import 'package:client_driver/blocs/orderan/getHistoryOrderan/get_history_orderan_bloc.dart';
import 'package:client_driver/blocs/orderan/sendReport/send_report_bloc.dart';
import 'package:client_driver/components/dasboard/loading.dart';
import 'package:client_driver/components/loading_data_background.dart';
import 'package:client_driver/data/models/request/send_report_request_model.dart';
import 'package:client_driver/screens/dasboard/dasboard_template_screen.dart';
import 'package:client_driver/screens/dasboard/errorScreen/error_screen.dart';
import 'package:client_driver/screens/dasboard/orderan/no_history_orderan_screen..dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class HistoryOrderan extends StatefulWidget {
  const HistoryOrderan({super.key});

  @override
  State<HistoryOrderan> createState() => _HistoryOrderanState();
}

class _HistoryOrderanState extends State<HistoryOrderan> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    context.read<GetHistoryOrderanBloc>().add(LoadGetHistoryOrderanEvent());
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  void _showCustomerReview(BuildContext context, String customerReview) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      backgroundColor: const Color(0xFF1E282C),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Customer Review',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15.0),
              Text(
                '"$customerReview"',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRideDetailsModal(
      BuildContext context,
      orderId,
      orderCustomerName,
      orderLat,
      orderLong,
      orderStatus,
      customerToAirportDistance,
      farePerKm,
      cost,
      createDateTime,
      updateDateTime) async {
    String statusText;
    switch (orderStatus) {
      case 4:
        statusText = 'Selesai';
        break;
      case 5:
        statusText = 'Dibatalkan oleh customer';
        break;
      case 6:
        statusText = 'Dibatalkan oleh driver';
        break;
      case 7:
        statusText = 'Ditolak oleh driver';
        break;
      default:
        statusText = 'Status tidak diketahui';
    }

    // Mengonversi lat dan long menjadi nama lokasi
    String locationName = 'Loading...';
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(orderLat, orderLong);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        locationName =
            '${place.name}, ${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}, ${place.postalCode}, ${place.subAdministrativeArea}';
      } else {
        locationName = 'Tidak dapat menemukan lokasi';
      }
    } catch (e) {
      locationName = 'Error: $e';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: const Color(0xFF1E282C),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Detail Informasi Riwayat Pesanan #$orderId',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(
                          Icons.place,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            'Lokasi Penjemputan \n$locationName',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 6,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Nama Customer \n$orderCustomerName',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.airport_shuttle,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Jarak Customer ke Bandara \n${(customerToAirportDistance / 1000).toStringAsFixed(1).replaceAll('.', ',')} Km',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.attach_money,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Tarif Per Km \n$farePerKm,00',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.attach_money,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Estimasi Biaya \n$cost,00',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Dibuat Pada \n$createDateTime',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.update,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Terakhir Diperbarui \n$updateDateTime',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.info,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Status Pesanan \n$statusText',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.grey,
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showReportModal(BuildContext context, id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String message = '';
        return AlertDialog(
          backgroundColor: const Color(0xFF1E282C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Kirim Pesan Pengaduan',
            style: TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            height: 160,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    'Pesan pengaduan Anda akan dikirimkan ke Admin.',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    onChanged: (value) {
                      message = value;
                    },
                    style: const TextStyle(color: Colors.white),
                    maxLines: 10,
                    decoration: const InputDecoration(
                      hintText: "Tulis pesan Anda di sini...",
                      hintStyle: TextStyle(color: Colors.white54),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Batal', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Kirim', style: TextStyle(color: Colors.white)),
              onPressed: () {
                if (message.trim().isEmpty) {
                  AnimatedSnackBar.removeAll();
                  AnimatedSnackBar.material(
                    'Pesan tidak boleh kosong!',
                    type: AnimatedSnackBarType.error,
                    mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                  ).show(context);
                } else {
                  _sendReport(id, message);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _sendReport(String orderId, String message) {
    final requestModelReport =
        SendReportRequestModel(orderId: orderId, message: message);

    context.read<SendReportBloc>().add(
          LoadSendReportEvent(request: requestModelReport),
        );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Stack(
          children: [
            BlocBuilder<GetHistoryOrderanBloc, GetHistoryOrderanState>(
              builder: (context, state) {
                if (state is GetHistoryOrderanLoading) {
                  return const LoadingModalDataBackground();
                } else if (state is GetHistoryOrderanLoaded) {
                  final orders = state.model.data;
                  if (orders.isEmpty) {
                    return const NoHistoryOrderan();
                  }
                  AnimatedSnackBar.removeAll();
                  AnimatedSnackBar.material(
                    'Refresh untuk mendapatkan data terbaru',
                    type: AnimatedSnackBarType.info,
                    mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                  ).show(context);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              'Riwayat Pesanan Customer menuju Bandara',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              height: 2,
                              color: const Color(0xFF1E272E),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return InkWell(
                            onTap: () {
                              _showRideDetailsModal(
                                context,
                                order.id,
                                order.customer.name,
                                order.lat,
                                order.long,
                                order.status,
                                order.customerToAirportDistance,
                                order.farePerKm,
                                order.cost,
                                order.createDatetime,
                                order.updateDatetime,
                              );
                            },
                            child: Card(
                              color: const Color(0xFF1E282C),
                              margin: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 20,
                                      height: 20,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8.0),
                                          bottomRight: Radius.circular(8.0),
                                        ),
                                        color:
                                            Color.fromARGB(255, 33, 156, 144),
                                      ),
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 50.0,
                                              height: 50.0,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                image: const DecorationImage(
                                                  image: AssetImage(
                                                      'images/taxi_11.png'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 15.0),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Pesanan customer menuju bandara  #${order.id}',
                                                    style: const TextStyle(
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 15.0),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.info_outline,
                                                        color: Colors.white,
                                                        size: 16.0,
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        getStatusText(
                                                            order.status),
                                                        style: TextStyle(
                                                          color: getStatusColor(
                                                              order.status),
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10.0),
                                                  if (order.review
                                                          ?.customerRating ==
                                                      0) ...[
                                                    const SizedBox(
                                                        height: 15.0),
                                                    const Text(
                                                      "Tidak ada rating \ndan review",
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                  if (order.review
                                                          ?.customerRating !=
                                                      0) ...[
                                                    Row(
                                                      children: [
                                                        RatingBarIndicator(
                                                          rating: order.review
                                                                  ?.customerRating
                                                                  .toDouble() ??
                                                              0.0,
                                                          itemBuilder: (context,
                                                                  index) =>
                                                              const Icon(
                                                            Icons.star,
                                                            color:
                                                                Colors.yellow,
                                                          ),
                                                          itemCount: 5,
                                                          itemSize: 18.0,
                                                          direction:
                                                              Axis.horizontal,
                                                        ),
                                                        if (order
                                                                .review
                                                                ?.customerReview
                                                                .isNotEmpty ??
                                                            false)
                                                          IconButton(
                                                            icon: const Icon(
                                                              Icons.comment,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            onPressed: () {
                                                              _showCustomerReview(
                                                                  context,
                                                                  order.review!
                                                                      .customerReview);
                                                            },
                                                          ),
                                                      ],
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                            BlocListener<SendReportBloc,
                                                SendReportState>(
                                              listener: (context, state) {
                                                if (state
                                                    is SendReportFailure) {
                                                  if (state.errorMessage ==
                                                      "Unauthorized") {
                                                    SchedulerBinding.instance
                                                        .addPostFrameCallback(
                                                            (_) {
                                                      Get.toNamed(
                                                          '/onBoarding');
                                                    });
                                                  }
                                                  AnimatedSnackBar.removeAll();
                                                  AnimatedSnackBar.material(
                                                    'Pesan pengaduan gagal dikirimkan!',
                                                    type: AnimatedSnackBarType
                                                        .error,
                                                    mobileSnackBarPosition:
                                                        MobileSnackBarPosition
                                                            .bottom,
                                                  ).show(context);
                                                }
                                                if (state
                                                    is SendReportSuccess) {
                                                  AnimatedSnackBar.removeAll();
                                                  AnimatedSnackBar.material(
                                                    'Pesan pengaduan berhasil dikirimkan!',
                                                    type: AnimatedSnackBarType
                                                        .success,
                                                    mobileSnackBarPosition:
                                                        MobileSnackBarPosition
                                                            .bottom,
                                                  ).show(context);
                                                }
                                              },
                                              child: IconButton(
                                                  icon: const Icon(
                                                      Icons.report_problem,
                                                      color: Colors.red),
                                                  onPressed: () {
                                                    _showReportModal(
                                                        context, order.id);
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    right: 16,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        order.createDatetime,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                } else if (state is GetHistoryOrderanFailure) {
                  if (state.errorMessage == "Unauthorized") {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Get.toNamed('/onBoarding');
                    });
                  }
                  return SomethingError(
                    onNavigate: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) =>
                              const DasboardTemplate(initialPageIndex: 3),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text('Memuat Data...'),
                  );
                }
              },
            ),
            BlocBuilder<SendReportBloc, SendReportState>(
              builder: (context, state) {
                if (state is SendReportLoading) {
                  return const LoadingModal();
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

String getStatusText(int status) {
  switch (status) {
    case 4:
      return 'Selesai';
    case 5:
      return 'Dibatalkan oleh customer';
    case 6:
      return 'Dibatalkan oleh driver';
    case 7:
      return 'Ditolak oleh driver';
    default:
      return 'Status tidak diketahui';
  }
}

Color getStatusColor(int status) {
  switch (status) {
    case 4:
      return Colors.green;
    case 5:
    case 6:
    case 7:
      return Colors.red;
    default:
      return Colors.white;
  }
}
