import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:sms/sms.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SmsGet());
  }
}

class SmsGet extends StatefulWidget {
  const SmsGet({Key? key}) : super(key: key);

  @override
  State<SmsGet> createState() => _SmsGetState();
}

class _SmsGetState extends State<SmsGet> {
  var sms = [];
  @override
  void initState() {
    super.initState();
    startService();
  }

  startService() {
    SmsReceiver receiver = SmsReceiver();
    receiver.onSmsReceived!.listen((SmsMessage msg) {
      print('Sms received: ${msg.body}');

      if (msg.sender == 'bKash') {
        print('Sms received: ${msg.body}');
        var amount = msg.body.split('You have received Tk ')[1];
        amount = amount.split(' from ')[0];
        print(amount);
        var phone = msg.body.split('from ')[1];
        phone = phone.split('. Fee Tk')[0];
        print(phone.substring(7));
        sendSmsToServer(phone.substring(7), amount);
      }
    });
  }

  sendSmsToServer(String num, amount) async {
    var urlx = 'http://server.fahimtraders.com/smssend';
    var url = Uri.parse(urlx);

    var response = await http.post(
      url,
      body: {"number": num, "amount": amount},
    );
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('Sms Service', style: TextStyle(fontSize: 30))),
    );
  }
}
