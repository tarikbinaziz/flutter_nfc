# flutter_nfc

A new Flutter project.

## Getting Started

Step 1: Add Dependencies

```yaml
dependencies:
    flutter:
      sdk: flutter
      nfc_manager: ^3.2.0
```
Step 2: Configure Permissions
For NFC functionality to work on mobile devices, necessary permissions must be added.

# Android Permissions:-
Modify your AndroidManifest.xml file to include:
```xml
<uses-permission android:name="android.permission.NFC"/>
<uses-feature android:name="android.hardware.nfc" android:required="true"/>
```

# iOS Permissions:-
Modify your Info.plist file to include:
<key>NFCReaderUsageDescription</key>
<string>We use NFC to read and write tags</string>


Step 3: Implement NFC Reading
Now, let’s create a basic Flutter UI to scan NFC tags and display their content.

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NFCReaderScreen(),
    );
  }
}
class NFCReaderScreen extends StatefulWidget {
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
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      setState(() {
        nfcData = tag.data.toString();
      });
      NfcManager.instance.stopSession();
    });
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
            ElevatedButton(
              onPressed: startNFC,
              child: Text("Scan NFC Tag"),
            ),
          ],
        ),
      ),
    );
  }
}
Step 4: Implement NFC Writing
Apart from reading, you can also write data to an NFC tag. Below is an example:

Future<void> writeNFC(String message) async {
  bool isAvailable = await NfcManager.instance.isAvailable();
  if (!isAvailable) {
    return;
  }

NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
    Ndef ndef = Ndef.from(tag);
    if (ndef != null && ndef.isWritable) {
      NdefMessage ndefMessage = NdefMessage([NdefRecord.createText(message)]);
      await ndef.write(ndefMessage);
    }
    NfcManager.instance.stopSession();
  });
}
Step 5: Enhancing the Application
To improve the functionality and usability of your NFC app, consider implementing the following features:

Error Handling & User Feedback: Display alerts or toasts for different NFC states (e.g., unsupported device, read/write failures).
Secure NFC Communication: Encrypt data before writing it to an NFC tag and implement authentication mechanisms.
Background NFC Processing: Allow NFC tag reading even when the app is in the background.
Multi-Tag Support: Enable scanning multiple tags in a single session for bulk operations.
Custom Data Structures: Store structured data such as JSON in NFC tags instead of plain text.
Step 6: Testing the NFC Functionality
To test your Flutter NFC application:

Deploy it to a physical device with NFC support.
Try scanning different NFC tags and observe the results.
Test writing functionality by encoding text into NFC tags and reading them back.
Conclusion
NFC technology offers a convenient and secure way to transfer data and enable contactless interactions. By leveraging Flutter and the nfc_manager package, you can easily integrate NFC functionality into your mobile applications. Whether for payments, authentication, or IoT interactions, NFC enhances the user experience.

By following the steps in this guide, you can successfully implement NFC reading and writing in your Flutter app. Now, try adding advanced features like encrypted storage, background scanning, or multi-tag support to make your app even more powerful!

