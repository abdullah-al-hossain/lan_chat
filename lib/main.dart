import 'package:flutter/material.dart';
import 'core/device_identity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, String>? device;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final data = await DeviceIdentity.getIdentity();
    setState(() => device = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("LAN Chat")),
      body: device == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Device ID: ${device!['id']}"),
            const SizedBox(height: 8),
            Text("Device Name: ${device!['name']}"),
            const SizedBox(height: 8),
            Text("Model: ${device!['model']}"),
          ],
        ),
      ),
    );
  }
}
