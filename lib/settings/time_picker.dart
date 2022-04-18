import 'package:flutter/material.dart';

class TimePickerWidget extends StatefulWidget {
  const TimePickerWidget({Key? key}) : super(key: key);

  @override
  _TimePickerWidgetState createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  TimeOfDay time = const TimeOfDay(hour: 10, minute: 30);

  @override
  Widget build(BuildContext context){
    final hours = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$hours:$minute',
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Selecteer begintijd'),
              onPressed: () async {
                TimeOfDay? newTime = await showTimePicker(
                  context: context,
                  initialTime: time,
                );
                if (newTime == null) return;

                setState(() => time = newTime);
              },
            ),
          ],
        ),
      ),
    );
  }
}