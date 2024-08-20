import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cms/Pages/editaddress.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  static const String id = "dash-board";

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int sishyasCount = 0;
  int addressCount = 0;
  int bhogamCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchSubmissionCounts();
  }

  Future<void> _fetchSubmissionCounts() async {
    try {
      final doc =
          await _firestore.collection('submissionCounts').doc('counts').get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          sishyasCount = data['sishyasCount'] ?? 0;
          addressCount = data['addressCount'] ?? 0;
          bhogamCount = data['bhogamCount'] ?? 0;
        });
      }
    } catch (e) {
      print('Error fetching submission counts: $e');
    }
  }

  Widget dashboardAnalytis({required String title, required int value}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 300,
        height: 200,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.grey.shade500, blurRadius: 2),
            ],
            borderRadius: BorderRadius.circular(3)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: double.infinity,
                color: Colors.orange,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$value'),
                  IconButton(onPressed: () {}, icon: Icon(Icons.remove_red_eye))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    dashboardAnalytis(
                        title: 'Sishyas Master ', value: sishyasCount),
                    dashboardAnalytis(
                        title: 'Address Master ', value: addressCount),
                    dashboardAnalytis(
                        title: 'Bhogam Master ', value: bhogamCount),
                  ],
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HistoryPage()),
                      );
                    },
                    child: Text('View')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//-----sishya history---

// class HistoryPage extends StatefulWidget {
//   @override
//   _HistoryPageState createState() => _HistoryPageState();
// }

// class _HistoryPageState extends State<HistoryPage> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   String? _selectedDistrict;

//   // Fetch available districts
//   Future<List<String>> _fetchDistricts() async {
//     final snapshot = await _firestore.collection('firstFormSubmissions').get();
//     final districts = <String>{};

//     for (var doc in snapshot.docs) {
//       if (doc.data().containsKey('district')) {
//         districts.add(doc['district']);
//       }
//     }

//     return districts.toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('History')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             FutureBuilder<List<String>>(
//               future: _fetchDistricts(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 final districts = snapshot.data!;

//                 return DropdownButton<String>(
//                   hint: Text('Select District'),
//                   value: _selectedDistrict,
//                   items: districts.map((district) {
//                     return DropdownMenuItem<String>(
//                       value: district,
//                       child: Text(district),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedDistrict = value;
//                     });
//                   },
//                 );
//               },
//             ),
//             SizedBox(height: 16),
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: _firestore
//                     .collection('firstFormSubmissions')
//                     .where('district',
//                         isEqualTo: _selectedDistrict) // Filter by district
//                     .snapshots(),
//                 builder: (context, firstFormSnapshot) {
//                   if (!firstFormSnapshot.hasData) {
//                     return Center(child: CircularProgressIndicator());
//                   }

//                   final firstFormEntries = firstFormSnapshot.data!.docs;

//                   return StreamBuilder<QuerySnapshot>(
//                     stream: _firestore
//                         .collection('secondFormSubmissions')
//                         .where('district',
//                             isEqualTo: _selectedDistrict) // Filter by district
//                         .snapshots(),
//                     builder: (context, secondFormSnapshot) {
//                       if (!secondFormSnapshot.hasData) {
//                         return Center(child: CircularProgressIndicator());
//                       }

//                       final secondFormEntries = secondFormSnapshot.data!.docs;

//                       // Group submissions by ID
//                       Map<String, List<Map<String, String>>>
//                           groupedSubmissions = {};

//                       for (var entry in firstFormEntries) {
//                         String id = entry['id'];
//                         groupedSubmissions[id] =
//                             []; // Initialize with an empty list for sub-entries
//                       }

//                       for (var entry in secondFormEntries) {
//                         String id = entry['id'];
//                         if (groupedSubmissions.containsKey(id)) {
//                           groupedSubmissions[id]!.add({
//                             'subId': entry['subId'],
//                             'Sishya Type': entry['Sishya Type'],
//                             'Name': entry['Name'],
//                           });
//                         }
//                       }

//                       return ListView(
//                         children: groupedSubmissions.entries.map((group) {
//                           String id = group.key;
//                           List<Map<String, String>> details = group.value;

