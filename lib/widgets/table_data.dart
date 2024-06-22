import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class TableData extends StatefulWidget {
  const TableData({Key? key}) : super(key: key);

  @override
  State<TableData> createState() => _TableDataState();
}

class _TableDataState extends State<TableData> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? _startDate;
  DateTime? _endDate;
  List<Map<String, String>> _originalData = [];
  List<Map<String, String>> _filteredData = [];

  static const String baseUrl = 'http://192.168.1.114:8000';

  Future<void> _fetchData() async {
    if (_startDate == null || _endDate == null) {
      return;
    }

    String formattedStartDate =
        '${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}';
    String formattedEndDate =
        '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}';

    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/fetch/?start_date=$formattedStartDate&end_date=$formattedEndDate'),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          List<dynamic> responseData = json.decode(response.body)['data'];

          // Handle NaN values in the response
          responseData = responseData.map((item) {
            Map<String, dynamic> updatedItem = {};
            item.forEach((key, value) {
              updatedItem[key] = value is double && value.isNaN ? '' : value;
            });
            return updatedItem;
          }).toList();

          // Convert the List<dynamic> to List<Map<String, String>>
          List<Map<String, String>> parsedData = responseData.map((item) {
            Map<String, String> parsedItem = {};
            item.forEach((key, value) {
              parsedItem[key] = value.toString();
            });
            return parsedItem;
          }).toList();

          setState(() {
            _originalData = parsedData;
            _filteredData = _originalData;
          });
        } catch (e) {
          debugPrint('Error decoding JSON: $e');
          // Handle the error, e.g., show a message to the user
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
              surface: Colors.green,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Center(
            child: Text(
              'Get your Data',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            cursorColor: Colors.green,
                            decoration: InputDecoration(
                              labelText: "Starting Date",
                              labelStyle: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                              ),
                              fillColor: Colors.green,
                              border: const OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.green,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.green,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            onTap: () => _selectDate(context, true),
                            readOnly: true,
                            controller: TextEditingController(
                              text: _startDate == null
                                  ? ''
                                  : _startDate!
                                      .toLocal()
                                      .toString()
                                      .split(' ')[0],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            cursorColor: Colors.green,
                            decoration: InputDecoration(
                              labelText: "Ending Date",
                              labelStyle: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                              ),
                              fillColor: Colors.green,
                              border: const OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.green,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.green,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            onTap: () => _selectDate(context, false),
                            readOnly: true,
                            controller: TextEditingController(
                              text: _endDate == null
                                  ? ''
                                  : _endDate!
                                      .toLocal()
                                      .toString()
                                      .split(' ')[0],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () {
                        _fetchData();
                        setState(() {
                          _filteredData = _originalData;
                        });
                      },
                      child: const Text('Filtrer'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columns: const [
                        DataColumn(
                          label: Text(
                            'Assistant',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'TMission',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'CMission',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Raison Sociale',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Client',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Description',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Date',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Libellé',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Nbre Heures',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                      columnSpacing: 10,
                      dataRowHeight: 50,
                      rows: _filteredData
                          .map(
                            (item) => DataRow(cells: [
                              DataCell(
                                Text(item['Assistant'] ?? ''),
                              ),
                              DataCell(
                                Text(item['TMission'] ?? ''),
                              ),
                              DataCell(
                                Text(item['CMission'] ?? ''),
                              ),
                              DataCell(
                                Text(item['Raison_sociale'] ?? ''),
                              ),
                              DataCell(
                                Text(item['Client'] ?? ''),
                              ),
                              DataCell(
                                Text(item['Description'] ?? ''),
                              ),
                              DataCell(
                                Text(item['Date'] ?? ''),
                              ),
                              DataCell(
                                Text(item['Libellé'] ?? ''),
                              ),
                              DataCell(
                                Text(item['Nbre_heures'] ?? ''),
                              ),
                            ]),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
