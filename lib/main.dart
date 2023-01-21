import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:loggerapp/logger.dart';
import 'package:loggerapp/tester.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String title = 'Smart Logging';

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: title,
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        home:
        //MyHomePage1()
     MainPage(title: title),
      );
}

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({
    required this.title,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final log = logger(MainPage);
    final Dio dio = Dio();
      double progress = 0;
TextEditingController df = new TextEditingController();
TextEditingController sd = new TextEditingController();

  // Future<String> getFilePath() async {
  //   Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
  //   String appDocumentsPath = appDocumentsDirectory.path;
  //   String filePath = '$appDocumentsPath/demoTextFile.txt';

  //   return filePath;
  // }

  // void saveFile() async {
  //   File file = File(await getFilePath());
  //   file.writeAsString('${log}'+
  //       "This is my demo text that will be saved to : demoTextFile.txt");
  // }

  // void readFile() async {
  //   File file = File(await getFilePath());
  //   String fileContent = await file.readAsString();

  //   print('File Content: $fileContent');
  // }
    Future<bool> saveVideo(String url, String fileName) async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          String newPath = "";
          print(directory);
          List<String> paths = directory!.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/Testkamal";
          directory = Directory(newPath);
        } else {
          return false;
        }
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }
      File saveFile = File(directory.path + "/$fileName");
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        saveFile.writeAsStringSync(url+"\n", mode: FileMode.append);
   
      // saveFile.write(ioSink);
        // await saveFile.writeAsString(
        // url);
        //  dio.download(url, saveFile.path,
        //     onReceiveProgress: (value1, value2) {
        //       setState(() {
        //         progress = value1 / value2;
        //       });
        //     });
        if (Platform.isIOS) {
          await ImageGallerySaver.saveFile(saveFile.path,
              isReturnPathOfIOS: true);
        }
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // buildButton('DEBUG', Colors.blue, () => log.d('Debug message')),
              // buildButton('INFO', Colors.blue, () => log.i('Info message')),
              // buildButton(
              //     'WARNING', Colors.orange, () => log.w('Warning message')),
              
              // buildButton('WTF', Colors.red, () => log.wtf('Wtf message')),
              buildButton('ERROR', Colors.red, () => log.e('Error message')),
              Row(
                children: [
                  RaisedButton(onPressed: (){
                    if(df.text=="ka"){
                   String gg = "${DateTime.now()}" +" "+ " app Error message" ;
                     saveVideo(
    gg  ,
        "app.txt");
                     log.e('Error message');
                    }
                    else{
                      print("okay");
                    }
                  },child: Text("Change color"),)
                ],
              ),
                 Row(
                children: [
                  RaisedButton(onPressed: (){
                    if(sd.text=="da"){
                     String ff = "${DateTime.now()}" +" "+ " reapp Error message ";
                      //" reapp Error message" + "${DateTime.now()}";
                     saveVideo(
    ff  ,
        "app.txt");
                     log.e('not match message');
                    }
                    else{
                      print("report");
                    }
                  },child: Text("Change"),)
                ],
              ),
               TextFormField(
              controller: df,
            
             ),
             TextFormField(
              controller: sd,
            
             )
            ],
            
          ),
          
        ),
      );

  Widget buildButton(
    String text,
    Color color,
    VoidCallback onClicked,
  ) =>
      Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: RaisedButton(
          child: Text(text),
          shape: StadiumBorder(),
          textColor: Colors.white,
          color: color,
          onPressed: onClicked,
        ),
      );
}