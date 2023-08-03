import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ocr_app/utils/routes.dart';
import 'package:ocr_app/utils/scan.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "OCR App",
      color: Colors.grey.shade500,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0.2,
          title: Text(
            "OCR Application",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
          leading: Icon(
            Icons.home,
            color: Colors.black,
          ),
          backgroundColor: Colors.grey.shade100,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "A handy tool to extract text from images or using your camera",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w100,
                        wordSpacing: 2,
                        fontSize: 25,
                        fontStyle: FontStyle.italic),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(60.0),
                    child: Image.asset(
                      "assets/images/ocr_image.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text("Language : English"),
                  SizedBox(
                    height: 20,
                  ),
                  ScanPage(),
                  // SizedBox(
                  //   height: 50,
                  // ),
                  Hero(
                    tag: Key("upload"),
                    child: Card(
                      color: Colors.grey.shade700,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, MyRoutes.uploadpage);
                          setState(() {});
                        },
                        // hoverColor: Colors.orange,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white),
                          ),
                          height: 40,
                          width: 400,
                          child: Center(
                            child: Text(
                              "Upload Image",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
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
        bottomNavigationBar: Container(
          width: 500,
          height: 10,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }
}