//                           return Card(
//                             margin: EdgeInsets.symmetric(vertical: 8.0),
//                             child: Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text('ID: $id',
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold)),
//                                   SizedBox(height: 10),
//                                   SingleChildScrollView(
//                                     scrollDirection: Axis.horizontal,
//                                     child: DataTable(
//                                       columnSpacing: 12,
//                                       columns: [
//                                         DataColumn(label: Text('Sub-ID')),
//                                         DataColumn(label: Text('Sishya Type')),
//                                         DataColumn(label: Text('Name')),
//                                       ],
//                                       rows: details.map((detail) {
//                                         return DataRow(
//                                           cells: [
//                                             DataCell(
//                                               ConstrainedBox(
//                                                 constraints: BoxConstraints(
//                                                   maxWidth:
//                                                       100, // Adjust as needed
//                                                 ),
//                                                 child: Text(
//                                                   detail['subId'] ?? '',
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                             ),
//                                             DataCell(
//                                               ConstrainedBox(
//                                                 constraints: BoxConstraints(
//                                                   maxWidth:
//                                                       200, // Adjust as needed
//                                                 ),
//                                                 child: Text(
//                                                   detail['Sishya Type'] ?? '',
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                             ),
//                                             DataCell(
//                                               ConstrainedBox(
//                                                 constraints: BoxConstraints(
//                                                   maxWidth:
//                                                       150, // Adjust as needed
//                                                 ),
//                                                 child: Text(
//                                                   detail['Name'] ?? '',
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         );
//                                       }).toList(),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//-----address history have filter by district---
// class HistoryPage extends StatefulWidget {
//   @override
//   _HistoryPageState createState() => _HistoryPageState();
// }

// class _HistoryPageState extends State<HistoryPage> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   String? _selectedDistrict;

//   Future<List<String>> _fetchDistricts() async {
//     final snapshot = await _firestore.collection('firstFormSubmissions').get();
//     final districts = <String>{};

//     for (var doc in snapshot.docs) {
//       if (doc.data().containsKey('district')) {
//         districts.add(doc['district']);
//       }
//     }

//     return districts.toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('History')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             FutureBuilder<List<String>>(
//               future: _fetchDistricts(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 final districts = snapshot.data!;

//                 return DropdownButton<String>(
//                   hint: Text('Select District'),
//                   value: _selectedDistrict,
//                   items: districts.map((district) {
//                     return DropdownMenuItem<String>(
//                       value: district,
//                       child: Text(district),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedDistrict = value;
//                     });
//                   },
//                 );
//               },
//             ),
//             SizedBox(height: 16),
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: _firestore
//                     .collection('firstFormSubmissions')
//                     .where('district', isEqualTo: _selectedDistrict)
//                     .snapshots(),
//                 builder: (context, firstFormSnapshot) {
//                   if (!firstFormSnapshot.hasData) {
//                     return Center(child: CircularProgressIndicator());
//                   }

//                   final firstFormEntries = firstFormSnapshot.data!.docs;

//                   return StreamBuilder<QuerySnapshot>(
//                     stream: _firestore
//                         .collection('secondFormSubmissions')
//                         .snapshots(),
//                     builder: (context, secondFormSnapshot) {
//                       if (!secondFormSnapshot.hasData) {
//                         return Center(child: CircularProgressIndicator());
//                       }

//                       final secondFormEntries = secondFormSnapshot.data!.docs;

//                       Map<String, List<Map<String, dynamic>>>
//                           groupedSubmissions = {};

//                       for (var entry in firstFormEntries) {
//                         String id = entry['id'];
//                         groupedSubmissions[id] = [];
//                       }

//                       for (var entry in secondFormEntries) {
//                         String id = entry['id']; // Use custom ID
//                         if (groupedSubmissions.containsKey(id)) {
//                           groupedSubmissions[id]!
//                               .add(entry.data() as Map<String, dynamic>);
//                         }
//                       }

//                       return ListView(
//                         children: groupedSubmissions.entries.map((group) {
//                           String id = group.key;
//                           List<Map<String, dynamic>> details = group.value;

