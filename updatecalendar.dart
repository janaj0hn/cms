import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';

class UpdateEngDateScreen extends StatefulWidget {
  static const String id = "UpdateEngDateScreen-page";
  const UpdateEngDateScreen({Key? key}) : super(key: key);

  @override
  _UpdateEngDateScreenState createState() => _UpdateEngDateScreenState();
}

class _UpdateEngDateScreenState extends State<UpdateEngDateScreen> {
  bool _isLoading = false;
  String _statusMessage = '';
  int _updatedCount = 0;
  int _totalProcessed = 0;
  bool _showProgress = false;
  double _progress = 0.0;
  List<String> _updateLog = [];
  bool _showLog = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Color(0xfff5f5f5),
        title: const Text("Update English Dates"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 800),
            child: Card(
              color: Colors.white,
              elevation: 2,
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Update English Dates for Bhogam Records',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Upload an Excel file with Tamil calendar to English date mapping. '
                      'The system will update English dates for Bhogam records where '
                      'Tamil month matches and Bhogam Event matches with either '
                      'Tamil thithi or Nakshatram based on Bhogam Event Type.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32),
                    ElevatedButton.icon(
                      icon: Icon(Icons.upload_file),
                      label: Text('Upload Excel File'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff2E2D8A),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _isLoading ? null : _importFromExcel,
                    ),
                    SizedBox(height: 24),
                    if (_showProgress) ...[
                      LinearProgressIndicator(value: _progress),
                      SizedBox(height: 16),
                      Text(
                        'Processed $_totalProcessed records, updated $_updatedCount',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                    ],
                    if (_statusMessage.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _statusMessage.contains('Error')
                              ? Colors.red.shade100
                              : Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _statusMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _statusMessage.contains('Error')
                                ? Colors.red.shade900
                                : Colors.green.shade900,
                          ),
                        ),
                      ),
                    if (_updatedCount > 0) ...[
                      SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: Icon(
                            _showLog ? Icons.visibility_off : Icons.visibility),
                        label: Text(
                            _showLog ? 'Hide Update Log' : 'Show Update Log'),
                        onPressed: () {
                          setState(() {
                            _showLog = !_showLog;
                          });
                        },
                      ),
                      if (_showLog) ...[
                        SizedBox(height: 16),
                        Container(
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: ListView.builder(
                            itemCount: _updateLog.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(_updateLog[index]),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _importFromExcel() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Preparing to import...';
      _updatedCount = 0;
      _totalProcessed = 0;
      _showProgress = true;
      _progress = 0.0;
      _updateLog = [];
    });

    try {
      final uploadInput = html.FileUploadInputElement()..accept = '.xlsx,.xls';
      uploadInput.click();

      uploadInput.onChange.listen((e) async {
        final files = uploadInput.files;
        if (files == null || files.isEmpty) {
          setState(() {
            _statusMessage = 'No file selected';
            _isLoading = false;
            _showProgress = false;
          });
          return;
        }

        final file = files[0];
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);

        reader.onLoadEnd.listen((e) async {
          try {
            final data = reader.result as List<int>;
            final excel = Excel.decodeBytes(data);

            // Assuming the first sheet contains the data
            final sheet = excel.tables.keys.first;
            final rows = excel.tables[sheet]!.rows;

            if (rows.isEmpty || rows.length < 2) {
              setState(() {
                _statusMessage =
                    'No data found in Excel file or insufficient data';
                _isLoading = false;
                _showProgress = false;
              });
              return;
            }

            // Extract header row to find column indices
            final headers = rows[0]
                .map((cell) => cell?.value.toString().trim() ?? '')
                .toList();

            final englishDateIndex = headers.indexOf('English Date');
            final tamilMonthIndex = headers.indexOf('Tamil Month');
            final tamilThithiIndex = headers.indexOf('Tamil thithi');
            final nakshatramIndex = headers.indexOf('Nakshatram');

            if (englishDateIndex == -1 ||
                tamilMonthIndex == -1 ||
                tamilThithiIndex == -1 ||
                nakshatramIndex == -1) {
              setState(() {
                _statusMessage =
                    'Error: Required columns not found in Excel file. ' +
                        'Please ensure the file contains: English Date, Tamil Month, Tamil thithi, and Nakshatram columns.';
                _isLoading = false;
                _showProgress = false;
              });
              return;
            }

            // Create two mappings:
            // 1. Month + Thithi -> English Date
            // 2. Month + Nakshatram -> English Date
            final dataRows = rows.sublist(1);
            final thithiMapping = <String, String>{};
            final nakshatramMapping = <String, String>{};

            // Find maximum index value
            final maxIndex = [
              englishDateIndex,
              tamilMonthIndex,
              tamilThithiIndex,
              nakshatramIndex
            ].reduce((curr, next) => curr > next ? curr : next);

            for (var row in dataRows) {
              if (row.length <= maxIndex) {
                continue; // Skip rows with insufficient data
              }

              final englishDate = row[englishDateIndex]?.value.toString() ?? '';
              final tamilMonth = row[tamilMonthIndex]?.value.toString() ?? '';
              final tamilThithi = row[tamilThithiIndex]?.value.toString() ?? '';
              final nakshatram = row[nakshatramIndex]?.value.toString() ?? '';

              if (englishDate.isEmpty || tamilMonth.isEmpty) {
                continue; // Skip rows without essential data
              }

              // Create keys for both mappings
              final thithiKey = '$tamilMonth|$tamilThithi'.toLowerCase();
              final nakshatramKey = '$tamilMonth|$nakshatram'.toLowerCase();

              thithiMapping[thithiKey] = englishDate;
              nakshatramMapping[nakshatramKey] = englishDate;
            }

            // Now fetch all Bhogam records and update where matches found
            final snapshot = await FirebaseFirestore.instance
                .collection('BhogamDetails')
                .get();

            final totalDocs = snapshot.docs.length;
            int processed = 0;
            int updated = 0;

            for (var doc in snapshot.docs) {
              processed++;
              final data = doc.data();
              final docId = doc.id;

              final bhogamMonth = data['Bhogam month']?.toString().trim() ?? '';
              final bhogamEvent = data['Bhogam Event']?.toString().trim() ?? '';
              final bhogamEventType =
                  data['Bhogam Event Type']?.toString().trim() ?? '';

              // Determine which mapping to use based on Event Type
              if (bhogamMonth.isNotEmpty && bhogamEvent.isNotEmpty) {
                String? newEnglishDate;
                String matchType = '';

                // Check if the event type indicates thithi
                if (bhogamEventType.toLowerCase().contains('thithi')) {
                  final key = '$bhogamMonth|$bhogamEvent'.toLowerCase();
                  newEnglishDate = thithiMapping[key];
                  matchType = 'Thithi';
                }
                // Check if the event type indicates nakshatram
                else if (bhogamEventType.toLowerCase().contains('naksh')) {
                  final key = '$bhogamMonth|$bhogamEvent'.toLowerCase();
                  newEnglishDate = nakshatramMapping[key];
                  matchType = 'Naksh';
                }

                // If we found a match, update the record
                if (newEnglishDate != null && newEnglishDate.isNotEmpty) {
                  try {
                    await FirebaseFirestore.instance
                        .collection('BhogamDetails')
                        .doc(docId)
                        .update({'English Calender Date': newEnglishDate});

                    updated++;

                    // Add to update log
                    final log = 'Updated Doc ID: $docId - '
                        'Month: $bhogamMonth, '
                        'Event Type: $bhogamEventType, '
                        'Event: $bhogamEvent, '
                        'Match Type: $matchType, '
                        'New Date: $newEnglishDate';

                    setState(() {
                      _updateLog.add(log);
                    });
                  } catch (e) {
                    setState(() {
                      _updateLog.add('Error updating Doc ID: $docId - $e');
                    });
                  }
                }
              }

              setState(() {
                _totalProcessed = processed;
                _updatedCount = updated;
                _progress = processed / totalDocs;
              });
            }

            setState(() {
              _statusMessage =
                  'Import completed. Updated $updated out of $totalDocs records.';
              _isLoading = false;
            });
          } catch (e) {
            setState(() {
              _statusMessage = 'Error processing Excel file: $e';
              _isLoading = false;
              _showProgress = false;
            });
          }
        });
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
        _isLoading = false;
        _showProgress = false;
      });
    }
  }
}
