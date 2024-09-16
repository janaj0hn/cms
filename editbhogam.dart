import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DataTableScreen extends StatefulWidget {
  static const String id = "bhogam-edit";

  const DataTableScreen({Key? key}) : super(key: key);

  @override
  _DataTableScreenState createState() => _DataTableScreenState();
}

class _DataTableScreenState extends State<DataTableScreen> {
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _showDetailsBottomSheet(
      BuildContext context, String documentId) async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('thirdFormSubmissions')
        .doc(documentId)
        .get();

    final fields = docSnapshot.data() as Map<String, dynamic>;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            double maxHeight = MediaQuery.of(context).size.height * 0.8;
            double maxWidth = constraints.maxWidth * 0.9;

            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: maxHeight,
                maxWidth: maxWidth,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 16.0,
                            columns: const [
                              DataColumn(label: Text('Field')),
                              DataColumn(label: Text('Value')),
                            ],
                            rows: fields.entries.map((entry) {
                              return DataRow(cells: [
                                DataCell(
                                  SizedBox(
                                    width: maxWidth * 0.4,
                                    child: Text(
                                      entry.key,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: maxWidth * 0.5,
                                    child: Text(
                                      entry.value.toString(),
                                      style: TextStyle(fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showEditBottomSheet(BuildContext context, String documentId,
      Map<String, dynamic> initialData) async {
    final TextEditingController subIdController =
        TextEditingController(text: initialData['subId']);
    final TextEditingController bsubIdController =
        TextEditingController(text: initialData['BsubId']);
    final TextEditingController nameController =
        TextEditingController(text: initialData['bhogamName']);
    final TextEditingController amountController =
        TextEditingController(text: initialData['bhogamAmount']);
    final TextEditingController thithiController =
        TextEditingController(text: initialData['Bhogamthithinakshatram']);
    final TextEditingController emailController =
        TextEditingController(text: initialData['email']);
    final TextEditingController phoneController =
        TextEditingController(text: initialData['phone']);
    final TextEditingController enteredByController =
        TextEditingController(text: initialData['Bhogamdataenteredby']);
    final TextEditingController startDateController =
        TextEditingController(text: initialData['Bhogamstartdate']);
    final TextEditingController englishDateController =
        TextEditingController(text: initialData['EnglishCalenderDate']);

    DateTime? startDate = initialData['Bhogamstartdate'] != null
        ? DateFormat.yMd().parse(initialData['Bhogamstartdate'])
        : null;
    DateTime? englishDate = initialData['EnglishCalenderDate'] != null
        ? DateFormat.yMd().parse(initialData['EnglishCalenderDate'])
        : null;

    List<String> purposes = ['Birthday', 'Marriage Anniversary', 'Thithi'];
    List<String> sishyaOptions = ['Yes', 'No'];
    List<String> validOptions = ['Yes', 'No'];

    String selectedPurpose = purposes.contains(initialData['Bhogam purpose'])
        ? initialData['Bhogam purpose']
        : purposes.first;
    String selectedSishya = sishyaOptions.contains(initialData['AreyouaSishya'])
        ? initialData['AreyouaSishya']
        : sishyaOptions.first;
    String selectedValid =
        validOptions.contains(initialData['bhogamvalidindicator'])
            ? initialData['bhogamvalidindicator']
            : validOptions.first;

    Future<void> _selectDate(BuildContext context,
        TextEditingController controller, DateTime? initialDate) async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (pickedDate != null && pickedDate != initialDate) {
        controller.text = DateFormat.yMd().format(pickedDate);
      }
    }

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                      controller: subIdController, label: 'Sishya ID'),
                  _buildTextField(
                      controller: bsubIdController, label: 'Bhogam ID'),
                  _buildDropdown<String>(
                    value: selectedPurpose,
                    label: 'Purpose',
                    items: purposes,
                    onChanged: (value) =>
                        setState(() => selectedPurpose = value!),
                  ),
                  _buildTextField(controller: nameController, label: 'Name'),
                  _buildTextField(
                      controller: TextEditingController(
                          text: initialData['bhogamMonth']),
                      label: 'Month'),
                  _buildDateField(
                    controller: startDateController,
                    label: 'Start Date',
                    onPressed: () =>
                        _selectDate(context, startDateController, startDate),
                  ),
                  _buildDateField(
                    controller: englishDateController,
                    label: 'English Date',
                    onPressed: () => _selectDate(
                        context, englishDateController, englishDate),
                  ),
                  _buildTextField(
                      controller: amountController, label: 'Amount'),
                  _buildTextField(
                      controller: thithiController, label: 'Thithi/Nakshatram'),
                  _buildTextField(controller: emailController, label: 'Email'),
                  _buildTextField(controller: phoneController, label: 'Phone'),
                  _buildTextField(
                      controller: enteredByController, label: 'Entered By'),
                  _buildDropdown<String>(
                    value: selectedSishya,
                    label: 'Sishya?',
                    items: sishyaOptions,
                    onChanged: (value) =>
                        setState(() => selectedSishya = value!),
                  ),
                  _buildDropdown<String>(
                    value: selectedValid,
                    label: 'Valid?',
                    items: validOptions,
                    onChanged: (value) =>
                        setState(() => selectedValid = value!),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('thirdFormSubmissions')
                          .doc(documentId)
                          .update({
                        'subId': subIdController.text,
                        'BsubId': bsubIdController.text,
                        'Bhogam purpose': selectedPurpose,
                        'bhogamName': nameController.text,
                        'bhogamMonth': initialData['bhogamMonth'],
                        'Bhogamstartdate': startDateController.text,
                        'EnglishCalenderDate': englishDateController.text,
                        'bhogamAmount': amountController.text,
                        'Bhogamthithinakshatram': thithiController.text,
                        'email': emailController.text,
                        'phone': phoneController.text,
                        'Bhogamdataenteredby': enteredByController.text,
                        'AreyouaSishya': selectedSishya,
                        'bhogamvalidindicator': selectedValid,
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Update Data'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: onPressed,
          ),
        ),
        readOnly: true,
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required String label,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(labelText: label),
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(item.toString()),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );
    if (picked != null &&
        picked !=
            DateTimeRange(
                start: _startDate ?? DateTime.now(),
                end: _endDate ?? DateTime.now())) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('All Bhogam Masters'),
        actions: [
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () => _selectDateRange(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('thirdFormSubmissions')
            .where('Bhogamstartdate',
                isGreaterThanOrEqualTo: _startDate != null
                    ? DateFormat.yMd().format(_startDate!)
                    : null)
            .where('Bhogamstartdate',
                isLessThanOrEqualTo: _endDate != null
                    ? DateFormat.yMd().format(_endDate!)
                    : null)
            .limit(5)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data?.docs ?? [];

          if (isMobile) {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final doc = data[index];
                final fields = doc.data() as Map<String, dynamic>;
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    title: Text(fields['bhogamName'] ?? 'No Name'),
                    subtitle: Text(fields['Bhogam purpose'] ?? 'No Purpose'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.visibility),
                          onPressed: () {
                            _showDetailsBottomSheet(context, doc.id);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditBottomSheet(context, doc.id, fields);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Bhogam ID')),
                  DataColumn(label: Text('Purpose')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Month')),
                  DataColumn(label: Text('Bhogam start date')),
                  DataColumn(label: Text('Phone')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: data.map((doc) {
                  final fields = doc.data() as Map<String, dynamic>;
                  return DataRow(cells: [
                    DataCell(Text(fields['BsubId'] ?? '')),
                    DataCell(Text(fields['Bhogam purpose'] ?? '')),
                    DataCell(Text(fields['bhogamName'] ?? '')),
                    DataCell(Text(fields['bhogamMonth'] ?? '')),
                    DataCell(Text(fields['Bhogamstartdate'] ?? '')),
                    DataCell(Text(fields['phone'] ?? '')),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.visibility),
                            onPressed: () {
                              _showDetailsBottomSheet(context, doc.id);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _showEditBottomSheet(context, doc.id, fields);
                            },
                          ),
                        ],
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