//                           return Card(
//                             margin: EdgeInsets.symmetric(vertical: 8.0),
//                             child: Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text('Address ID: $id',
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold)),
//                                   SizedBox(height: 10),
//                                   SingleChildScrollView(
//                                     scrollDirection: Axis.horizontal,
//                                     child: DataTable(
//                                       columnSpacing: 12,
//                                       columns: [
//                                         DataColumn(label: Text('Sishya ID')),
//                                         DataColumn(label: Text('SishyaType')),
//                                         DataColumn(label: Text('Name')),
//                                         DataColumn(label: Text('DOB')),
//                                         DataColumn(
//                                             label: Text('Samasreyanam Date')),
//                                         DataColumn(label: Text('Mobile')),
//                                         DataColumn(label: Text('Actions')),
//                                       ],
//                                       rows: details.map((detail) {
//                                         String subId = detail['subId'] ?? '';
//                                         return DataRow(
//                                           cells: [
//                                             DataCell(
//                                               ConstrainedBox(
//                                                 constraints: BoxConstraints(
//                                                   maxWidth: 100,
//                                                 ),
//                                                 child: Text(
//                                                   subId,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                             ),
//                                             DataCell(
//                                               ConstrainedBox(
//                                                 constraints: BoxConstraints(
//                                                   maxWidth: 200,
//                                                 ),
//                                                 child: Text(
//                                                   detail['SishyaType'] ?? '',
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                             ),
//                                             DataCell(
//                                               ConstrainedBox(
//                                                 constraints: BoxConstraints(
//                                                   maxWidth: 150,
//                                                 ),
//                                                 child: Text(
//                                                   detail['Name'] ?? '',
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                             ),
//                                             DataCell(
//                                               ConstrainedBox(
//                                                 constraints: BoxConstraints(
//                                                   maxWidth: 150,
//                                                 ),
//                                                 child: Text(
//                                                   detail['DOB'] ?? '',
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                             ),
//                                             DataCell(
//                                               ConstrainedBox(
//                                                 constraints: BoxConstraints(
//                                                   maxWidth: 150,
//                                                 ),
//                                                 child: Text(
//                                                   detail['Samasreyanam Date'] ??
//                                                       '',
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                             ),
//                                             DataCell(
//                                               ConstrainedBox(
//                                                 constraints: BoxConstraints(
//                                                   maxWidth: 150,
//                                                 ),
//                                                 child: Text(
//                                                   detail['Mobileone'] ?? '',
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                             ),
//                                             DataCell(
//                                               IconButton(
//                                                 icon: Icon(Icons.edit),
//                                                 onPressed: () {
//                                                   // Pass the correct ID and subId
//                                                   _showEditBottomSheet(
//                                                     id,
//                                                     subId,
//                                                     detail,
//                                                   );
//                                                 },
//                                               ),
//                                             ),
//                                           ],
//                                         );
//                                       }).toList(),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showEditBottomSheet(
//       String id, String subId, Map<String, dynamic> detail) {
//     final nameController = TextEditingController(text: detail['Name']);
//     final sishyaTypeController =
//         TextEditingController(text: detail['SishyaType']);
//     final dobController = TextEditingController(text: detail['DOB']);
//     final samasreyanamDateController =
//         TextEditingController(text: detail['Samasreyanam Date']);
//     final mobileController = TextEditingController(text: detail['Mobileone']);

