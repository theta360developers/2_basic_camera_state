import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'THETA X App',
      home: const MyHomePage(title: 'THETA X App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String message = "";
  String battery = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "THETA ",
                  style: TextStyle(fontFamily: 'KdamThmor', fontSize: 50),
                ),
                Text(
                  "X",
                  style: TextStyle(
                      fontFamily: 'KdamThmor',
                      fontSize: 50,
                      color: Colors.amber),
                )
              ],
            ),
            const Text(
              "BUTTONS",
              style: TextStyle(fontFamily: 'Raleway', fontSize: 20),
            ),
            //add background container
            Padding(
              padding: const EdgeInsets.only(top: 70),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      var url = Uri.parse('http://192.168.1.1/osc/info');
                      var headers = {
                        'Content-Type': 'application/json;charset=utf-8'
                      };
                      var response = await http.get(url, headers: headers);
                      //    print(response.body);
                      var encoder = JsonEncoder.withIndent('  ');
                      var formattedResponse =
                          encoder.convert(jsonDecode(response.body));
                      setState(() {
                        message = formattedResponse;
                      });
                    },
                    child: Text(
                      "Info",
                      style: TextStyle(fontFamily: 'Raleway'),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(255, 48, 47, 45),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      var url = Uri.parse('http://192.168.1.1/osc/state');
                      var headers = {
                        'Content-Type': 'application/json;charset=utf-8'
                      };
                      var response = await http.post(url, headers: headers);
                      var thetaState = jsonDecode(response.body);
                      var batteryLevel = thetaState['state']['batteryLevel'];
                      var encoder = JsonEncoder.withIndent('  ');
                      var formattedResponse =
                          encoder.convert(jsonDecode(response.body));
                      setState(() {
                        message = formattedResponse;
                        if (batteryLevel == 1.0) {}
                      });
                    },
                    child: Text(
                      "State",
                      style: TextStyle(fontFamily: 'Raleway'),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 48, 47, 45),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () async {
                      var url =
                          Uri.parse('http://192.168.1.1/osc/commands/execute');
                      var header = {
                        'Content-Type': 'application/json;charset=utf-8'
                      };
                      var bodyMap = {'name': 'camera.takePicture'};
                      var bodyJson = jsonEncode(bodyMap);
                      var response =
                          await http.post(url, headers: header, body: bodyJson);
                      setState(() {
                        message = "Taking Picture...\n\n";
                      });
                    },
                    color: Colors.amber,
                    icon: FaIcon(FontAwesomeIcons.camera)),
              ],
            ),
            Expanded(
                flex: 4,
                child: SingleChildScrollView(
                    child: SyntaxView(
                  code: message,
                  syntax: Syntax.DART,
                  syntaxTheme: SyntaxTheme.ayuLight(),
                  withLinesCount: false,
                ))),
            IconButton(onPressed: () {}, icon: Icon(Icons.battery_std))
          ],
        ),
      ),
    );
  }
}
