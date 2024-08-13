// import 'package:cms/Pages/address.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';

// class SishyasScreen extends StatelessWidget {
//   SishyasScreen({super.key});

//   static const String id = "Sishyas-Screen";

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return SafeArea(
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(
//                 horizontal: screenWidth * 0.1, vertical: 40),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Add Sishya',
//                   style: GoogleFonts.hindSiliguri(fontSize: 26),
//                 ),
//                 SizedBox(height: 35),
//                 InputField(label: 'Sishya_iD*', content: '00000'),
//                 SizedBox(height: 25),
//                 InputField(label: 'Sishya Type*', content: ''),
//                 SizedBox(height: 25),
//                 InputField(label: 'Name*', content: ''),
//                 SizedBox(height: 25),
//                 InputField(label: 'Care/of part', content: ''),
//                 SizedBox(height: 25),
//                 InputField(label: 'Alias / Extra identity', content: ''),
//                 SizedBox(height: 25),
//                 PhoneNumberField(
//                   screenWidth: screenWidth,
//                   label: 'Mobile 1*',
//                 ),
//                 SizedBox(height: 25),
//                 PhoneNumberField(
//                   screenWidth: screenWidth,
//                   label: 'Mobile 2',
//                 ),
//                 SizedBox(height: 25),
//                 PhoneNumberField(
//                   screenWidth: screenWidth,
//                   label: 'WhatsApp*',
//                 ),
//                 SizedBox(height: 25),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 InputField(label: 'E-mail', content: ''),
//                 SizedBox(height: 25),
//                 InputField(label: 'Facebook Link', content: ''),
//                 SizedBox(height: 25),
//                 InputField(label: 'Address_ID*', content: ''),
//                 SizedBox(height: 25),
//                 DropdownField(
//                   label: 'Is Sishya the family point of contact*',
//                   items: [
//                     'Yes',
//                     'No',
//                   ], // Sample items
//                   selectedValue: 'No', // Initial selected value
//                 ),
//                 SizedBox(height: 25),
//                 DropdownField(
//                   label: 'Sishya valid indicator?*',
//                   items: [
//                     'Yes',
//                     'No',
//                   ], // Sample items
//                   selectedValue: 'No', // Initial selected value
//                 ),
//                 SizedBox(height: 25),
//                 InputField(label: 'Sishya data entered by*', content: ''),
//                 SizedBox(height: 25),
//                 DropdownField(
//                   label: 'Set ID*',
//                   items: [
//                     'Yes',
//                     'No',
//                   ], // Sample items
//                   selectedValue: 'No', // Initial selected value
//                 ),
//                 SizedBox(
//                   height: 40,
//                 ),
//                 Row(
//                   children: [
//                     TextButton(
//                         style: ButtonStyle(
//                             backgroundColor:
//                                 WidgetStatePropertyAll(Colors.orange[700]),
//                             shape: WidgetStatePropertyAll(
//                                 BeveledRectangleBorder()),
//                             elevation: WidgetStatePropertyAll(10.0)),
//                         onPressed: () {},
//                         child: Text(
//                           'SUBMIT',
//                           style: TextStyle(color: Colors.white),
//                         )),
//                     SizedBox(
//                       width: 60,
//                     ),
//                     TextButton(
//                         style: ButtonStyle(
//                             backgroundColor:
//                                 WidgetStatePropertyAll(Colors.white),
//                             shape: WidgetStatePropertyAll(
//                                 BeveledRectangleBorder())),
//                         onPressed: () {},
//                         child: Text(
//                           'RESET',
//                           style: TextStyle(color: Colors.red),
//                         )),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
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

class PhoneNumberField extends StatelessWidget {
  final String label;

  final TextEditingController controller;
  PhoneNumberField(
      {super.key,
      required this.screenWidth,
      required this.label,
      required this.controller});

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: screenWidth < 600
              ? 90.0
              : 160.0, // Adjust label width based on screen size
          child: Text(
            label,
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
        SizedBox(
          width: 240,
          child: IntlPhoneField(
            controller: controller,
            initialCountryCode: 'IN',
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange),
                borderRadius: BorderRadius.circular(5.0),
              ),
              fillColor: Colors.orange[50],
            ),
            languageCode: "en",
            onChanged: (phone) {
              print(phone.completeNumber);
            },
            onCountryChanged: (country) {
              print('Country changed to: ' + country.name);
            },
          ),
        ),
      ],
    );
  }
}

