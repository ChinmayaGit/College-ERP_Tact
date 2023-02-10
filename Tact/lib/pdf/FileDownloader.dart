import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tact/pdf/pdfPage.dart';
import 'package:file_picker/file_picker.dart';



class FileDownloader extends StatefulWidget {
  final String link;
  final String name;
  final String sub;
  final String sem;
  FileDownloader(this.link, this.name, this.sub, this.sem);

  @override
  _FileDownloaderState createState() => _FileDownloaderState();
}

class _FileDownloaderState extends State<FileDownloader> {
  bool downloading = false;
  var progress = "";
  var path = "No Data";
  var platformVersion = "Unknown";
  // final Permission permission;
  PermissionStatus _permissionStatus = PermissionStatus.denied;

  var _onPressed;
  static final Random random = Random();
  late Directory externalDir;
  bool _isLoading = true;
  late File filesss;

  // _FileDownloaderState(this.permission);

  @override
  void initState() {
    super.initState();
    downloadFile();
  }
  var _openResult = 'Unknown';


  Future downloadFile() async {
    Dio dio = Dio();
    String dirloc = "";
    dirloc = "storage/emulated/0/)TACT(/${widget.sem}/${widget.sub}/";
    path = dirloc + widget.name.toString();
    File file = new File.fromUri(Uri.parse(path));
    // if (Platform.isAndroid) {
    //   dirloc = "storage/emulated/0/)TACT(/";
    // } else {
    //   dirloc = (await getApplicationDocumentsDirectory()).path;
    // }
    print(path);
    if(await File(path).exists()){
      Navigator.pop(context);
      OpenFile.open(path);
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (_) =>
      //
      //     PdfPage(path:path,name:widget.name.toString(),assets: "null",assetsValue: false,))
      //
      // );
    }else{
      try {
        FileUtils.mkdir([dirloc]);
        await dio.download(widget.link, dirloc + widget.name.toString(),
            onReceiveProgress: (receivedBytes, totalBytes) {
              setState(() {
                downloading = true;
                progress =
                    ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + "%";
              });
            }).then((value) {


          Navigator.pop(context);
          OpenFile.open(path);
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (_) =>
          //
          //     PdfPage(path:path,name:widget.name.toString(),assets: "null",assetsValue:false)));
        });
      } catch (e) {
        print(e);
      }
      setState(() {
        downloading = false;
        progress = "Download Completed.";
        path = dirloc + widget.name.toString() + ".pdf";
      });
    }


  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: Center(
          child: downloading
              ? Container(
                  height: 120.0,
                  width: 200.0,
                  child: Card(
                    color: Colors.black,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Downloading File: $progress',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("File Saving At:"),
                    Text(path),
                  ],
                )));
}
