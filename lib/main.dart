import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nfc_manager/ndef_record.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager_ndef/nfc_manager_ndef.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: NfcWriteData());
  }
}

class NfcWriteData extends StatefulWidget {
  const NfcWriteData({super.key});

  @override
  State<NfcWriteData> createState() => _NfcWriteDataState();
}

class _NfcWriteDataState extends State<NfcWriteData> {
  bool _isScanning = false;
  String _urlToWrite = "https://example.com"; // Default URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NFC Write & Read')),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Enter URL to write'),
            onChanged: (value) => setState(() {
              _urlToWrite = value;
            }),
          ),
          ElevatedButton(
            onPressed: () => writeData(_urlToWrite),
            child: const Text("Write URL to NFC Tag"),
          ),
          ElevatedButton(
            onPressed: () => startReading(),
            child: const Text("Start NFC Reading"),
          ),
        ],
      ),
    );
  }

  void writeData(String url) async {
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        var ndef = Ndef.from(tag);
        if (ndef == null || !ndef.isWritable) {
          _isScanning = false;
          NfcManager.instance.stopSession();
          return;
        }

        try {
          NfcManager.instance.stopSession();
          setState(() {
            _isScanning = false;
          });
        } catch (e) {
          setState(() {
            _isScanning = false;
          });
        }
      },
      pollingOptions: {},
    );
  }
}

void startReading() {
  NfcManager.instance.startSession(
    pollingOptions: {
      NfcPollingOption.iso14443,
      NfcPollingOption.iso15693,
      NfcPollingOption.iso18092,
    },

    onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      print("NFC Tag discovered: $tag");
      if (ndef == null) {
        NfcManager.instance.stopSession();
        return;
      }

      NdefMessage? message = await ndef.read();
      print("NFC Message read: $message");
      if (message!.records.isNotEmpty) {
        NdefRecord record = message.records.first;
        String payload = utf8.decode(record.payload);
        payload = payload.substring(1); // Remove identifier byte

        // Uri? url = Uri.tryParse(payload);
        // if (url != null && await canLaunchUrl(url)) {
        //   await launchUrl(url); // Opens URL in browser
        // }
      }

      NfcManager.instance.stopSession();
    },
  );
}