class SishyasScreen extends StatefulWidget {
  final String? existingId;
  static const String id = "Sishyas-Screen";

  SishyasScreen({this.existingId});

  @override
  _SishyasScreenState createState() => _SishyasScreenState();
}

class _SishyasScreenState extends State<SishyasScreen> {
  final SishyaTypeCon = TextEditingController();
  final NameCon = TextEditingController();
  final careofpartCon = TextEditingController();
  final AliasExtraidentityCon = TextEditingController();
  final EmailCon = TextEditingController();
  final facebooklinkCon = TextEditingController();
  final SishyadataenteredbyCon = TextEditingController();
  final SamasreyanamController = TextEditingController();
  final dobController = TextEditingController(); // Dummy controller for DOB

  final mobileoneCon = TextEditingController();
  final mobiletwoCon = TextEditingController();
  final whatasappCon = TextEditingController();

  DateTime? selectedDOB; // Date of Birth
  DateTime? selectedSamasreyanamDate; // Samasreyanam Date
  String? selectedId;
  String?
      isFamilyPointOfContact; // Dropdown value for Is Sishya the family point of contact
  String? sishyaValidIndicator; // Dropdown value for Sishya valid indicator
  String? setId; // Dropdown value for Set ID

  var uuid = Uuid();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    selectedId = widget.existingId;
  }

  void _submitForm() async {
    if (selectedId != null) {
      String subId = uuid.v4(); // Generate a unique sub-ID

      try {
        await _firestore.collection('secondFormSubmissions').add({
          'id': selectedId!,
          'subId': subId,
          'Sishya Type': SishyaTypeCon.text,
          'Name': NameCon.text,
          'care/ofpart': careofpartCon.text,
          'Alias / Extra identity': AliasExtraidentityCon.text,
          'DOB': selectedDOB?.toIso8601String(),
          'Samasreyanam Date': selectedSamasreyanamDate?.toIso8601String(),
          'Mobileone': mobileoneCon.text,
          'Mobiletwo': mobiletwoCon.text,
          'Whatsapp': whatasappCon.text,
          'Facebook link': facebooklinkCon.text,
          'Email': EmailCon.text,
          'Sishya data entered by': SishyadataenteredbyCon.text,
          'Is Sishya the family point of contact': isFamilyPointOfContact,
          'Sishya valid indicator': sishyaValidIndicator,
          'Set ID': setId,
        });

        // Clear the controllers and reset the dropdown selections
        SishyaTypeCon.clear();
        NameCon.clear();
        selectedDOB = null; // Clear the selected DOB
        selectedSamasreyanamDate = null; // Clear the selected Samasreyanam Date
        isFamilyPointOfContact = null;
        sishyaValidIndicator = null;
        setId = null;

        // Optionally, navigate to another screen or update UI
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Form submitted successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an ID to associate the details with.'),
        ),
      );
    }
  }

  void _selectDate(String dateType) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        if (dateType == 'DOB') {
          selectedDOB = picked;
        } else if (dateType == 'Samasreyanam') {
          selectedSamasreyanamDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('Second Form')),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream:
                    _firestore.collection('firstFormSubmissions').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  final items = snapshot.data!.docs.map((doc) {
                    return DropdownMenuItem<String>(
                      value: doc['id'],
                      child: Text(doc['id']),
                    );
                  }).toList();

                  return Container(
                    alignment: Alignment.topLeft,
                    child: DropdownButton<String>(
                      value: selectedId,
                      hint: Text('Select Address ID'),
                      items: items,
                      onChanged: (value) {
                        setState(() {
                          selectedId = value;
                        });
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 25),
              InputField(
                label: 'Sishya Type',
                content: '',
                controller: SishyaTypeCon,
              ),
              SizedBox(height: 25),
              InputField(
                label: 'Name*',
                content: '',
                controller: NameCon,
              ),
              SizedBox(height: 25),
              InputField(
                label: 'Care/of part',
                content: '',
                controller: careofpartCon,
              ),
              SizedBox(height: 25),
              InputField(
                label: 'Alias / Extra identity',
                content: '',
                controller: AliasExtraidentityCon,
              ),
              SizedBox(height: 25),
              GestureDetector(
                onTap: () => _selectDate('DOB'),
                child: AbsorbPointer(
                  child: InputField(
                    label: 'Date of Birth',
                    content: selectedDOB != null
                        ? DateFormat.yMd().format(selectedDOB!)
                        : 'Choose a date',
                    controller: dobController, // Dummy controller
                  ),
                ),
              ),
              SizedBox(height: 25),
              GestureDetector(
                onTap: () => _selectDate('Samasreyanam'),
                child: AbsorbPointer(
                  child: InputField(
                    label: 'Samasreyanam Date',
                    content: selectedSamasreyanamDate != null
                        ? DateFormat.yMd().format(selectedSamasreyanamDate!)
                        : 'Choose a date',
                    controller: SamasreyanamController, // Dummy controller
                  ),
                ),
              ),
              SizedBox(height: 25),
              PhoneNumberField(
                screenWidth: screenWidth,
                label: 'Mobile 1',
                controller: mobileoneCon,
              ),
              SizedBox(height: 25),
              PhoneNumberField(
                screenWidth: screenWidth,
                label: 'Mobile 2',
                controller: mobiletwoCon,
              ),
              SizedBox(height: 25),
              PhoneNumberField(
                screenWidth: screenWidth,
                label: 'WhatsApp',
                controller: whatasappCon,
              ),
              SizedBox(height: 25),
              InputField(
                label: 'Email',
                content: '',
                controller: EmailCon,
              ),
              SizedBox(height: 25),
              InputField(
                label: 'Facebook link',
                content: '',
                controller: facebooklinkCon,
              ),
              SizedBox(height: 25),
              DropdownField(
                label: 'Is Sishya the family point of contact*',
                items: ['Yes', 'No'],
                selectedValue: isFamilyPointOfContact,
                onChanged: (value) {
                  setState(() {
                    isFamilyPointOfContact = value;
                  });
                },
              ),
              SizedBox(height: 25),
              DropdownField(
                label: 'Sishya valid indicator?*',
                items: ['Yes', 'No'],
                selectedValue: sishyaValidIndicator,
                onChanged: (value) {
                  setState(() {
                    sishyaValidIndicator = value;
                  });
                },
              ),
              SizedBox(height: 25),
              InputField(
                label: 'Sishya data entered by*',
                content: '',
                controller: SishyadataenteredbyCon,
              ),
              SizedBox(height: 25),
              DropdownField(
                label: 'Set ID*',
                items: ['Yes', 'No'],
                selectedValue: setId,
                onChanged: (value) {
                  setState(() {
                    setId = value;
                  });
                },
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _submitForm,
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
  final String?
      selectedValue; // Make this nullable to handle cases where no value is selected
  final ValueChanged<String?>
      onChanged; // Callback to notify parent of value changes

  DropdownField({
    required this.label,
    required this.items,
    this.selectedValue,
    required this.onChanged,
  });

  @override
  _DropdownFieldState createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  late String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue;
  }

  @override
  void didUpdateWidget(DropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != oldWidget.selectedValue) {
      setState(() {
        _selectedValue = widget.selectedValue;
      });
    }
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
                    _selectedValue = newValue;
                    widget.onChanged(newValue); // Notify parent of change
                  });
                },
                underline: SizedBox(),
                isExpanded: true,
                hint: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    _selectedValue ?? 'Select ${widget.label}',
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
