import 'dart:io';
import 'package:flutter/material.dart';

class PdfPage extends StatefulWidget {
  final String path;
  final String name;
  final String assets;
  final bool assetsValue;

  PdfPage({ required this.path, required this.name, required this.assets, required this.assetsValue});

  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  var progress = "";
  bool _isLoading = true;
  bool downloading = false;
  var _onPressed;

  @override
  void initState() {
    super.initState();
    // loadsDocument();
  }

  // loadsDocument() async {
  //   File file = new File.fromUri(Uri.parse(widget.path));
  //   if(widget.assetsValue==true){
  //    document = await PDFDocument.fromAsset(widget.assets);}else{
  //   document = await PDFDocument.fromFile(file);}
  //   setState(() => _isLoading = false);
  // }

  @override
  Widget build(BuildContext context) => Scaffold(
  //     appBar: AppBar(
  //       elevation: 0,
  //       automaticallyImplyLeading: false,
  // backgroundColor: Colors.transparent,
  // //       title: Text(widget.name),
  // // centerTitle: true,
  // leading: IconButton(icon: Icon(Icons.close),color: Colors.black,onPressed:(){Navigator.pop(context);} ),
  //     ),
      body: Stack(
        children: [

          Center(
            child:
            // _isLoading
            //     ?
            Center(child: CircularProgressIndicator())
            //     : PDFViewer(
            //
            //   lazyLoad: false,
            //
            //   scrollDirection: Axis.vertical,
            //   // document: document,
            //   zoomSteps: 1,
            // ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4,30,0,0),
            child: IconButton(icon: Icon(Icons.close),color: Colors.black,onPressed:(){Navigator.pop(context);} ),
          ),
        ],

      ));
}
