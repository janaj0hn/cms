import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cms/Pages/sishyas.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  static const String id = "dash-board";

  Widget dashboardAnalytis({required String title, required String value}) {
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
                    style: GoogleFonts.hindSiliguri(),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(value),
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
                    dashboardAnalytis(title: 'Sishyas Master ', value: '0'),
                    dashboardAnalytis(title: 'Address Master ', value: '0'),
                    dashboardAnalytis(title: 'Bhogam Master ', value: '0'),
                  ],
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HistoryPage(),
                          ));
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
class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _selectedDistrict;

  // Fetch available districts
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
                        .snapshots(), // Removed filter to get all documents
                    builder: (context, secondFormSnapshot) {
                      if (!secondFormSnapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final secondFormEntries = secondFormSnapshot.data!.docs;

                      // Group submissions by ID
                      Map<String, List<Map<String, String>>>
                          groupedSubmissions = {};

                      for (var entry in firstFormEntries) {
                        String id = entry['id'];
                        groupedSubmissions[id] =
                            []; // Initialize with an empty list for sub-entries
                      }

                      for (var entry in secondFormEntries) {
                        String id = entry['id'];
                        if (groupedSubmissions.containsKey(id)) {
                          groupedSubmissions[id]!.add({
                            'subId': entry['subId'] ?? '',
                            'Sishya Type': entry['Sishya Type'] ?? '',
                            'Name': entry['Name'] ?? '',
                            'DOB': entry['DOB'] ?? '',
                            'Samasreyanam Date':
                                entry['Samasreyanam Date'] ?? '',
                            'Mobileone': entry['Mobileone'] ?? '',
                          });
                        }
                      }

                      return ListView(
                        children: groupedSubmissions.entries.map((group) {
                          String id = group.key;
                          List<Map<String, String>> details = group.value;

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
                                        DataColumn(label: Text('Sishya Type')),
                                        DataColumn(label: Text('Name')),
                                        DataColumn(label: Text('DOB')),
                                        DataColumn(
                                            label: Text('Samasreyanam Date')),
                                        DataColumn(label: Text('Mobile')),
                                      ],
                                      rows: details.map((detail) {
                                        return DataRow(
                                          cells: [
                                            DataCell(
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth:
                                                      100, // Adjust as needed
                                                ),
                                                child: Text(
                                                  detail['subId'] ?? '',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth:
                                                      200, // Adjust as needed
                                                ),
                                                child: Text(
                                                  detail['Sishya Type'] ?? '',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth:
                                                      150, // Adjust as needed
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
                                                  maxWidth:
                                                      150, // Adjust as needed
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
                                                  maxWidth:
                                                      150, // Adjust as needed
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
                                                  maxWidth:
                                                      150, // Adjust as needed
                                                ),
                                                child: Text(
                                                  detail['Mobileone'] ?? '',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
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
}
