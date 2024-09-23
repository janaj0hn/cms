import 'dart:math';
import 'package:cms/Pages/editaddress.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAddress extends StatefulWidget {
  static const String id = 'address-screen';

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final addressline1Con = TextEditingController();
  final addressline2Con = TextEditingController();
  final addressline3Con = TextEditingController();
  final cityCon = TextEditingController();
  final TalukCon = TextEditingController();
  final DistrictCon = TextEditingController();
  final StateCon = TextEditingController();
  final CountryCon = TextEditingController();
  final PincodeCon = TextEditingController();
  final LandmarkCon = TextEditingController();
  final LandlinenumberCountryCon = TextEditingController();
  final LandlinenumberCon = TextEditingController();
  final AddressdataenteredCon = TextEditingController();
  final addressIdCon = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _dropdownValue = 'No';

  @override
  void initState() {
    super.initState();
    _loadAddressId();
  }

  // Generate a random 10-character alphanumeric string
  String generateShortId(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rand = Random();
    return List.generate(length, (index) => chars[rand.nextInt(chars.length)])
        .join();
  }

  // Load the Address ID from SharedPreferences
  void _loadAddressId() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getString('address_id');
    if (savedId != null) {
      setState(() {
        addressIdCon.text = savedId;
      });
    }
  }

  // Save the Address ID to SharedPreferences
  Future<void> _saveAddressId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('address_id', id);
  }

  // Clear the Address ID from SharedPreferences
  Future<void> _clearAddressId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('address_id');
    setState(() {
      addressIdCon.clear();
    });
  }

  void _checkAndSubmitForm() async {
    final String enteredAddress1 = addressline1Con.text;
    final String enteredAddress2 = addressline2Con.text;
    final String enteredAddress3 = addressline3Con.text;

    if (addressIdCon.text.isEmpty) {
      final String id = generateShortId(10);
      addressIdCon.text = id;
      await _saveAddressId(id);
    }

    final querySnapshot = await _firestore
        .collection('firstFormSubmissions')
        .where('address line 1', isEqualTo: enteredAddress1)
        .where('address line 2', isEqualTo: enteredAddress2)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final document = querySnapshot.docs.first;
      await _firestore
          .collection('firstFormSubmissions')
          .doc(document.id)
          .update({
        'count': FieldValue.increment(1),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('This Address is already entered.')),
      );

      // Navigate to the EditAddress screen
    } else {
      await _firestore.collection('firstFormSubmissions').add({
        'id': addressIdCon.text,
        'address line 1': enteredAddress1,
        'address line 2': enteredAddress2,
        'address line 3': enteredAddress3,
        'taluk': TalukCon.text,
        'city': cityCon.text,
        'district': DistrictCon.text,
        'state': StateCon.text,
        'country': CountryCon.text,
        'Pincode': PincodeCon.text,
        'Landmark': LandmarkCon.text,
        'LandlinenumberCountry': LandlinenumberCountryCon.text,
        'Landlinenumber': LandlinenumberCon.text,
        'address valid indicator': _dropdownValue,
        'Addressdataentered': AddressdataenteredCon.text,
        'count': 1,
      });

      await _updateAddressCount();

      addressline1Con.clear();
      addressline2Con.clear();
      addressline3Con.clear();
    }
  }

  Future<void> _updateAddressCount() async {
    try {
      final docRef = _firestore.collection('submissionCounts').doc('counts');
      final doc = await docRef.get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        int currentCount = data['addressCount'] ?? 0;

        await docRef.update({
          'addressCount': currentCount + 1,
        });
      } else {
        await docRef.set({
          'addressCount': 1,
        });
      }
    } catch (e) {
      print('Error updating address count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('Add Address')),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputField(
                label: 'Address ID',
                content: 'Generated Address ID will appear here',
                controller: addressIdCon,
                readOnly: true, // Make the Address ID field read-only
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _clearAddressId,
                child: Text('Clear Address ID'),
              ),
              SizedBox(height: 25),
              InputField(
                label: 'Address line 1*',
                content: '',
                controller: addressline1Con,
              ),
              SizedBox(height: 25),
              InputField(
                label: 'Address Line 2',
                content: '',
                controller: addressline2Con,
              ),
              SizedBox(height: 25),
              InputField(
                label: 'Address Line 3',
                content: '',
                controller: addressline3Con,
              ),
              SizedBox(height: 25),
              InputField(
                label: 'City/Town*',
                content: '',
                controller: cityCon,
              ),
              SizedBox(height: 25),
              InputField(
                label: 'Taluk',
                content: '',
                controller: TalukCon,
              ),
              SizedBox(height: 25),
              InputField(
                label: 'District',
                content: '',
                controller: DistrictCon,
              ),
              SizedBox(height: 25),
              InputField(
                label: 'State*',
                content: '',
                controller: StateCon,
              ),
              SizedBox(height: 25),
              InputField(
                label: 'Country*',
                content: '',
                controller: CountryCon,
              ),
              SizedBox(height: 25),
              InputField(
                label: 'Pincode/Zipcode*',
                content: '',
                controller: PincodeCon,
              ),
              SizedBox(height: 25),
              InputField(
                label: 'Landmark',
                content: '',
                controller: LandmarkCon,
              ),
              SizedBox(height: 25),
              InputField(
                label: 'Landline number Country',
                content: '',
                controller: LandlinenumberCountryCon,
              ),
              SizedBox(height: 25),
              InputField(
                label: 'Landline Number',
                content: '',
                controller: LandlinenumberCon,
              ),
              SizedBox(height: 25),
              DropdownField(
                label: 'Address valid indicator*',
                items: ['Yes', 'No'],
                selectedValue: _dropdownValue,
                onChanged: (value) {
                  setState(() {
                    _dropdownValue = value!;
                  });
                },
              ),
              SizedBox(height: 25),
              InputField(
                label: 'Address data entered by*',
                content: '',
                controller: AddressdataenteredCon,
              ),
              SizedBox(height: 25),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkAndSubmitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String label;
  final String content;
  final TextEditingController controller;
  final bool readOnly;
  final FormFieldValidator<String>? validator;

  InputField({
    required this.label,
    required this.content,
    required this.controller,
    this.readOnly = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final inputWidth = screenWidth < 600 ? screenWidth * 0.7 : 400.0;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: screenWidth < 600 ? 80.0 : 150.0,
              child: Text(
                "$label",
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            SizedBox(width: 10.0),
            Container(
              width: 240,
              height: 35,
              color: Colors.orange[50],
              child: TextFormField(
                readOnly: readOnly,
                validator: validator,
                controller: controller,
                style: TextStyle(fontSize: 13.0),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  errorStyle: const TextStyle(
                    fontSize: 0.1,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "$content",
                  fillColor: Colors.orange[50],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class DropdownField extends StatelessWidget {
  final String label;
  final List<String> items;
  final String selectedValue;
  final ValueChanged<String?> onChanged;

  DropdownField({
    required this.label,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width < 600 ? 80.0 : 150.0,
          child: Text(
            "$label",
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
        SizedBox(width: 10.0),
        Container(
          width: 240,
          height: 35,
          child: DropdownButtonFormField<String>(
            value: selectedValue,
            onChanged: onChanged,
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange),
                borderRadius: BorderRadius.circular(5.0),
              ),
              filled: true,
              fillColor: Colors.orange[50],
            ),
          ),
        ),
      ],
    );
  }
}


//new code update

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

  // Future<void> _importFromCsv() async {
  //   final uploadInput = html.FileUploadInputElement();
  //   uploadInput.accept = '.csv';

  //   uploadInput.onChange.listen((e) async {
  //     final files = uploadInput.files;
  //     if (files!.isEmpty) {
  //       print('No file selected');
  //       return;
  //     }

  //     final file = files[0];
  //     final reader = html.FileReader();

  //     reader.readAsText(file);

  //     reader.onLoadEnd.listen((e) async {
  //       final content = reader.result as String;
  //       final csvConverter = CsvToListConverter();
  //       final rows = csvConverter.convert(content);

  //       if (rows.isEmpty) {
  //         print('No data found in CSV');
  //         return;
  //       }

  //       final headers = rows.first
  //           .map((header) => _sanitizeFieldName(header.toString()))
  //           .toList();
  //       final dataRows = rows.sublist(1);

  //       int rowCount = 0;

  //       for (var row in dataRows) {
  //         if (row.isEmpty) {
  //           print('Empty row found');
  //           continue;
  //         }

  //         final data = <String, dynamic>{};
  //         for (var i = 0; i < row.length; i++) {
  //           if (i < headers.length) {
  //             data[headers[i]] = row[i]?.toString() ?? '';
  //           }
  //         }

  //         final id = generateShortId(10);
  //         data['id'] = id;

  //         print('Data to upload: $data');

  //         try {
  //           await FirebaseFirestore.instance
  //               .collection('firstFormSubmissions')
  //               .doc(id)
  //               .set(data, SetOptions(merge: true));
  //           rowCount++;
  //         } catch (e) {
  //           print('Error uploading data to Firestore: $e');
  //         }
  //       }

  //       if (rowCount > 0) {
  //         await _updateSubmissionCounts('addressCount', rowCount);
  //       }
  //     });
  //   });

  //   uploadInput.click();
  // }
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
        WriteBatch batch =
            FirebaseFirestore.instance.batch(); // Initialize a batch

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

          // Create a document reference and add to batch
          DocumentReference docRef = FirebaseFirestore.instance
              .collection('firstFormSubmissions')
              .doc(id);
          batch.set(docRef, data, SetOptions(merge: true));

          rowCount++;

          // Commit the batch every 500 documents or at the end
          if (rowCount % 500 == 0) {
            await batch.commit();
            batch = FirebaseFirestore.instance.batch(); // Reset the batch
          }
        }

        // Commit any remaining documents
        await batch.commit();

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

            final Map<String, List<Map<String, dynamic>>> groupedData = {};
            final data = snapshot.data?.docs ?? [];

            // Group data by normalized district names

            for (var doc in data) {
              final fields = doc.data() as Map<String, dynamic>;
              final district = (fields['district'] ?? 'Unknown').toLowerCase();
              final displayDistrict = _capitalizeWords(district);

              // Store the Firestore document ID in a separate field
              final firestoreId = doc.id; // This is the Firestore ID

              if (!groupedData.containsKey(displayDistrict)) {
                groupedData[displayDistrict] = [];
              }

              // Ensure custom ID is preserved for display
              fields['custom_id'] = fields['id']; // Your custom ID
              fields['firestore_id'] = firestoreId; // Firestore document ID

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
                            final customId = fields['custom_id'] ??
                                'Unknown ID'; // Display custom ID
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
                                          context,
                                          customId,
                                          fields), // Use custom ID
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () => _showEditBottomSheet(
                                          context,
                                          fields['firestore_id'],
                                          fields), // Use Firestore ID for editing
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
                                DataCell(Text('District: $district')),
                                ...List.generate(_visibleFields.length - 1,
                                    (index) => DataCell(Text(''))),
                                DataCell(Text('')),
                              ],
                            );

                            // Address rows
                            final addressRows = addresses.map((fields) {
                              final customId = fields['custom_id'] ??
                                  'Unknown ID'; // Display custom ID
                              return DataRow(
                                cells: _buildCells(
                                    fields,
                                    context,
                                    fields[
                                        'firestore_id']), // Use Firestore ID for cells
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
    final List<String> validIndicators = [
      'Yes',
      'No'
    ]; // Options for the dropdown

    // Initialize controllers based on the custom order
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
    print('Updating document with ID: $docId');

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
              ],
            ),
          ),
        );
      },
    );
  }

  String _capitalizeWords(String text) {
    return text.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}