//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: nameController,
//                 decoration: InputDecoration(labelText: 'Name'),
//               ),
//               TextField(
//                 controller: sishyaTypeController,
//                 decoration: InputDecoration(labelText: 'Sishya Type'),
//               ),
//               TextField(
//                 controller: dobController,
//                 decoration: InputDecoration(labelText: 'DOB'),
//               ),
//               TextField(
//                 controller: samasreyanamDateController,
//                 decoration: InputDecoration(labelText: 'Samasreyanam Date'),
//               ),
//               TextField(
//                 controller: mobileController,
//                 decoration: InputDecoration(labelText: 'Mobile'),
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       _updateEntry(
//                         id,
//                         subId,
//                         nameController.text,
//                         sishyaTypeController.text,
//                         dobController.text,
//                         samasreyanamDateController.text,
//                         mobileController.text,
//                       );
//                       Navigator.pop(context);
//                     },
//                     child: Text('Save'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: Text('Cancel'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _updateEntry(
//     String id,
//     String subId,
//     String name,
//     String sishyaType,
//     String dob,
//     String samasreyanamDate,
//     String mobile,
//   ) {
//     // Find the document based on the custom ID and subId
//     _firestore
//         .collection('secondFormSubmissions')
//         .where('id', isEqualTo: id)
//         .where('subId', isEqualTo: subId)
//         .get()
//         .then((snapshot) {
//       if (snapshot.docs.isNotEmpty) {
//         DocumentReference documentRef = snapshot.docs.first.reference;
//         return documentRef.update({
//           'Name': name,
//           'SishyaType': sishyaType,
//           'DOB': dob,
//           'Samasreyanam Date': samasreyanamDate,
//           'Mobileone': mobile,
//         }).then((_) {
//           print("Document successfully updated!");
//         }).catchError((error) {
//           print("Failed to update document: $error");
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Failed to update document: $error")),
//           );
//         });
//       } else {
//         print("Document not found!");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Document not found!")),
//         );
//       }
//     }).catchError((error) {
//       print("Failed to retrieve document: $error");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to retrieve document: $error")),
//       );
//     });
//   }
// }

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
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
      appBar: AppBar(title: Text('History')),
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

                      return ListView(
                        children: groupedSubmissions.entries.map((group) {
                          String id = group.key;
                          List<Map<String, dynamic>> details = group.value;

                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                        DataColumn(label: Text('Sishya ID')),
                                        DataColumn(label: Text('SishyaType')),
                                        DataColumn(label: Text('Name')),
                                        DataColumn(label: Text('DOB')),
                                        DataColumn(
                                            label: Text('Samasreyanam Date')),
                                        DataColumn(label: Text('Mobile')),
                                        DataColumn(label: Text('Actions')),
                                      ],
                                      rows: details.map((detail) {
                                        String subId = detail['subId'] ?? '';
                                        return DataRow(
                                          cells: [
                                            DataCell(
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth: 100,
                                                ),
                                                child: Text(
                                                  subId,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth: 200,
                                                ),
                                                child: Text(
                                                  detail['SishyaType'] ?? '',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth: 150,
                                                ),
                                                child: Text(
                                                  detail['Name'] ?? '',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth: 150,
                                                ),
                                                child: Text(
                                                  detail['DOB'] ?? '',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth: 150,
                                                ),
                                                child: Text(
                                                  detail['Samasreyanam Date'] ??
                                                      '',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth: 150,
                                                ),
                                                child: Text(
                                                  detail['Mobileone'] ?? '',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Row(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(Icons.edit),
                                                    onPressed: () {
                                                      _showEditBottomSheet(
                                                        id,
                                                        subId,
                                                        detail,
                                                      );
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon:
                                                        Icon(Icons.visibility),
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
    final predefinedSetIDs = ['Set 1', 'Set 2'];
    final predefinedSishyavalidindicator = ['YES', 'NO'];
    final predefinedIsSishyathefamilypointofcontact = ['YES', 'NO'];

    // Ensure a valid default value for the dropdown
    String selectedSetID = detail['SetID'] ?? predefinedSetIDs.first;
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
                DropdownButtonFormField<String>(
                  value: predefinedSetIDs.contains(selectedSetID)
                      ? selectedSetID
                      : predefinedSetIDs.first,
                  items: predefinedSetIDs.map((setID) {
                    return DropdownMenuItem<String>(
                      value: setID,
                      child: Text(setID),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSetID = value!;
                    });
                  },
                  decoration: InputDecoration(labelText: 'SetID'),
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
                          selectedSetID,
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
                  _buildDetailRow('Alias Extra', detail['AliasExtra identity']),
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
                  _buildDetailRow(
                      'Sishya Valid Indicator', detail['Sishyavalidindicator']),
                  _buildDetailRow('Sishya Data Entered By',
                      detail['Sishya data entered by']),
                  _buildDetailRow('SetID', detail['SetID']),
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
    String setID,
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
          'SetID': setID,
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
