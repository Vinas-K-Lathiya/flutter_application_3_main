import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(useMaterial3: true),
    routes: {'/': (context) => Splash(), 'home': (context) => Home()},
    debugShowCheckedModeBanner: false,
  ));
}

String? link;
PullToRefreshController? pullToRefreshController;
List bookmark = [];

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(seconds: 3),
      () {
        Navigator.pushReplacementNamed(context, 'home');
      },
    );
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 500,
              width: 500,
              child: Image.network("https://i.gifer.com/XXM2.gif"),
            ),
          ],
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> scaffolfkey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffolfkey,
        appBar: AppBar(
          title: Center(child: Text("Home page")),
          actions: [
            PopupMenuButton<int>(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("google")],
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("adharcard")],
                  ),
                ),
                PopupMenuItem(
                  value: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("Adharcard Status")],
                  ),
                ),
                PopupMenuItem(
                  value: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("Pancard")],
                  ),
                ),
                PopupMenuItem(
                  value: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("bookmark")],
                  ),
                ),
              ],
              icon: Icon(Icons.menu),
              elevation: 2,
              onSelected: (value) {
                if (value == 1) {
                  link = "https://www.google.com/";
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home1(),
                      ));
                } else if (value == 2) {
                  link = "https://services.india.gov.in/";
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home1(),
                      ));
                } else if (value == 3) {
                  link = "https://cmhelpline.in/";
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home1(),
                      ));
                } else if (value == 4) {
                  link = "https://incometaxindia.gov.in/";
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home1(),
                      ));
                } else if (value == 5) {
                  scaffolfkey.currentState!.showBottomSheet(
                      backgroundColor: Colors.white70,
                      (context) => Container(
                            height: 500,
                            width: MediaQuery.of(context).size.width / 1,
                            child: Column(
                              children: bookmark
                                  .map((e) => Center(
                                        child: Container(
                                          width: double.infinity,
                                          height: 100,
                                          child: Row(
                                            children: [
                                              Text(e),
                                              IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      bookmark.remove(e);
                                                    });
                                                  },
                                                  icon: Icon(Icons.remove))
                                            ],
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ));
                }
              },
            ),
          ],
        ),
        body: StreamBuilder(
            stream: Connectivity().onConnectivityChanged,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return (snapshot.data == ConnectivityResult.mobile ||
                      snapshot.data == ConnectivityResult.wifi)
                  ? Center(
                      child: Text(
                          "go popup menu and select \n        what do you want"))
                  : Center(child: Text("turn on net"));
            }));
  }
}

class Home1 extends StatefulWidget {
  Home1({Key? key}) : super(key: key);

  @override
  State<Home1> createState() => _Home1State();
}

class _Home1State extends State<Home1> {
  InAppWebViewController? inAppWebViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          InAppWebView(
            pullToRefreshController: pullToRefreshController,
            onLoadStart: (controller, url) => setState(() {
              inAppWebViewController = controller;
            }),
            onLoadStop: (controller, url) async {
              await pullToRefreshController?.endRefreshing();
            },
            initialUrlRequest: URLRequest(url: Uri.parse("${link}")),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white70,
              height: 50,
              width: MediaQuery.of(context).size.width / 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () {
                        inAppWebViewController!.loadUrl(
                            urlRequest: URLRequest(url: Uri.parse("${link}")));
                      },
                      icon: Icon(Icons.home)),
                  IconButton(
                      onPressed: () {
                        inAppWebViewController!.goForward();
                      },
                      icon: Icon(Icons.forward)),
                  IconButton(
                      onPressed: () {
                        bookmark.add("${link}");
                      },
                      icon: Icon(Icons.bookmark)),
                  IconButton(
                      onPressed: () {
                        inAppWebViewController!.goBack();
                      },
                      icon: Icon(Icons.arrow_back_ios_new_sharp)),
                  IconButton(
                      onPressed: () {
                        inAppWebViewController!.reload();
                      },
                      icon: Icon(Icons.refresh)),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
