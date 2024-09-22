import 'dart:convert';
import 'package:deloitte/widgets/header.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class MissionVerification extends StatefulWidget {
  const MissionVerification({Key? key}) : super(key: key);

  @override
  State<MissionVerification> createState() => _MissionVerificationState();
}

class _MissionVerificationState extends State<MissionVerification> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? _startDate;
  DateTime? _endDate;
  int? _hoursPerDay;
  int? _holidays;
  List<dynamic> _assistantData = [];

  static const String baseUrl = 'http://192.168.100.16:8000';

  Future<void> _fetchData() async {
    if (_startDate == null ||
        _endDate == null ||
        _hoursPerDay == null ||
        _holidays == null) {
      return;
    }

    String formattedStartDate =
        '${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}';
    String formattedEndDate =
        '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}';

    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/results/?start_date=$formattedStartDate&end_date=$formattedEndDate&hours_per_day=$_hoursPerDay&holidays=$_holidays',
        ),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _assistantData = data['total_hours_reel_list'] ?? [];
        });
      } else {
        debugPrint('Error: ${response.body}');
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

  Color _getRowColor(double realHours, double theoreticalHours) {
    if (realHours == theoreticalHours) {
      return Colors.green;
    } else if (realHours > theoreticalHours) {
      return Colors.orange;
    } else {
      return Colors.red.withOpacity(0.4);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Header(),
              const SizedBox(height: 50),
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
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.green,
                            decoration: InputDecoration(
                              labelText: "Hours per day",
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
                            onChanged: (value) {
                              setState(() {
                                _hoursPerDay = int.tryParse(value);
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.green,
                            decoration: InputDecoration(
                              labelText: "Holidays",
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
                            onChanged: (value) {
                              setState(() {
                                _holidays = int.tryParse(value);
                              });
                            },
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
                      onPressed: _fetchData,
                      child: const Text('Calculate'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _assistantData.isNotEmpty
                  ? Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
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
                                    'Real Hours',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Theoretical Hours',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                              rows: _assistantData.map<DataRow>((assistant) {
                                final assistantName =
                                    assistant['Assistant'].toString();
                                final realHours =
                                    assistant['total_hours_reel'].toDouble();
                                final theoreticalHours =
                                    assistant['total_hours_thorique']
                                        .toDouble();

                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Text(
                                        assistantName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        realHours.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        theoreticalHours.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                  color:
                                      MaterialStateProperty.resolveWith<Color?>(
                                          (Set<MaterialState> states) {
                                    return _getRowColor(
                                        realHours, theoreticalHours);
                                  }),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
