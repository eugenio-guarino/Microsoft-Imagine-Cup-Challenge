import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as Io;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'apikey.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String parsed_text = '';

  parsethetext() async {
    final imagefile = await ImagePicker().getImage(source:ImageSource.gallery, maxWidth: 670,   maxHeight: 970);

    var bytes = Io.File(imagefile.path.toString()).readAsBytesSync();
    String img64 = base64Encode(bytes);

    var url = 'https://api.ocr.space/parse/image';
    var payload = {"base64Image": "data:image/jpg;base64,${img64.toString()}"};
    var header = {"apikey": api_key};
    var post = await http.post(url=url,body: payload,headers: header);

    var result = jsonDecode(post.body);
    setState(() {
      parsed_text = result['ParsedResults'][0]['ParsedText'];
    });
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 30.0),
            alignment: Alignment.center,
            child: Text(
              "EXPIRATION DATE OCR",
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w700, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 15.0),
          Container(
            width: MediaQuery.of(context).size.width / 2,
            child: RaisedButton(
              onPressed: () => parsethetext(),
              child: Text(
                'UPLOAD IMAGE',
                style: GoogleFonts.montserrat(
                    fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          SizedBox(height: 70.0),
          Container(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Text(
                  "THE EXPIRATION DATE IS:",
                  style: GoogleFonts.montserrat(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Text(
                  parsed_text,
                  style: GoogleFonts.montserrat(
                      fontSize: 25, fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}