import 'package:easacc_task/data/models/device.dart';
import 'package:flutter/material.dart';

class DeviceListItem extends StatelessWidget {
  final Device _device;
  DeviceListItem(this._device);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        _device.ipAddress,
      ),
      subtitle: Text(
        "Hello World",
      ),
    );
  }
}
