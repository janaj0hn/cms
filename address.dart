// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:random_string/random_string.dart';

// class AddAddress extends StatefulWidget {
//   AddAddress({super.key});
//   static const String id = 'address-screen';

//   @override
//   State<AddAddress> createState() => _AddAddressState();
// }

// class _AddAddressState extends State<AddAddress> {
//   final List<String> _dropdownItems = ['Chennai', 'Madurai'];
//   String _selectedValue = 'Chennai';

//   void _handleCreateNew(String newOption) {
//     setState(() {
//       _dropdownItems.add(newOption); // Add the new option to the list
//       _selectedValue = newOption; // Optionally select the new option
//     });
//   }

//   final _formKey = GlobalKey<FormState>();
//   final addressline1Con = TextEditingController();
//   final addressline2Con = TextEditingController();
//   final addressline3Con = TextEditingController();
//   final cityCon = TextEditingController();
//   final TalukCon = TextEditingController();
//   final DistrictCon = TextEditingController();
//   final StateCon = TextEditingController();
//   final CountryCon = TextEditingController();
//   final PincodeCon = TextEditingController();
//   final LandmarkCon = TextEditingController();
//   final LandlinenumberCountryCon = TextEditingController();
//   final LandlinenumberCon = TextEditingController();
//   final AddressdataenteredCon = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     // Get screen width
//     final screenWidth = MediaQuery.of(context).size.width;
//     return SafeArea(
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(
//                 horizontal: screenWidth * 0.1, vertical: 40),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Add Address',
//                     style: GoogleFonts.hindSiliguri(fontSize: 26),
//                   ),
//                   SizedBox(height: 35),
//                   InputField(
//                     controller: addressline1Con,
//                     label: 'Address Line 1*',
//                     content: '',
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'This field is mandatory. Enter a value.'; // Validation message
//                       }
//                       return null; // Validation passed
//                     },
//                   ),
//                   SizedBox(height: 25),
//                   InputField(
//                     label: 'Address Line 2',
//                     content: '',
//                     controller: addressline2Con,
//                   ),
//                   SizedBox(height: 25),
//                   InputField(
//                     label: 'Address Line 3',
//                     content: '',
//                     controller: addressline3Con,
//                   ),
//                   SizedBox(height: 25),
//                   InputField(
//                     label: 'City/Town*',
//                     content: '',
//                     controller: cityCon,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'This field is mandatory. Enter a value.'; // Validation message
//                       }
//                       return null; // Validation passed
//                     },
//                   ),
//                   SizedBox(height: 25),
//                   InputField(
//                     label: 'Taluk',
//                     content: '',
//                     controller: TalukCon,
//                   ),
//                   SizedBox(height: 25),
//                   InputField(
//                     label: 'District',
//                     content: '',
//                     controller: DistrictCon,
//                   ),
//                   SizedBox(height: 25),
//                   // DropdownFieldC(
//                   //     label: 'Select State',
//                   //     items: _dropdownItems,
//                   //     selectedValue: _selectedValue,
//                   //     onCreateNew: _handleCreateNew),
//                   // SizedBox(height: 25),
//                   InputField(
//                     label: 'State*',
//                     content: '',
//                     controller: StateCon,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'This field is mandatory. Enter a value.'; // Validation message
//                       }
//                       return null; // Validation passed
//                     },
//                   ),
//                   SizedBox(height: 25),
//                   InputField(
//                     label: 'Country*',
//                     content: '',
//                     controller: CountryCon,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'This field is mandatory. Enter a value.'; // Validation message
//                       }
//                       return null; // Validation passed
//                     },
//                   ),
//                   SizedBox(height: 25),
//                   InputField(
//                     label: 'Pincode/Zipcode*',
//                     content: '',
//                     controller: PincodeCon,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'This field is mandatory. Enter a value.'; // Validation message
//                       }
//                       return null; // Validation passed
//                     },
//                   ),
//                   SizedBox(height: 25),
//                   InputField(
//                     label: 'Landmark',
//                     content: '',
//                     controller: LandmarkCon,
//                   ),
//                   SizedBox(height: 25),
//                   InputField(
//                     label: 'Landline number Country/STD code',
//                     content: '',
//                     controller: LandlinenumberCountryCon,
//                   ),
//                   SizedBox(height: 25),
//                   InputField(
//                     label: 'Landline number',
//                     content: '',
//                     controller: LandlinenumberCon,
//                   ),
//                   SizedBox(height: 25),
//                   DropdownField(
//                     label: 'Address valid indicator*',
//                     items: [
//                       'Yes',
//                       'No',
//                     ], // Sample items
//                     selectedValue: 'No', // Initial selected value
//                   ),
//                   SizedBox(height: 25),
//                   InputField(
//                     label: 'Address data entered by*',
//                     content: '',
//                     controller: AddressdataenteredCon,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'This field is mandatory. Enter a value.'; // Validation message
//                       }
//                       return null; // Validation passed
//                     },
//                   ),
//                   SizedBox(
//                     height: 40,
//                   ),
//                   Row(
//                     children: [
//                       TextButton(
//                           style: ButtonStyle(
//                               backgroundColor:
//                                   WidgetStatePropertyAll(Colors.orange[700]),
//                               shape: WidgetStatePropertyAll(
//                                   BeveledRectangleBorder()),
//                               elevation: WidgetStatePropertyAll(10.0)),
//                           onPressed: () {
//                             if (_formKey.currentState?.validate() ?? false) {
//                               // Form is valid, handle submission

//                               final addressid = randomAlphaNumeric(10);
//                               print("$addressid");
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(content: Text('Processing Data')),
//                               );
//                               // Perform form submission logic here
//                             }
//                           },
//                           child: Text(
//                             'SUBMIT',
//                             style: TextStyle(color: Colors.white),
//                           )),
//                       SizedBox(
//                         width: 60,
//                       ),
//                       TextButton(
//                           style: ButtonStyle(
//                               backgroundColor:
//                                   WidgetStatePropertyAll(Colors.white),
//                               shape: WidgetStatePropertyAll(
//                                   BeveledRectangleBorder())),
//                           onPressed: () {},
//                           child: Text(
//                             'RESET',
//                             style: TextStyle(color: Colors.red),
//                           )),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cms/Pages/sishyas.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class InputField extends StatelessWidget {
  final String label;
  final String content;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;

  InputField(
      {required this.label,
      required this.content,
      required this.controller,
      this.validator});

  @override
  Widget build(BuildContext context) {
    // Get screen width
    final screenWidth = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // For mobile view, adapt the width; for desktop, use fixed width
        final inputWidth = screenWidth < 600 ? screenWidth * 0.7 : 00.0;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: screenWidth < 600
                  ? 80.0
                  : 150.0, // Adjust label width based on screen size
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

// class DropdownFieldC extends StatefulWidget {
//   final String label;
//   final List<String> items;
//   final String selectedValue;
//   final Function(String) onCreateNew; // Callback to handle new option creation

//   DropdownFieldC({
//     required this.label,
//     required this.items,
//     required this.selectedValue,
//     required this.onCreateNew,
//   });

//   @override
//   _DropdownFieldCState createState() => _DropdownFieldCState();
// }

// class _DropdownFieldCState extends State<DropdownFieldC> {
//   late String _selectedValue;

//   @override
//   void initState() {
//     super.initState();
//     _selectedValue = widget.selectedValue;
//   }

//   void _handleCreateNew() async {
//     String? newOption = await showDialog<String>(
//       context: context,
//       builder: (BuildContext context) {
//         final TextEditingController _controller = TextEditingController();
//         return AlertDialog(
//           title: Text('Enter New Option'),
//           content: TextField(
//             controller: _controller,
//             autofocus: true,
//             decoration: InputDecoration(hintText: 'New Option'),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Create'),
//               onPressed: () {
//                 Navigator.of(context).pop(_controller.text);
//               },
//             ),
//           ],
//         );
//       },
//     );

//     if (newOption != null && newOption.isNotEmpty) {
//       widget.onCreateNew(newOption); // Pass the new option to the parent
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Padding(
//       padding: EdgeInsets.only(bottom: 20.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           SizedBox(
//             width: screenWidth < 600 ? 80.0 : 150.0,
//             child: Text(
//               widget.label,
//               textAlign: TextAlign.left,
//               style: TextStyle(color: Colors.black),
//             ),
//           ),
//           SizedBox(width: 10.0),
//           Container(
//             width: 240,
//             height: 35,
//             color: Colors.orange[50],
//             child: DropdownButton<String>(
//               value: _selectedValue,
//               items: [...widget.items, 'Add New Option'].map((String item) {
//                 return DropdownMenuItem<String>(
//                   value: item,
//                   child: Text(item),
//                 );
//               }).toList(),
//               onChanged: (String? newValue) {
//                 if (newValue == 'Add New Option') {
//                   _handleCreateNew();
//                 } else {
//                   setState(() {
//                     _selectedValue = newValue!;
//                   });
//                 }
//               },
//               underline: SizedBox(),
//               isExpanded: true,
//               hint: Padding(
//                 padding: EdgeInsets.all(10.0),
//                 child: Text(
//                   _selectedValue,
//                   style: TextStyle(fontSize: 14.0),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

// }

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

  final uuid = Uuid();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _dropdownValue = 'No';

  void _checkAndSubmitForm() async {
    final String enteredAddress1 = addressline1Con.text;
    final String enteredAddress2 = addressline2Con.text;
    final String enteredAddress3 = addressline2Con.text;

    // Check if the name and age already exist in Firestore
    final querySnapshot = await _firestore
        .collection('firstFormSubmissions')
        .where('address line 1', isEqualTo: enteredAddress1)
        .where('address line 2', isEqualTo: enteredAddress2)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Name and age already exist, increment the count
      final document = querySnapshot.docs.first;
      await _firestore
          .collection('firstFormSubmissions')
          .doc(document.id)
          .update({
        'count': FieldValue.increment(1),
      });

      // Show a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('This Address already entered.')),
      );
    } else {
      // Name and age don't exist, create a new document
      final String id = uuid.v4();
      await _firestore.collection('firstFormSubmissions').add({
        'id': id,
        'address line 1': enteredAddress1,
        'address line 2': enteredAddress2,
        'address line 3': enteredAddress3,
        'taluk': TalukCon.text,
        'city': cityCon.text,
        'district': DistrictCon.text,
        'state': StateCon.text,
        'country': CountryCon.text,
        'Pincode': PincodeCon.text,
        'LandmarkCon': LandmarkCon.text,
        'LandlinenumberCountry': LandlinenumberCountryCon.text,
        'LandlinenumberCon': LandlinenumberCon.text,
        'address valid indicator': _dropdownValue,
        'AddressdataenteredCon': AddressdataenteredCon.text,

        'count': 1, // Initialize count to 1
      });

      addressline1Con.clear();
      addressline2Con.clear();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SishyasScreen(existingId: id)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('First Form')),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputField(
                  label: 'Address line 1*',
                  content: '',
                  controller: addressline1Con),
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

class DropdownField extends StatefulWidget {
  final String label;
  final List<String> items;
  final String selectedValue;
  final ValueChanged<String?> onChanged; // Add this callback

  DropdownField({
    required this.label,
    required this.items,
    required this.selectedValue,
    required this.onChanged, // Initialize callback
  });

  @override
  _DropdownFieldState createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final dropdownWidth = screenWidth < 600 ? screenWidth * 0.7 : 400.0;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: screenWidth < 600 ? 80.0 : 150.0,
              child: Text(
                widget.label,
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(width: 10.0),
            Container(
              width: 240,
              height: 35,
              color: Colors.orange[50],
              child: DropdownButton<String>(
                value: _selectedValue,
                items: widget.items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedValue = newValue!;
                    widget.onChanged(newValue); // Notify parent of change
                  });
                },
                underline: SizedBox(),
                isExpanded: true,
                hint: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    _selectedValue,
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
