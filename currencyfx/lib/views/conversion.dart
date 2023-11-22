import 'package:currencyfx/controller/VariableController.dart';
import 'package:currencyfx/controller/filterController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Conversion extends StatefulWidget {
  @override
  _ConversionState createState() => _ConversionState();
}

class _ConversionState extends State<Conversion> {
  final Data controller = Get.put(Data());
  DateTime? selectedDate;
  String selectedCurrencyCode = 'Australian dollar   (AUD)';
  String message = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Data Filter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Text('Select Date'),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Currency Code: ${selectedCurrencyCode.trim()}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                PopupMenuButton<String>(
                  initialValue: selectedCurrencyCode,
                  onSelected: (String value) {
                    setState(() {
                      selectedCurrencyCode = value;
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return controller.allcurrencies
                        .map<PopupMenuEntry<String>>((dynamic currencyCode) {
                      return PopupMenuItem<String>(
                        value: currencyCode.toString(),
                        child: Text(currencyCode.toString()),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            selectedDate != null
                ? Text(
                    'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}',
                    style: const TextStyle(fontSize: 16.0),
                  )
                : const Text('Null'),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                double result =
                    await filterDate(selectedDate!, selectedCurrencyCode);
                print(result);
                setState(() {
                  message =
                      'The value of ${selectedCurrencyCode.toString().trim()} on ${DateFormat('yyyy-MM-dd').format(selectedDate!)}  was  ${result.toStringAsFixed(3)} against the USD dollar';
                });
              },
              child: const Text('Show Data'),
            ),
            message == ''
                ? const Text('Enter date and Currency')
                : Text(message.toString()),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2012),
      firstDate: DateTime(2012),
      lastDate: DateTime(2022),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
