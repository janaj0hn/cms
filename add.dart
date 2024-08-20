// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AddressDataTable extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Address Data Table')),
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
//                 return ListView(
//                   children: data.map((doc) {
//                     final fields = doc.data() as Map<String, dynamic>;
//                     return Card(
//                       margin: const EdgeInsets.symmetric(
//                           vertical: 8.0, horizontal: 16.0),
//                       child: ListTile(
//                         contentPadding: const EdgeInsets.all(16.0),
//                         title: Text(fields['id'] ?? ''),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                                 'Address Line 1: ${fields['address line 1'] ?? ''}'),
//                             Text('City: ${fields['city'] ?? ''}'),
//                             Text('State: ${fields['state'] ?? ''}'),
//                             // Add more fields as needed
//                           ],
//                         ),
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
//     return [
//       DataColumn(label: Text('ID')),
//       DataColumn(label: Text('Address Line 1')),
//       DataColumn(label: Text('Address Line 2')),
//       DataColumn(label: Text('Address Line 3')),
//       DataColumn(label: Text('City')),
//       DataColumn(label: Text('Taluk')),
//       DataColumn(label: Text('District')),
//       DataColumn(label: Text('State')),
//       DataColumn(label: Text('Country')),
//       DataColumn(label: Text('Pincode')),
//       DataColumn(label: Text('Landmark')),
//       DataColumn(label: Text('Landline Country')),
//       DataColumn(label: Text('Landline Number')),
//       DataColumn(label: Text('Valid Indicator')),
//       DataColumn(label: Text('Entered By')),
//       DataColumn(label: Text('Actions')), // Column for actions
//     ];
//   }

//   List<DataCell> _buildCells(
//       Map<String, dynamic> fields, BuildContext context, String docId) {
//     return [
//       DataCell(Text(fields['id'] ?? '')),
//       DataCell(Text(fields['address line 1'] ?? '')),
//       DataCell(Text(fields['address line 2'] ?? '')),
//       DataCell(Text(fields['address line 3'] ?? '')),
//       DataCell(Text(fields['city'] ?? '')),
//       DataCell(Text(fields['taluk'] ?? '')),
//       DataCell(Text(fields['district'] ?? '')),
//       DataCell(Text(fields['state'] ?? '')),
//       DataCell(Text(fields['country'] ?? '')),
//       DataCell(Text(fields['Pincode'] ?? '')),
//       DataCell(Text(fields['Landmark'] ?? '')),
//       DataCell(Text(fields['LandlinenumberCountry'] ?? '')),
//       DataCell(Text(fields['Landlinenumber'] ?? '')),
//       DataCell(Text(fields['address valid indicator'] ?? '')),
//       DataCell(Text(fields['Addressdataentered'] ?? '')),
//       DataCell(Row(
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
//       )),
//     ];
//   }

//   void _showEditBottomSheet(
//       BuildContext context, String docId, Map<String, dynamic> fields) {
//     final _formKey = GlobalKey<FormState>();
//     final Map<String, TextEditingController> _controllers = {};

//     for (var key in fields.keys) {
//       _controllers[key] = TextEditingController(text: fields[key].toString());
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
//                     children: _controllers.entries.map((entry) {
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 4.0),
//                         child: TextFormField(
//                           controller: entry.value,
//                           decoration: InputDecoration(labelText: entry.key),
//                           validator: (value) => value == null || value.isEmpty
//                               ? 'Please enter a value'
//                               : null,
//                         ),
//                       );
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
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: fields.entries.map((entry) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 4.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child: Text(
//                           entry.key,
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 3,
//                         child: Text(entry.value.toString()),
//                       ),
//                     ],
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddressDataTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Address Data Table')),
      body: StreamBuilder<QuerySnapshot>(
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

          return LayoutBuilder(
            builder: (context, constraints) {
              bool isMobile = constraints.maxWidth < 600;

              if (isMobile) {
                // Mobile view with ListView
                return ListView(
                  children: data.map((doc) {
                    final fields = doc.data() as Map<String, dynamic>;
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
                                  context, doc.id, fields),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () =>
                                  _showEditBottomSheet(context, doc.id, fields),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              } else {
                // Desktop view with DataTable
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: _buildColumns(),
                    rows: data.map((doc) {
                      final fields = doc.data() as Map<String, dynamic>;
                      return DataRow(
                          cells: _buildCells(fields, context, doc.id));
                    }).toList(),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return [
      DataColumn(label: Text('ID')),
      DataColumn(label: Text('Address Line 1')),
      DataColumn(label: Text('Address Line 2')),
      DataColumn(label: Text('Address Line 3')),
      DataColumn(label: Text('City')),
      DataColumn(label: Text('Taluk')),
      DataColumn(label: Text('District')),
      DataColumn(label: Text('Actions')),
    ];
  }

  List<DataCell> _buildCells(
      Map<String, dynamic> fields, BuildContext context, String docId) {
    return [
      DataCell(Text(fields['id'] ?? '')),
      DataCell(Text(fields['address line 1'] ?? '')),
      DataCell(Text(fields['address line 2'] ?? '')),
      DataCell(Text(fields['address line 3'] ?? '')),
      DataCell(Text(fields['city'] ?? '')),
      DataCell(Text(fields['taluk'] ?? '')),
      DataCell(Text(fields['district'] ?? '')),
      DataCell(Row(
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
      )),
    ];
  }

  void _showEditBottomSheet(
      BuildContext context, String docId, Map<String, dynamic> fields) {
    final _formKey = GlobalKey<FormState>();
    final Map<String, TextEditingController> _controllers = {};
    final List<String> validIndicators = [
      'Yes',
      'No'
    ]; // Options for the dropdown

    for (var key in fields.keys) {
      _controllers[key] = TextEditingController(text: fields[key].toString());
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
                    children: _controllers.entries.map((entry) {
                      if (entry.key == 'address valid indicator') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: DropdownButtonFormField<String>(
                            value: entry.value.text,
                            decoration: InputDecoration(labelText: entry.key),
                            items: validIndicators.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                _controllers[entry.key]?.text = newValue;
                              }
                            },
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: TextFormField(
                            controller: entry.value,
                            decoration: InputDecoration(labelText: entry.key),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: fields.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          entry.key,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(entry.value.toString()),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
