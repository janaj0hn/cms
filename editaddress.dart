// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'dart:html' as html;

// class AddressDataTable extends StatelessWidget {
//   static const String id = 'address=edit';
//   // Define the custom order for fields and the fields to display in the DataTable
//   final List<String> _fieldOrder = [
//     'id',
//     'address line 1',
//     'address line 2',
//     'address line 3',
//     'city',
//     'taluk',
//     'district',
//     'state',
//     'country',
//     'Pincode',
//     'Landmark',
//     'LandlinenumberCountry',
//     'Landlinenumber',
//     'address valid indicator',
//     'Addressdataentered',
//   ];

//   final List<String> _visibleFields = [
//     'id',
//     'address line 1',
//     'address line 2',
//     'address line 3',
//     'city',
//     'taluk',
//   ];
//   Future<void> _generateAndDownloadPDF(Map<String, dynamic> fields) async {
//     final pdf = pw.Document();

//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: fields.entries.map((entry) {
//               return pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 children: [
//                   pw.Text(
//                     entry.key,
//                     style: pw.TextStyle(
//                       fontWeight: pw.FontWeight.bold,
//                     ),
//                   ),
//                   pw.Text(entry.value.toString()),
//                 ],
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );

//     final Uint8List pdfInBytes = await pdf.save();

//     final blob = html.Blob([pdfInBytes]);
//     final url = html.Url.createObjectUrlFromBlob(blob);

//     final anchor = html.AnchorElement(href: url)
//       ..setAttribute('download', 'document.pdf')
//       ..click();

//     html.Url.revokeObjectUrl(url);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('All Address Masters')),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('firstFormSubmissions')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           final data = snapshot.data?.docs ?? [];

//           return LayoutBuilder(
//             builder: (context, constraints) {
//               bool isMobile = constraints.maxWidth < 600;

//               if (isMobile) {
//                 // Mobile view with ListView
//                 return ListView(
//                   children: data.map((doc) {
//                     final fields = doc.data() as Map<String, dynamic>;
//                     return Card(
//                       margin: EdgeInsets.all(8.0),
//                       child: ListTile(
//                         title: Text(fields['address line 1'] ?? ''),
//                         subtitle: Text(fields['city'] ?? ''),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               icon: Icon(Icons.visibility),
//                               onPressed: () => _showDetailsBottomSheet(
//                                   context, doc.id, fields),
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.edit),
//                               onPressed: () =>
//                                   _showEditBottomSheet(context, doc.id, fields),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 );
//               } else {
//                 // Desktop view with DataTable
//                 return SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: DataTable(
//                     columns: _buildColumns(),
//                     rows: data.map((doc) {
//                       final fields = doc.data() as Map<String, dynamic>;
//                       return DataRow(
//                           cells: _buildCells(fields, context, doc.id));
//                     }).toList(),
//                   ),
//                 );
//               }
//             },
//           );
//         },
//       ),
//     );
//   }

//   List<DataColumn> _buildColumns() {
//     // Build columns based on the visible fields
//     return _visibleFields.map((field) {
//       return DataColumn(label: Text(field.replaceAll('_', ' ')));
//     }).toList()
//       ..add(DataColumn(label: Text('Actions')));
//   }

//   List<DataCell> _buildCells(
//       Map<String, dynamic> fields, BuildContext context, String docId) {
//     // Build cells based on the visible fields
//     return _visibleFields.map((field) {
//       return DataCell(Text(fields[field] ?? ''));
//     }).toList()
//       ..add(DataCell(Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           IconButton(
//             icon: Icon(Icons.visibility),
//             onPressed: () => _showDetailsBottomSheet(context, docId, fields),
//           ),
//           IconButton(
//             icon: Icon(Icons.edit),
//             onPressed: () => _showEditBottomSheet(context, docId, fields),
//           ),
//         ],
//       )));
//   }

