import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weight_tracker/screens/weight_entry_screen.dart';
import 'package:weight_tracker/screens/weight_history_screen.dart';
import 'package:weight_tracker/widgets/weight_card.dart';
import 'package:weight_tracker/models/weight_entry.dart';
import 'package:weight_tracker/screens/auth_screen.dart';

class HomePageScreen extends StatelessWidget {
  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight Tracker'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('weightEntries')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
                        _showDeleteDialog(context, weightEntry);
                      },
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WeightEntryScreen()));
            },
            child: Text('Add Weight'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WeightHistoryScreen()));
            },
            child: Text('Weight History'),
          ),
          ElevatedButton(
            onPressed: () {
              _signOut(context); // Call the sign out method
            },
            child: Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  _showDeleteDialog(BuildContext context, WeightEntry weightEntry) {
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
              child: const Icon(
                Icons.delete_outlined,
              ),
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