import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:messaging/firebase_options.dart';
import 'package:messaging/local_services.dart';


Future<void>backgrooundHendler(RemoteMessage message
) async{
  print("${message.data}");
}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
  );
 FirebaseMessaging.onBackgroundMessage(backgrooundHendler);
 LocalNotifacationServices.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FlutterMessage(),
    );
  }
}

class FlutterMessage extends StatefulWidget {
  const FlutterMessage({super.key});

  @override
  State<FlutterMessage> createState() => _FlutterMessageState();
}

class _FlutterMessageState extends State<FlutterMessage> {
  @override
  void initState() {
    // TODO: implement initState
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print('app terminated');
      if(message!= null){
        print('new notification');
      }
    });

    FirebaseMessaging.onMessage.listen((message) {
      print('app is running on foreground');
      if(message.notification != null){
        print(message.notification!.title);
        print(message.notification!.body);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('app is running on background');
      if(message.notification != null){
        print(message.notification!.title);
        print(message.notification!.body); 

        //here we call the crate notification method
        LocalNotifacationServices.createNotification(message);
      } 
    });


    super.initState();
  }
  var name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter messaging"),
      ),
      body:const Center(
        child: Text('server notification'),
      ),
 
    );
  }
}
