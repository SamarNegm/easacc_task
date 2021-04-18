import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:easacc_task/data/models/device.dart';
import 'package:easacc_task/presentation/widgets/device_item.dart';
import 'package:flutter/material.dart';
import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:wifi/wifi.dart';

class settings extends StatefulWidget {
  static const routeName = '/settings';
  @override
  _settingsState createState() => _settingsState();
}

class _settingsState extends State<settings> {
  List<Device> devices = [];

  Future<Null> _scanDevices() async {
    final String ip = await Wifi.ip;
    final String subnet = ip.substring(0, ip.lastIndexOf('.'));
    final int port = 80;

    final stream = NetworkAnalyzer.discover(subnet, port);
    http.Client client = http.Client();
    stream.listen((NetworkAddress addr) {
      _testConnection(client, addr.ip);
    });

    return null;
  }

  void _testConnection(final http.Client client, final String ip) async {
    try {
      final response = await client.get(Uri.parse('http://$ip/helloWorld'));

      if (response.statusCode == 200) {
        if (!response.body.startsWith("<")) {
          if (!devices.contains(ip)) {
            print('Found a device with ip $ip! Adding it to list of devices');
            List<Device> containedDevices = [];
            for (Device device in devices) {
              if (device.ipAddress.compareTo(ip) == 0) {
                containedDevices.add(device);
              }
            }

            if (containedDevices.length == 0) {
              setState(() {
                devices.add(
                  Device(ip),
                );
              });
            }
          }
        }
      }
    } on SocketException catch (e) {
      //NOP
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 242, 244, 243),
      body: RefreshIndicator(
        onRefresh: () {},
        child: Flex(
          crossAxisAlignment: CrossAxisAlignment.start,
          direction: Axis.vertical,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: devices.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return DeviceListItem(devices[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
