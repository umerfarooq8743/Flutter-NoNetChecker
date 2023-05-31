import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class imageui extends StatefulWidget {
  const imageui({super.key});

  @override
  State<imageui> createState() => _imageuiState();
}

class _imageuiState extends State<imageui> {
  StreamSubscription? streaconnectivitySubscription;
  ConnectivityResult? _previous;
  bool dialogshown = false;
  List<String> code = [
    'https://images.pexels.com/photos/169573/pexels-photo-169573.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    'https://images.pexels.com/photos/270348/pexels-photo-270348.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    'https://images.pexels.com/photos/943096/pexels-photo-943096.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  ];

  List<String> nature = [
    'https://images.pexels.com/photos/358457/pexels-photo-358457.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    'https://images.pexels.com/photos/235615/pexels-photo-235615.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    'https://images.pexels.com/photos/414144/pexels-photo-414144.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
  ];

  List<String> computer = [
    'https://images.pexels.com/photos/2115217/pexels-photo-2115217.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    'https://images.pexels.com/photos/204611/pexels-photo-204611.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    'https://images.pexels.com/photos/2800552/pexels-photo-2800552.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940 ',
  ];

  List<String> toshow = [
    'https://images.pexels.com/photos/2115217/pexels-photo-2115217.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    'https://images.pexels.com/photos/204611/pexels-photo-204611.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    'https://images.pexels.com/photos/2800552/pexels-photo-2800552.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940 ',
  ];
  Future<bool> check_internet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return Future.value(true);
      }
    } on SocketException catch (_) {
      return Future.value(false);
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    streaconnectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connresult) {
      if (connresult == ConnectivityResult.none) {
        dialogshown = true;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text(
              "Error",
            ),
            content: Text(
              "No Data Connection Available.",
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                },
                child: Text("Exit."),
              ),
            ],
          ),
        );
      } else if (_previous == ConnectivityResult.none) {
        check_internet().then((result) {
          if (result == true) {
            if (dialogshown == true) {
              dialogshown = false;
              Navigator.pop(context);
            }
          }
        });
      }
      _previous = connresult;
    });
  }

  @override
  void dispose() {
    super.dispose();
    streaconnectivitySubscription!.cancel();
  }

  Widget cards(String src) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.network(src),
        ],
      ),
    );
  }

  void createlist(String kword) {
    if (kword == "code") {
      toshow = [];
      setState(() {
        for (var srcs in code) {
          toshow.add(srcs);
        }
      });
    } else if (kword == "nature") {
      toshow = [];
      setState(() {
        for (var srcs in nature) {
          toshow.add(srcs);
        }
      });
    } else if (kword == "computer") {
      toshow = [];
      setState(() {
        for (var srcs in computer) {
          toshow.add(srcs);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "ImageViewer",
          style:
              TextStyle(color: Colors.red, fontSize: 24, fontFamily: "Satisfy"),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                    onPressed: () {
                      print("first button");
                      createlist("code");
                    },
                    child: Text(
                      "Code",
                      style: TextStyle(
                          fontSize: 18, color: Colors.red, fontFamily: "Alike"),
                    )),
              ),
              Expanded(
                child: TextButton(
                    onPressed: () {
                      print("first button");
                      createlist("nature");
                    },
                    child: Text(
                      "Nature",
                      style: TextStyle(
                          fontSize: 18, color: Colors.red, fontFamily: "Alike"),
                    )),
              ),
              Expanded(
                child: TextButton(
                    onPressed: () {
                      print("first button");
                      createlist("computer");
                    },
                    child: Text(
                      "Computers",
                      style: TextStyle(
                          fontSize: 18, color: Colors.red, fontFamily: "Alike"),
                    )),
              ),
            ],
          ),
          Column(
            children: [
              cards(toshow[0]),
              cards(toshow[1]),
              cards(toshow[2]),
            ],
          )
        ],
      )),
    );
  }
}
