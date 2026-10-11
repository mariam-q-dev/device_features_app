import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class DeviceInfoScreen extends StatefulWidget {
  const DeviceInfoScreen({super.key});

  @override
  State<DeviceInfoScreen> createState() => _DeviceInfoScreenState();
}

class _DeviceInfoScreenState extends State<DeviceInfoScreen> {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
  }

  Future<void> _getDeviceInfo() async {
    Map<String, dynamic> deviceData = {};

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
        deviceData = {
          'Brand': androidInfo.brand,
          'Model': androidInfo.model,
          'Device': androidInfo.device,
          'Android Version': androidInfo.version.release,
          'SDK Int': androidInfo.version.sdkInt,
          'Manufacturer': androidInfo.manufacturer,
          'Is Physical Device': androidInfo.isPhysicalDevice,
        };
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await _deviceInfoPlugin.iosInfo;
        deviceData = {
          'Name': iosInfo.name,
          'Model': iosInfo.model,
          'System Name': iosInfo.systemName,
          'System Version': iosInfo.systemVersion,
          'Is Physical Device': iosInfo.isPhysicalDevice,
        };
      }
    } catch (e) {
      deviceData = {'Error': 'Failed to get device info: $e'};
    }

    if (mounted) {
      setState(() {
        _deviceData = deviceData;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Information'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: _deviceData.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                String key = _deviceData.keys.elementAt(index);
                String value = _deviceData[key].toString();
                return ListTile(
                  title: Text(
                    key,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(value),
                  leading: const Icon(Icons.info_outline),
                );
              },
            ),
    );
  }
}