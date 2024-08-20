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
