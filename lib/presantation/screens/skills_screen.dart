import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/skill.dart';
import '../providers/resume_provider.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({super.key});

  void _showAddEditDialog(BuildContext context, {Skill? skill}) {
    final nameController = TextEditingController(text: skill?.name ?? '');
    final levelController = TextEditingController(text: skill?.level ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(skill == null ? 'Add Skill' : 'Edit Skill'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Skill Name')),
            TextField(controller: levelController, decoration: const InputDecoration(labelText: 'Level (e.g., Beginner, Intermediate, Expert)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final provider = Provider.of<ResumeProvider>(context, listen: false);
              final newSkill = Skill(
                id: skill?.id,
                name: nameController.text,
                level: levelController.text,
              );
              skill == null ? provider.addSkill(newSkill) : provider.updateSkill(newSkill);
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
      appBar: AppBar(title: const Text('Skills')),
        body: Consumer<ResumeProvider>(
          builder: (context, provider, child) {
            final skills = provider.skillsList;

            if (skills.isEmpty) {
              return const Center(child: Text('No skills added yet.'));
            }

            return ReorderableListView.builder(
              itemCount: skills.length,
              onReorder: (oldIndex, newIndex) {
                provider.reorderProjects(oldIndex, newIndex);
              },
              itemBuilder: (context, index) {
                final skill = skills[index];
                return ListTile(
                  key: ValueKey(skill.id),
                  title: Text(skill.name),
                  subtitle: Text(skill.level),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showAddEditDialog(context, skill: skill),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => provider.deleteSkill(skill.id!),
                      ),
                      const Icon(Icons.drag_handle),
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
