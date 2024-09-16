import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;

class HistoryPage extends StatefulWidget {
  static const String id = 'sishya=edit';
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Future<void> _importFromCsv() async {
    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept = '.csv';

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files!.isEmpty) {
        print('No file selected');
        return;
      }

      final file = files[0];
      final reader = html.FileReader();

      reader.readAsText(file);

      reader.onLoadEnd.listen((e) async {
        final content = reader.result as String;
        final csvConverter = CsvToListConverter();
        final rows = csvConverter.convert(content);

        if (rows.isEmpty) {
          print('No data found in CSV');
          return;
        }

        // Assuming the first row contains headers
        final headers = rows.first
            .map((header) => _sanitizeFieldName(header.toString()))
            .toList();
        final dataRows = rows.sublist(1);

        int rowCount = 0;

        for (var row in dataRows) {
          if (row.isEmpty) {
            print('Empty row found');
            continue;
          }

          final data = <String, dynamic>{};
          for (var i = 0; i < row.length; i++) {
            if (i < headers.length) {
              data[headers[i]] = row[i]?.toString() ?? '';
            }
          }

          // Generate a unique ID for each record
          final subId = generateShortId(10); // Adjust length as needed
          data['subId'] = subId; // Include the generated ID in the data

          print('Data to upload: $data');

          try {
            await FirebaseFirestore.instance
                .collection('secondFormSubmissions')
                .doc(subId)
                .set(data, SetOptions(merge: true));
            rowCount++;
          } catch (e) {
            print('Error uploading data to Firestore: $e');
          }
        }

        if (rowCount > 0) {
          await _updateSubmissionCounts('sishyasCount', rowCount);
        }
      });
    });

    uploadInput.click();
  }

  String _sanitizeFieldName(String fieldName) {
    return fieldName.replaceAll(RegExp(r'^__|__$'), '');
  }

  String generateShortId(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rand = Random();
    return List.generate(length, (index) => chars[rand.nextInt(chars.length)])
        .join();
  }

  Future<void> _updateSubmissionCounts(
      String countType, int countIncrement) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('submissionCounts')
          .doc('counts');
      final doc = await docRef.get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        int currentCount = data[countType] ?? 0;

        await docRef.update({
          countType: currentCount + countIncrement,
        });
      } else {
        await docRef.set({
          countType: countIncrement,
        });
      }
    } catch (e) {
      print('Error updating submission counts: $e');
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _selectedDistrict;

  Future<List<String>> _fetchDistricts() async {
    final snapshot = await _firestore.collection('firstFormSubmissions').get();
    final districts = <String>{};

    for (var doc in snapshot.docs) {
      if (doc.data().containsKey('district')) {
        districts.add(doc['district']);
      }
    }

    return districts.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Sishyas Masters'),
        actions: [
          ElevatedButton(
            onPressed: _importFromCsv,
            child: Text('Import from CSV'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<String>>(
              future: _fetchDistricts(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final districts = snapshot.data!;

                return DropdownButton<String>(
                  hint: Text('Select District'),
                  value: _selectedDistrict,
                  items: districts.map((district) {
                    return DropdownMenuItem<String>(
                      value: district,
                      child: Text(district),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDistrict = value;
                    });
                  },
                );
              },
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('firstFormSubmissions')
                    .where('district', isEqualTo: _selectedDistrict)
                    .snapshots(),
                builder: (context, firstFormSnapshot) {
                  if (!firstFormSnapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final firstFormEntries = firstFormSnapshot.data!.docs;

                  return StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('secondFormSubmissions')
                        .snapshots(),
                    builder: (context, secondFormSnapshot) {
                      if (!secondFormSnapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final secondFormEntries = secondFormSnapshot.data!.docs;

                      Map<String, List<Map<String, dynamic>>>
                          groupedSubmissions = {};

                      for (var entry in firstFormEntries) {
                        String id = entry['id'];
                        groupedSubmissions[id] = [];
                      }

                      for (var entry in secondFormEntries) {
                        String id = entry['id'];
                        if (groupedSubmissions.containsKey(id)) {
                          groupedSubmissions[id]!
                              .add(entry.data() as Map<String, dynamic>);
                        }
                      }

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth < 600) {
                            // Mobile view
                            return ListView(
                              children: groupedSubmissions.entries.map((group) {
                                String id = group.key;
                                List<Map<String, dynamic>> details =
                                    group.value;

                                return Column(
                                  children: details.map((detail) {
                                    String subId = detail['subId'] ?? '';

                                    return Card(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 8.0),
                                      child: ListTile(
                                        title: Text('Sishya ID: $subId'),
                                        subtitle:
                                            Text(detail['Name'] ?? 'No Name'),
                                        onTap: () {
                                          _showDetailsBottomSheet(
                                            id,
                                            subId,
                                            detail,
                                          );
                                        },
                                        trailing: IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            _showEditBottomSheet(
                                              id,
                                              subId,
                                              detail,
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              }).toList(),
                            );
                          } else {
                            // Desktop view
                            return ListView(
                              children: groupedSubmissions.entries.map((group) {
                                String id = group.key;
                                List<Map<String, dynamic>> details =
                                    group.value;

                                return Card(
                                  margin: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Address ID: $id',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height: 10),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: DataTable(
                                            columnSpacing: 12,
                                            columns: [
                                              DataColumn(
                                                  label: Text('Sishya ID')),
                                              DataColumn(
                                                  label: Text('SishyaType')),
                                              DataColumn(label: Text('Name')),
                                              DataColumn(label: Text('DOB')),
                                              DataColumn(
                                                  label: Text(
                                                      'Samasreyanam Date')),
                                              DataColumn(label: Text('Mobile')),
                                              DataColumn(
                                                  label: Text('Actions')),
                                            ],
                                            rows: details.map((detail) {
                                              String subId =
                                                  detail['subId'] ?? '';
                                              return DataRow(
                                                cells: [
                                                  DataCell(
                                                    ConstrainedBox(
                                                      constraints:
                                                          BoxConstraints(
                                                        maxWidth: 100,
                                                      ),
                                                      child: Text(
                                                        subId,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    ConstrainedBox(
                                                      constraints:
                                                          BoxConstraints(
                                                        maxWidth: 200,
                                                      ),
                                                      child: Text(
                                                        detail['SishyaType'] ??
                                                            '',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    ConstrainedBox(
                                                      constraints:
                                                          BoxConstraints(
                                                        maxWidth: 150,
                                                      ),
                                                      child: Text(
                                                        detail['Name'] ?? '',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    ConstrainedBox(
                                                      constraints:
                                                          BoxConstraints(
                                                        maxWidth: 150,
                                                      ),
                                                      child: Text(
                                                        detail['DOB'] ?? '',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    ConstrainedBox(
                                                      constraints:
                                                          BoxConstraints(
                                                        maxWidth: 150,
                                                      ),
                                                      child: Text(
                                                        detail['Samasreyanam Date'] ??
                                                            '',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    ConstrainedBox(
                                                      constraints:
                                                          BoxConstraints(
                                                        maxWidth: 150,
                                                      ),
                                                      child: Text(
                                                        detail['Mobileone'] ??
                                                            '',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Row(
                                                      children: [
                                                        IconButton(
                                                          icon:
                                                              Icon(Icons.edit),
                                                          onPressed: () {
                                                            _showEditBottomSheet(
                                                              id,
                                                              subId,
                                                              detail,
                                                            );
                                                          },
                                                        ),
                                                        IconButton(
                                                          icon: Icon(
                                                              Icons.visibility),
                                                          onPressed: () {
                                                            _showDetailsBottomSheet(
                                                              id,
                                                              subId,
                                                              detail,
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditBottomSheet(
      String id, String subId, Map<String, dynamic> detail) async {
    final predefinedSishyavalidindicator = ['YES', 'NO'];
    final predefinedIsSishyathefamilypointofcontact = ['YES', 'NO'];

    // Ensure a valid default value for the dropdown

    String selectedSishyavalidindicator =
        detail['Sishyavalidindicator'] ?? predefinedSishyavalidindicator.first;
    String selectedIsSishyathefamilypointofcontact =
        detail['IsSishyathefamilypointofcontact'] ??
            predefinedIsSishyathefamilypointofcontact.first;

    final nameController = TextEditingController(text: detail['Name']);
    final sishyaTypeController =
        TextEditingController(text: detail['SishyaType']);
    final dobController = TextEditingController(text: detail['DOB']);
    final samasreyanamDateController =
        TextEditingController(text: detail['Samasreyanam Date']);
    final mobileController = TextEditingController(text: detail['Mobileone']);
    final mobile2Controller = TextEditingController(text: detail['Mobiletwo']);
    final whatsappController = TextEditingController(text: detail['Whatsapp']);
    final emailController = TextEditingController(text: detail['Email']);
    final facebookLinkController =
        TextEditingController(text: detail['Facebook link']);
    final careOfPartController =
        TextEditingController(text: detail['careofpart']);
    final aliasExtraController =
        TextEditingController(text: detail['AliasExtra identity']);
    final SishyadataenteredbyController =
        TextEditingController(text: detail['Sishya data entered by']);

    // Method to show date picker
    Future<void> _selectDate(
        BuildContext context, TextEditingController controller) async {
      DateTime? selectedDate = DateTime.tryParse(controller.text);
      selectedDate = selectedDate ?? DateTime.now();

      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );

      if (picked != null && picked != selectedDate) {
        controller.text =
            "${picked.toLocal()}".split(' ')[0]; // Format to YYYY-MM-DD
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                TextField(
                  controller: sishyaTypeController,
                  decoration: InputDecoration(labelText: 'Sishya Type'),
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: dobController,
                  decoration: InputDecoration(labelText: 'DOB'),
                  readOnly: true,
                  onTap: () => _selectDate(context, dobController),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: samasreyanamDateController,
                  decoration: InputDecoration(labelText: 'Samasreyanam Date'),
                  readOnly: true,
                  onTap: () => _selectDate(context, samasreyanamDateController),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: careOfPartController,
                  decoration: InputDecoration(labelText: 'Care of Part'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: aliasExtraController,
                  decoration: InputDecoration(labelText: 'Alias Extra'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: mobileController,
                  decoration: InputDecoration(labelText: 'Mobile'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: mobile2Controller,
                  decoration: InputDecoration(labelText: 'Mobile (2)'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: whatsappController,
                  decoration: InputDecoration(labelText: 'WhatsApp'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: facebookLinkController,
                  decoration: InputDecoration(labelText: 'Facebook Link'),
                ),
                // DropdownButton for SetID
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: predefinedIsSishyathefamilypointofcontact
                          .contains(selectedIsSishyathefamilypointofcontact)
                      ? selectedIsSishyathefamilypointofcontact
                      : predefinedIsSishyathefamilypointofcontact.first,
                  items: predefinedIsSishyathefamilypointofcontact.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedIsSishyathefamilypointofcontact = value!;
                    });
                  },
                  decoration: InputDecoration(
                      labelText: 'Is Sishya the Family Point of Contact'),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: predefinedSishyavalidindicator
                          .contains(selectedSishyavalidindicator)
                      ? selectedSishyavalidindicator
                      : predefinedSishyavalidindicator.first,
                  items: predefinedSishyavalidindicator.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSishyavalidindicator = value!;
                    });
                  },
                  decoration:
                      InputDecoration(labelText: 'Sishyavalidindicator'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: SishyadataenteredbyController,
                  decoration:
                      InputDecoration(labelText: 'Sishya data entered by'),
                ),
                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _updateEntry(
                          id,
                          subId,
                          nameController.text,
                          sishyaTypeController.text,
                          dobController.text,
                          samasreyanamDateController.text,
                          mobileController.text,
                          mobile2Controller.text,
                          whatsappController.text,
                          emailController.text,
                          facebookLinkController.text,
                          careOfPartController.text,
                          aliasExtraController.text,
                          SishyadataenteredbyController.text,
                          selectedSishyavalidindicator,
                          selectedIsSishyathefamilypointofcontact,
                        );
                        Navigator.pop(context);
                      },
                      child: Text('Save'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDetailsBottomSheet(
      String id, String subId, Map<String, dynamic> detail) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sishya ID: $subId',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildDetailRow('Sishya Type', detail['SishyaType']),
                    _buildDetailRow('Name', detail['Name']),
                    _buildDetailRow('Care of Part', detail['careofpart']),
                    _buildDetailRow(
                        'Alias Extra', detail['AliasExtra identity']),
                    _buildDetailRow('DOB', detail['DOB']),
                    _buildDetailRow(
                        'Samasreyanam Date', detail['Samasreyanam Date']),
                    _buildDetailRow('Mobile', detail['Mobileone']),
                    _buildDetailRow('Mobile (2)', detail['Mobiletwo']),
                    _buildDetailRow('WhatsApp', detail['Whatsapp']),
                    _buildDetailRow('Email', detail['Email']),
                    _buildDetailRow('Facebook Link', detail['Facebook link']),
                    _buildDetailRow('Is Sishya the Family Point of Contact',
                        detail['IsSishyathefamilypointofcontact']),
                    _buildDetailRow('Sishya Valid Indicator',
                        detail['Sishyavalidindicator']),
                    _buildDetailRow('Sishya Data Entered By',
                        detail['Sishya data entered by']),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Close'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

// Helper method to build rows for details
  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateEntry(
    String id,
    String subId,
    String name,
    String sishyaType,
    String dob,
    String samasreyanamDate,
    String mobile,
    String mobile2,
    String whatsapp,
    String email,
    String facebookLink,
    String careOfPart,
    String aliasExtra,
    String Sishyadataenteredby,
    String Sishyavalidindicator,
    String IsSishyathefamilypointofcontact,
  ) async {
    try {
      // Ensure you are targeting the correct document
      final documentSnapshot = await _firestore
          .collection('secondFormSubmissions')
          .where('subId', isEqualTo: subId)
          .where('id', isEqualTo: id)
          .get();

      if (documentSnapshot.docs.isNotEmpty) {
        // If the document exists, update it
        final documentId = documentSnapshot.docs.first.id;
        await _firestore
            .collection('secondFormSubmissions')
            .doc(documentId)
            .update({
          'SishyaType': sishyaType,
          'Name': name,
          'DOB': dob,
          'Samasreyanam Date': samasreyanamDate,
          'Mobileone': mobile,
          'Mobiletwo': mobile2,
          'Whatsapp': whatsapp,
          'Email': email,
          'Facebook link': facebookLink,
          'careofpart': careOfPart,
          'AliasExtra identity': aliasExtra,
          'Sishya data entered by': Sishyadataenteredby,
          "Sishyavalidindicator": Sishyavalidindicator,
          "IsSishyathefamilypointofcontact": IsSishyathefamilypointofcontact,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Entry updated successfully')),
        );
      } else {
        // Document does not exist
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No document found to update')),
        );
      }
    } catch (error) {
      // Log detailed error information
      print('Failed to update entry: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update entry: $error')),
      );
    }
  }
}
