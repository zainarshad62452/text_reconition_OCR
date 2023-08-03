import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool isOcrRunning = false;
  String extractedTextToShow = "";

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade700,
      child: InkWell(
        onTap: () {
          _read();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white),
          ),
          height: 200,
          width: 400,
          child: Center(
            child: isOcrRunning
                ? ElevatedButton(
              onPressed: () {
                // Stop the OCR process when the button is pressed
                setState(() {
                  isOcrRunning = false;
                });
              },
              child: Text("Stop"),
            )
                : Column(
              children: [
                Text(
                  "Scan Using Camera",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  extractedTextToShow,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _read() async {
    // Start OCR only if it's not already running
    if (!isOcrRunning) {
      setState(() {
        isOcrRunning = true;
        extractedTextToShow = "";
      });

      List<OcrText> texts = [];

      try {
        texts = await FlutterMobileVision.read(
          multiple: true,
          camera: FlutterMobileVision.CAMERA_BACK,
          waitTap: false,
          preview: FlutterMobileVision.PREVIEW,
        );

        if (texts.isNotEmpty) {
          for(var text in texts){
            String expense = "";
            if(text.value.contains('L202')){
              bool value = false;
             for(var txt in text.value.characters){
               if(expense.characters.length<=17){
                 if(value){
                   expense+=txt;
                 }
                 if(txt == "L"){
                   expense+=txt;
                   value = true;
                 }

               }


             }
              print("////////////////////////////////////////////////\nExpense Application : $expense");
             print(text.value);
            }

          }
        }
      } on Exception {
        print('Failed to recognize text.');
      }

      setState(() {
        isOcrRunning = false;
      });
    }
  }
}
