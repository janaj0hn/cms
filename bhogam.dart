import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AnotherForm extends StatefulWidget {
  @override
  _AnotherFormState createState() => _AnotherFormState();
}

class _AnotherFormState extends State<AnotherForm> {
  String? selectedSubId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Another Form')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream:
                  _firestore.collection('secondFormSubmissions').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                final items = snapshot.data!.docs.map((doc) {
                  return DropdownMenuItem<String>(
                    value: doc['subId'],
                    child: Text(doc['subId']),
                  );
                }).toList();

                return DropdownButton<String>(
                  value: selectedSubId,
                  hint: Text('Select Sub ID'),
                  items: items,
                  onChanged: (value) {
                    setState(() {
                      selectedSubId = value;
                    });
                  },
                );
              },
            ),
            // Add other fields and widgets here
          ],
        ),
      ),
    );
  }
}
