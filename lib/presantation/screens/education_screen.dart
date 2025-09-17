import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/education.dart';
import '../providers/resume_provider.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  void _showAddEditDialog(BuildContext context, {Education? edu}) {
    final degreeController = TextEditingController(text: edu?.degree ?? '');
    final schoolController = TextEditingController(text: edu?.school ?? '');
    final yearController = TextEditingController(text: edu?.year ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(edu == null ? 'Add Education' : 'Edit Education'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: degreeController,
                decoration: const InputDecoration(labelText: 'Degree'),
              ),
              TextField(
                controller: schoolController,
                decoration: const InputDecoration(labelText: 'School'),
              ),
              TextField(
                controller: yearController,
                decoration: const InputDecoration(labelText: 'Year'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final provider = Provider.of<ResumeProvider>(context, listen: false);
              final newEdu = Education(
                id: edu?.id,
                degree: degreeController.text,
                school: schoolController.text,
                year: yearController.text,
              );
              edu == null
                  ? provider.addEducation(newEdu)
                  : provider.updateEducation(newEdu);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Education')),
        body: Consumer<ResumeProvider>(
          builder: (context, provider, child) {
            return ReorderableListView(
              onReorder: (oldIndex, newIndex) =>
                  provider.reorderEducation(oldIndex, newIndex),
              children: [
                for (final edu in provider.educationList)
                  ListTile(
                    key: ValueKey(edu.id),
                    title: Text(edu.degree),
                    subtitle: Text('${edu.school} (${edu.year})'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () =>
                              _showAddEditDialog(context, edu: edu),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => provider.deleteEducation(edu.id!),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}