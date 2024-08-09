import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_ui_2/config/config.dart';
import 'package:flutter_ui_2/models/response/trip_get_res.dart';
import 'package:flutter_ui_2/pages/login.dart';
import 'package:flutter_ui_2/pages/profile.dart';
import 'package:flutter_ui_2/pages/trip.dart';
import 'package:http/http.dart' as http;

class ShowTropPage extends StatefulWidget {
  int idx = 0;
  ShowTropPage({super.key, required this.idx});

  @override
  State<ShowTropPage> createState() => _ShowTropPageState();
}

class _ShowTropPageState extends State<ShowTropPage> {
  List<TripGetResponse> trips = [];

//3. Use loadDataAsync()
  late Future<void> loadData;

  String url = '';
  @override
  void initState() {
    super.initState();
    // 4. Asssign loadData
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการทริป'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == 'profile') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(idx: widget.idx)));
              } else if (value == 'logout') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('ออกจากระบบ'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ปลายทาง'),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilledButton(
                      onPressed: () => gettrip(null),
                      child: const Text('ทั้งหมด')),
                  const SizedBox(width: 10),
                  FilledButton(
                      onPressed: () => gettrip('เอเชีย'),
                      child: const Text('เอเชีย')),
                  const SizedBox(width: 10),
                  FilledButton(
                      onPressed: () => gettrip('ยุโรป'),
                      child: const Text('ยุโรป')),
                  const SizedBox(width: 10),
                  FilledButton(
                      onPressed: () => gettrip('เอเชียตะวันออกเฉียงใต้'),
                      child: const Text('อาเซียน')),
                  const SizedBox(width: 10),
                  FilledButton(
                      onPressed: () => gettrip('ประเทศไทย'),
                      child: const Text('ประเทศไทย')),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            //  ทริปลิสต์
            Expanded(
              child: SingleChildScrollView(
                child:
                    //1.  Create FutureBuilder
                    FutureBuilder(
                        future: loadData,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Column(
                              children: trips.map((trip) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      trip.name,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 160,
                                          height: 160,
                                          child: Image.network(
                                            trip.coverimage,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Center(
                                                child: Text(
                                                  'cannot load image',
                                                  textAlign: TextAlign.center,
                                                ),
                                              );
                                            },
                                          ),
                                        ),

                                        // ignore: prefer_const_constructors
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                trip.country,
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                              Text(
                                                'ระยะเวลา ${trip.duration} วัน',
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                              Text(
                                                'ราคา ${trip.price} บาท',
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                              FilledButton(
                                                onPressed: () =>
                                                    goToTripPage(trip.idx),
                                                child: const Text(
                                                  'รายละเอียดเพิ่มเติม',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList());
                        }),
              ),
            ),
          ],
        ),
      ),
    );
  }

// 2. (async) Function for loading data from api
  Future<void> loadDataAsync() async {
    await Future.delayed(const Duration(seconds: 2));
    var value = await Configuration.getConfig();
    url = value['apiEndpoint'];
    //
    var data = await http.get(Uri.parse('$url/trips'));
    trips = tripGetResponseFromJson(data.body);

    //ลบทิ้งได้
    //  .then(
    //   (config) {
    //     url = config['apiEndpoint'];
    //     // log(config ['apiEndpoint']);
    //     // gettrip();
    //   },
    // ).catchError((err) {
    //   log(err.toString());
    // });
  }

  void gettrip(String? zone) {
    http.get(Uri.parse('$url/trips')).then(
      (value) {
        trips = tripGetResponseFromJson(value.body);
        List<TripGetResponse> filteredTrips = [];
        if (zone != null) {
          for (var trip in trips) {
            if (trip.destinationZone == zone) {
              filteredTrips.add(trip);
            }
          }
          trips = filteredTrips;
        }
        setState(() {});
      },
    ).catchError((eeeee) {
      log(eeeee.toString());
    });
  }

  goToTripPage(int idx) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TripPage(idx: idx)));
  }
}
