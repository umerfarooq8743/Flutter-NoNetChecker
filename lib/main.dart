import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nointernet/imageui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: homePagee(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class homePagee extends StatefulWidget {
  const homePagee({super.key});

  @override
  State<homePagee> createState() => _homePageeState();
}

class _homePageeState extends State<homePagee> {
  StreamSubscription? streamSubscription;
  ConnectivityResult? previous;
  @override
  void initState() {
    super.initState();
    try {
      InternetAddress.lookup("google.com").then((result) {
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => imageui()));
        } else {
          _showdailog();
        }
      }).catchError((error) {
        _showdailog();
      });
    } on SocketException catch (_) {
      _showdailog();
    }
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connresult) {
      if (connresult == ConnectivityResult.none) {
      } else if (previous == ConnectivityResult.none) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => imageui()));
      }
      previous = connresult;
    });
  }

  @override
  void dispose() {
    super.dispose();
    streamSubscription!.cancel();
  }

  void _showdailog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text("No Internet Detected"),
              actions: [
                TextButton(
                    onPressed: () {
                      SystemChannels.platform
                          .invokeMethod('Systemnavigator.pop');
                    },
                    child: Text("Exit"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text("Checking Your Internet Connection"),
            )
          ],
        ),
      ),
    );
  }
}
