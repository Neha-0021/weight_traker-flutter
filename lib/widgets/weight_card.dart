import 'package:flutter/material.dart';
import 'package:weight_tracker/models/weight_entry.dart';

class WeightCard extends StatelessWidget {
  final WeightEntry weightEntry;
  final Function() onDelete; // Updated the onDelete callback

  WeightCard({required this.weightEntry, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weight: ${weightEntry.weight} kg',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Date: ${weightEntry.date} ',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Note: ${weightEntry.note}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                onDelete(); // Call the onDelete callback when the button is pressed
              },
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
