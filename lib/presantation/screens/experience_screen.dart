import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/experience.dart';
import '../providers/resume_provider.dart';

class ExperienceScreen extends StatelessWidget {
  const ExperienceScreen({super.key});

  void _showAddEditDialog(BuildContext context, {Experience? exp}) {
    final jobController = TextEditingController(text: exp?.job ?? '');
    final companyController = TextEditingController(text: exp?.company ?? '');
    final durationController = TextEditingController(text: exp?.duration ?? '');
    final descController = TextEditingController(text: exp?.description ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(exp == null ? 'Add Experience' : 'Edit Experience'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: jobController, decoration: const InputDecoration(labelText: 'Job Title')),
              TextField(controller: companyController, decoration: const InputDecoration(labelText: 'Company')),
              TextField(controller: durationController, decoration: const InputDecoration(labelText: 'Duration')),
              TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final provider = Provider.of<ResumeProvider>(context, listen: false);
              final newExp = Experience(
                id: exp?.id,
                job: jobController.text,
                company: companyController.text,
                duration: durationController.text,
                description: descController.text,
              );
              exp == null ? provider.addExperience(newExp) : provider.updateExperience(newExp);
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
      appBar: AppBar(title: const Text('Experience')),
      body: Consumer<ResumeProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.experienceList.length,
            itemBuilder: (context, index) {
              final exp = provider.experienceList[index];
              return ListTile(
                title: Text(exp.job),
                subtitle: Text('${exp.company} (${exp.duration})'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit), onPressed: () => _showAddEditDialog(context, exp: exp)),
                    IconButton(icon: const Icon(Icons.delete), onPressed: () => provider.deleteExperience(exp.id!)),
                  ],
                ),
              );
            },
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
