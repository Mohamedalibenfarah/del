import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FilePg extends StatefulWidget {
  const FilePg({Key? key}) : super(key: key);

  @override
  State<FilePg> createState() => _FilePgState();
}

class _FilePgState extends State<FilePg> {
  Uint8List? _fileBytes;
  String? _fileName;
  bool _isLoading = false;
  static const String baseUrl = 'http://192.168.1.114:8000';

  /// Picking file
  Future<void> _pickFile() async {
    debugPrint('Picking file...');
    if (kIsWeb) {
      debugPrint('Running on web...');
      html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = '.xlsx';
      uploadInput.click();

      uploadInput.onChange.listen((e) {
        final files = uploadInput.files;
        if (files!.isNotEmpty) {
          final file = files[0];
          final reader = html.FileReader();
          reader.readAsArrayBuffer(file);
          reader.onLoadEnd.listen((event) {
            setState(() {
              _fileBytes = Uint8List.fromList(reader.result as List<int>);
              _fileName = file.name;
              debugPrint('File selected: $_fileName');
            });
          });
        }
      });
    } else {
      debugPrint('Running on non-web platform...');
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result != null) {
        setState(() {
          _fileBytes = result.files.single.bytes;
          _fileName = result.files.single.name;
          debugPrint('File selected: $_fileName');
        });
      } else {
        debugPrint('No file selected');
      }
    }
  }

  /// Upload file and handle response
  Future<void> _uploadFile() async {
    if (_fileBytes == null || _fileName == null) return;

    setState(() {
      _isLoading = true;
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/upload/'),
    );

    request.files.add(http.MultipartFile.fromBytes('file', _fileBytes!,
        filename: _fileName!));

    try {
      var response = await request.send();
      debugPrint('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        debugPrint('Response body: $responseBody');
        // Assuming the backend returns a JSON object with a "message" field indicating success
        var responseJson = json.decode(responseBody);
        if (responseJson['message'] == 'Data uploaded successfully') {
          _showAlert(context, 'File uploaded successfully!');
        } else {
          _showAlert(
              context, 'Failed to upload file: ${responseJson['message']}');
        }
      } else {
        _showAlert(context, 'Failed to upload file: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Upload failed: $e');
      _showAlert(context, 'Failed to upload file: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  /// Show alert dialog
  void _showAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Center(
          child: Text('Uploading File'),
        ),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.green)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Welcome to the Document Upload Center\n Upload Your Files Here",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 15.0,
                        ),
                      ),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(fontSize: 16),
                      ),
                    ),
                    onPressed: _pickFile,
                    child: const Text('Pick Your File'),
                  ),
                  if (_fileName != null) Text(_fileName!),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 15.0,
                        ),
                      ),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(fontSize: 16),
                      ),
                    ),
                    onPressed: _uploadFile,
                    child: const Text('Upload Your File'),
                  ),
                ],
              ),
      ),
    );
  }
}
