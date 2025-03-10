import 'package:flutter/material.dart';

class MainScanView extends StatefulWidget {
  const MainScanView({super.key});

  @override
  State<MainScanView> createState() => _MainScanViewState();
}

class _MainScanViewState extends State<MainScanView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan"),
        actions: const [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