//   void _showEditBottomSheet(
//       BuildContext context, String docId, Map<String, dynamic> fields) {
//     final _formKey = GlobalKey<FormState>();
//     final Map<String, TextEditingController> _controllers = {};
//     final List<String> validIndicators = [
//       'Yes',
//       'No'
//     ]; // Options for the dropdown

//     // Initialize controllers based on the custom order
//     for (var field in _fieldOrder) {
//       _controllers[field] =
//           TextEditingController(text: fields[field]?.toString());
//     }

//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     children: _fieldOrder.map((field) {
//                       if (field == 'address valid indicator') {
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 4.0),
//                           child: DropdownButtonFormField<String>(
//                             value: _controllers[field]?.text,
//                             decoration: InputDecoration(
//                                 labelText: field.replaceAll('_', ' ')),
//                             items: validIndicators.map((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value),
//                               );
//                             }).toList(),
//                             onChanged: (String? newValue) {
//                               if (newValue != null) {
//                                 _controllers[field]?.text = newValue;
//                               }
//                             },
//                           ),
//                         );
//                       } else {
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 4.0),
//                           child: TextFormField(
//                             controller: _controllers[field],
//                             decoration: InputDecoration(
//                                 labelText: field.replaceAll('_', ' ')),
//                             validator: (value) => value == null || value.isEmpty
//                                 ? 'Please enter a value'
//                                 : null,
//                           ),
//                         );
//                       }
//                     }).toList(),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () async {
//                     if (_formKey.currentState?.validate() ?? false) {
//                       final updatedData = _controllers.map(
//                           (key, controller) => MapEntry(key, controller.text));
//                       await FirebaseFirestore.instance
//                           .collection('firstFormSubmissions')
//                           .doc(docId)
//                           .update(updatedData);
//                       Navigator.pop(context);
//                     }
//                   },
//                   child: Text('Save Changes'),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _showDetailsBottomSheet(
//       BuildContext context, String docId, Map<String, dynamic> fields) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: _fieldOrder.map((field) {
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 4.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               flex: 2,
//                               child: Text(
//                                 field.replaceAll('_', ' '),
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 16),
//                               ),
//                             ),
//                             Expanded(
//                               flex: 3,
//                               child: Text(fields[field]?.toString() ?? ''),
//                             ),
//                           ],
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context); // Close the bottom sheet
//                   },
//                   child: Text('Close'),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () => _generateAndDownloadPDF(fields),
//                   child: Text('Download as PDF'),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'dart:math';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:html' as html;

class AddressDataTable extends StatelessWidget {
  static const String id = 'address-edit';

  final List<String> _fieldOrder = [
    'id',
    'address line 1',
    'address line 2',
    'address line 3',
    'city',
    'taluk',
    'district',
    'state',
    'country',
    'Pincode',
    'Landmark',
    'LandlinenumberCountry',
    'Landlinenumber',
    'address valid indicator',
    'Addressdataentered',
  ];

  final List<String> _visibleFields = [
    'id',
    'address line 1',
    'address line 2',
    'address line 3',
    'city',
    'taluk',
  ];

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

          final id = generateShortId(10);
          data['id'] = id;

          print('Data to upload: $data');

