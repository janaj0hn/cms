import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class InputField extends StatelessWidget {
  final String label;
  final String content;
  final TextEditingController controller;
  final bool readOnly;

  final FormFieldValidator<String>? validator;

  InputField(
      {required this.label,
      required this.content,
      required this.controller,
      this.readOnly = false,
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
  String _dropdownValue1 = 'No';
  String _dropdownValue2 = 'No';
  String _dropdownValue3 = 'Set 1';

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

  final SishyaIdCon = TextEditingController();

  DateTime? selectedDOB; // Date of Birth
  DateTime? selectedSamasreyanamDate; // Samasreyanam Date
  String? selectedId;
  String?
      isFamilyPointOfContact; // Dropdown value for Is Sishya the family point of contact
  String? sishyaValidIndicator; // Dropdown value for Sishya valid indicator
  String? setId; // Dropdown value for Set ID

  final uuid = Uuid();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController searchController = TextEditingController();
  List<String> addressIds = [];
  List<String> filteredAddressIds = [];

  @override
  void initState() {
    super.initState();
    selectedId = widget.existingId;
    searchController.addListener(_filterAddressIds);
    _fetchAddressIds();
    _loadSishyaId();
  }

  void _filterAddressIds() {
    setState(() {
      filteredAddressIds = addressIds
          .where((id) =>
              id.toLowerCase().contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  Future<void> _fetchAddressIds() async {
    try {
      final snapshot =
          await _firestore.collection('firstFormSubmissions').get();
      final ids = snapshot.docs.map((doc) => doc['id'] as String).toList();
      setState(() {
        addressIds = ids;
        filteredAddressIds = ids;
      });
    } catch (e) {
      // Handle errors here
      print('Error fetching address IDs: $e');
    }
  }

  void _showSearchableDropdown() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Address ID',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _filterAddressIds();
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      children: filteredAddressIds.map((id) {
                        return ListTile(
                          title: Text(id),
                          onTap: () {
                            Navigator.pop(context, id);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (selected != null) {
      setState(() {
        selectedId = selected;
      });
    }
  }

  // Generate a short random alphanumeric string
  String generateShortId(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rand = Random();
    return List.generate(length, (index) => chars[rand.nextInt(chars.length)])
        .join();
  }

  void _submitForm() async {
    // Generate a new subId if not already set
    String subId;
    if (SishyaIdCon.text.isEmpty) {
      subId = generateShortId(10);
      SishyaIdCon.text = subId;
      await _saveSishyaId(subId);
    } else {
      subId = SishyaIdCon.text;
    }

    if (selectedId != null) {
      try {
        await _firestore.collection('secondFormSubmissions').add({
          'id': selectedId!,
          'subId': subId, // Use the generated or retrieved subId
          'SishyaType': SishyaTypeCon.text,
          'Name': NameCon.text,
          'careofpart': careofpartCon.text,
          'AliasExtraidentity': AliasExtraidentityCon.text,
          'DOB': selectedDOB?.toIso8601String(),
          'Samasreyanam Date': selectedSamasreyanamDate?.toIso8601String(),
          'Mobileone': mobileoneCon.text,
          'Mobiletwo': mobiletwoCon.text,
          'Whatsapp': whatasappCon.text,
          'Facebook link': facebooklinkCon.text,
          'Email': EmailCon.text,
          'Sishya data entered by': SishyadataenteredbyCon.text,
          'IsSishyathefamilypointofcontact': _dropdownValue1,
          'Sishyavalidindicator': _dropdownValue2,
        });

        // Update counts
        await _updateSubmissionCounts('sishyasCount');

        // Clear the controllers and reset the dropdown selections
        SishyaTypeCon.clear();
        NameCon.clear();
        selectedDOB = null; // Clear the selected DOB
        selectedSamasreyanamDate = null; // Clear the selected Samasreyanam Date
        isFamilyPointOfContact = null;
        sishyaValidIndicator = null;

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

  Future<void> _updateSubmissionCounts(String countType) async {
    try {
      final docRef = _firestore.collection('submissionCounts').doc('counts');
      final doc = await docRef.get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        int currentCount = data[countType] ?? 0;

        await docRef.update({
          countType: currentCount + 1,
        });
      } else {
        await docRef.set({
          countType: 1,
        });
      }
    } catch (e) {
      print('Error updating submission counts: $e');
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

  void _loadSishyaId() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getString('sishya_id');
    if (savedId != null) {
      setState(() {
        SishyaIdCon.text = savedId;
      });
    }
  }

  // Save the Address ID to SharedPreferences
  Future<void> _saveSishyaId(String subId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sishya_id', subId);
  }

  // Clear the Address ID from SharedPreferences
  Future<void> _clearSishyaId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('sishya_id');
    setState(() {
      SishyaIdCon.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('Add Sishya')),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputField(
                label: 'Sishya ID',
                content: 'Generated Address ID will appear here',
                controller: SishyaIdCon,
                readOnly: true,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _clearSishyaId,
                child: Text('Clear Address ID'),
              ),
              SizedBox(height: 25),
              GestureDetector(
                onTap: _showSearchableDropdown,
                child: AbsorbPointer(
                  child: InputField(
                    label: 'Address ID',
                    content: selectedId ?? 'Select Address ID',
                    controller: TextEditingController(
                        text: selectedId), // Dummy controller
                  ),
                ),
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
                label: 'Sishya valid indicator?*',
                items: ['Yes', 'No'],
                selectedValue: _dropdownValue1,
                onChanged: (value) {
                  setState(() {
                    _dropdownValue1 = value!;
                  });
                },
              ),
              SizedBox(height: 25),
              DropdownField(
                label: 'Is Sishya the family point of contact*',
                items: ['Yes', 'No'],
                selectedValue: _dropdownValue2,
                onChanged: (value) {
                  setState(() {
                    _dropdownValue2 = value!;
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
