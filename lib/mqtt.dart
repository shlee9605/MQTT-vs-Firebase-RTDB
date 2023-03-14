// flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

class MyMqttPage extends StatefulWidget {
  const MyMqttPage({super.key, required this.title});

  final String title;

  @override
  State<MyMqttPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyMqttPage> {
  final String broker = '192.168.0.11:1883';
  final String topic = 'xarm6_whole';
  late MqttBrowserClient client;
  int starttime = 0;
  int currenttime = 0;
  List<String> mqttdata = [];
  Map<String, dynamic>? jsonString;

  Future<void> mqtt() async {
    client = MqttBrowserClient('ws://192.168.0.11', '');
    client.port = 9001;
    await client.connect();
    client.subscribe(topic, MqttQos.atMostOnce);
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      final MqttPublishMessage message =
          messages[0].payload as MqttPublishMessage;
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);
      setState(() {
        jsonString = jsonDecode(payload);
        double time = double.parse(jsonString!['timestamp']);
        print(time);

        starttime = (time * 1000000).toInt();

        DateTime now = DateTime.now();
        currenttime = now.microsecondsSinceEpoch;

        print('start time : $starttime, current time : $currenttime');

        mqttdata[0] = (starttime - currenttime).toString();
        // print('$timestamp');
        // mqttdata.add(payload);
      });
    });
  }

  @override
  void initState() {
    mqttdata.add('start');
    mqtt();
    super.initState();
    print("succeed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MQTT Example'),
      ),
      body: ListView(
        children:
            mqttdata.map((message) => ListTile(title: Text(message))).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/firebase');
        },
        tooltip: 'Move FB',
        child: const Icon(Icons.fork_left),
      ),
    );
  }

  @override
  void dispose() {
    client.disconnect();
    super.dispose();
  }
}
