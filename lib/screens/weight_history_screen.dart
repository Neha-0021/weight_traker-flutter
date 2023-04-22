import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weight_tracker/models/weight_entry.dart';
import 'package:weight_tracker/widgets/weight_card.dart';

class WeightHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('weightEntries').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No weight entries found.'));
          }
          final weightEntries = snapshot.data!.docs
              .map((doc) =>
                  WeightEntry.fromMap(doc.data() as Map<String, dynamic>))
              .toList();
          return ListView.builder(
            itemCount: weightEntries.length,
            itemBuilder: (BuildContext context, int index) {
              final weightEntry = weightEntries[index];
              return WeightCard(
                weightEntry: weightEntry,
                onDelete: () {
                  _showDeleteiocon(context, weightEntry);
                },
              );
            },
          );
        },
      ),
    );
  }

  _showDeleteiocon(BuildContext context, WeightEntry weightEntry) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this weight entry?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context); 
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                await _deleteWeightEntry(weightEntry);
                Navigator.pop(context); 
              },
            ),
          ],
        );
      },
    );
  }

  _deleteWeightEntry(WeightEntry weightEntry) async {
    await FirebaseFirestore.instance
        .collection('weightEntries')
        .doc(weightEntry.id) 
        .delete();
  }
}