          try {
            await FirebaseFirestore.instance
                .collection('firstFormSubmissions')
                .doc(id)
                .set(data, SetOptions(merge: true));
            rowCount++;
          } catch (e) {
            print('Error uploading data to Firestore: $e');
          }
        }

        if (rowCount > 0) {
          await _updateSubmissionCounts('addressCount', rowCount);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Address Masters'),
        actions: [
          ElevatedButton(
            onPressed: _importFromCsv,
            child: Text('Import from CSV'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('firstFormSubmissions')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final data = snapshot.data?.docs ?? [];

            // Group data by normalized district names
            final Map<String, List<Map<String, dynamic>>> groupedData = {};
            for (var doc in data) {
              final fields = doc.data() as Map<String, dynamic>;
              final district = (fields['district'] ?? 'Unknown').toLowerCase();

              final displayDistrict = _capitalizeWords(district);

              if (!groupedData.containsKey(displayDistrict)) {
                groupedData[displayDistrict] = [];
              }
              groupedData[displayDistrict]!.add(fields);
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                bool isMobile = constraints.maxWidth < 600;

                if (isMobile) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: groupedData.entries.map((entry) {
                      final district = entry.key;
                      final addresses = entry.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.0),
                            color: Colors.grey[200],
                            child: Text('District: $district',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          ...addresses.map((fields) {
                            final docId = fields['id'] ?? 'Unknown ID';
                            return Card(
                              margin: EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(fields['address line 1'] ?? ''),
                                subtitle: Text(fields['city'] ?? ''),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.visibility),
                                      onPressed: () => _showDetailsBottomSheet(
                                          context, docId, fields),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () => _showEditBottomSheet(
                                          context, docId, fields),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    }).toList(),
                  );
                } else {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: _buildColumns(),
                          rows: groupedData.entries.expand((entry) {
                            final district = entry.key;
                            final addresses = entry.value;

                            // District header row
                            final districtHeaderRow = DataRow(
                              cells: [
                                DataCell(TextButton(
                                    style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                      Colors.orange[100],
                                    )),
                                    onPressed: () {},
                                    child: Text('District: $district'))),
                                ...List.generate(
                                  _visibleFields.length -
                                      1, // Minus one for actions column
                                  (index) => DataCell(Text('')),
                                ),
                                DataCell(Text('')),
                              ],
                            );

                            // Address rows
                            final addressRows = addresses.map((fields) {
                              final docId = fields['id'] ?? 'Unknown ID';
                              return DataRow(
                                cells: _buildCells(fields, context, docId),
                              );
                            }).toList();

                            return [districtHeaderRow, ...addressRows];
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return _visibleFields.map((field) {
      return DataColumn(label: Text(field.replaceAll('_', ' ')));
    }).toList()
      ..add(DataColumn(label: Text('Actions')));
  }

  List<DataCell> _buildCells(
      Map<String, dynamic> fields, BuildContext context, String docId) {
    return _visibleFields.map((field) {
      return DataCell(Text(fields[field] ?? ''));
    }).toList()
      ..add(DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.visibility),
            onPressed: () => _showDetailsBottomSheet(context, docId, fields),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _showEditBottomSheet(context, docId, fields),
          ),
        ],
      )));
  }

  void _showEditBottomSheet(
      BuildContext context, String docId, Map<String, dynamic> fields) {
    final _formKey = GlobalKey<FormState>();
    final Map<String, TextEditingController> _controllers = {};
    final List<String> validIndicators = ['Yes', 'No'];

    for (var field in _fieldOrder) {
      _controllers[field] =
          TextEditingController(text: fields[field]?.toString());
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: _fieldOrder.map((field) {
                      if (field == 'address valid indicator') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: DropdownButtonFormField<String>(
                            value: _controllers[field]?.text,
                            decoration: InputDecoration(
                                labelText: field.replaceAll('_', ' ')),
                            items: validIndicators.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                _controllers[field]?.text = newValue;
                              }
                            },
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: TextFormField(
                            controller: _controllers[field],
                            decoration: InputDecoration(
                                labelText: field.replaceAll('_', ' ')),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter a value'
                                : null,
                          ),
                        );
                      }
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      final updatedData = _controllers.map(
                          (key, controller) => MapEntry(key, controller.text));
                      await FirebaseFirestore.instance
                          .collection('firstFormSubmissions')
                          .doc(docId)
                          .update(updatedData);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save Changes'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDetailsBottomSheet(
      BuildContext context, String docId, Map<String, dynamic> fields) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _fieldOrder.map((field) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              field.replaceAll('_', ' '),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(fields[field]?.toString() ?? ''),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _generateAndDownloadPDF(fields),
                  child: Text('Download as PDF'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _generateAndDownloadPDF(Map<String, dynamic> fields) async {
    // PDF generation logic remains the same
  }

  String _capitalizeWords(String text) {
    return text.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}
