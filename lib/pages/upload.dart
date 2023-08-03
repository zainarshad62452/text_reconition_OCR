import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  XFile? _imageFile;
  dynamic? _pickerror;
  String? extracted = 'Recognised Extracted Text Will Appear Here';
  final picker = ImagePicker();
  String userName = "Not Found";
  String expenseApplication = "Not Found";
  _imgFromGallery() async {
    try {
      final image = await picker.pickImage(source: ImageSource.gallery);
      EasyLoading.show(status: 'loading...');
      if (image != null) {
        String extractedText = await FlutterTesseractOcr.extractText(image.path,args: {
        });
        setState(() {
          _imageFile = image;
          print('///////////////////////////////////////');
          print(extractedText);
          extractValuesFromOCR(extractedText);
        });
      } else {
        setState(() {
          extracted = "Recognized extracted text will be shown here";
        });
      }
    } catch (e) {
      setState(() {
        _pickerror = e;
      });
    }
  }

  String extractValue(String text, String keyword) {
    int keywordStart = text.indexOf(keyword);
    if (keywordStart != -1) {
      int valueStart = keywordStart + keyword.length;
      int valueEnd = text.indexOf('\n', valueStart);
      if (valueEnd != -1) {
        return text.substring(valueStart, valueEnd).trim();
      }
    }
    return "Not Found";
  }

  void extractValuesFromOCR(String ocrResult) {
    expenseApplication = extractValue(ocrResult, "lexpenseviewAction.do? ");
    userName = extractValue(ocrResult, "User Name ");

    // Now you can use these extracted values as needed.
    setState(() {
      extracted ="Expense Application: $expenseApplication\n User Name: $userName";
    });
  }
  Widget preview() {
    if (_imageFile != null) {
      if (kIsWeb) {
        EasyLoading.dismiss();
        return Image.network(
          _imageFile!.path,
          fit: BoxFit.cover,
        );
      } else {
        EasyLoading.dismiss();
        return Semantics(
            child: Image.file(File(
              _imageFile!.path,
            )),
            label: 'image_picked_image');
      }
    } else if (_pickerror != null) {
      EasyLoading.dismiss();
      return Text(
        'Error: Select An Image (.PNG,.JPG,.JPEG,..) \nand Wait a Few Seconds',
        textAlign: TextAlign.center,
      );
    } else {
      EasyLoading.dismiss();
      return const Text(
        'You have not yet picked an image' +
            '\n' +
            'Upload an Image And Wait A few Seconds',
        textAlign: TextAlign.center,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "OCR App",
      color: Colors.grey.shade500,
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      home: Scaffold(
        appBar: AppBar(
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              "Extract text from image",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w300,
              ),
            ),
            backgroundColor: Colors.grey.shade100,
            iconTheme: IconThemeData(
              color: Colors.black,
            )),
        body: Material(
          child: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Container(
                        decoration: BoxDecoration(color: Colors.grey.shade100),
                        child: Center(child: preview()),
                        height: 250,
                        width: 650,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Hero(
                      tag: Key("upload"),
                      child: Card(
                        color: Colors.grey.shade700,
                        child: InkWell(
                          onTap: () {
                            _imgFromGallery();
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
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      color: Colors.grey.shade600,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          color: Colors.grey.shade500,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SelectableText(
                              extracted.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
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
