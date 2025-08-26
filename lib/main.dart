import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: NFCReaderScreen());
  }
}

class NFCReaderScreen extends StatefulWidget {
  const NFCReaderScreen({super.key});

  @override
  _NFCReaderScreenState createState() => _NFCReaderScreenState();
}

class _NFCReaderScreenState extends State<NFCReaderScreen> {
  String nfcData = "Tap an NFC tag";
  Future<void> startNFC() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) {
      setState(() {
        nfcData = "NFC is not available on this device";
      });
      return;
    }
    NfcManager.instance.startSession(
      pollingOptions: {NfcPollingOption.iso14443},
      onDiscovered: (NfcTag tag) async {
        setState(() {
          nfcData = tag.data.toString();
        });
        NfcManager.instance.stopSession();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("NFC Reader")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(nfcData, style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(onPressed: startNFC, child: Text("Scan NFC Tag")),
          ],
        ),
      ),
    );
  }
}
