import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../data/models/project.dart';
import '../providers/resume_provider.dart';
import '../widgets/custom_alert_box.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/app_button.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  void _showAddEditDialog(BuildContext context, {Project? proj}) {
    final titleController = TextEditingController(text: proj?.title ?? '');
    final techController = TextEditingController(text: proj?.techStack ?? '');
    final descController = TextEditingController(text: proj?.description ?? '');

    showDialog(
      context: context,
      builder: (_) => CustomAlertBox(
        title: proj == null ? 'Add Project' : 'Edit Project',
        content: Column(
          children: [
            CustomTextField(label: 'Title', controller: titleController),
            const SizedBox(height: AppTheme.spacingSmall),
            CustomTextField(label: 'Tech Stack', controller: techController),
            const SizedBox(height: AppTheme.spacingSmall),
            CustomTextField(
              label: 'Description',
              controller: descController,
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          AppButton(
            text: "Cancel",
            type: ButtonType.secondary,
            isFullWidth: false,
            onPressed: () => Navigator.pop(context),
          ),
          AppButton(
            text: "Save",
            type: ButtonType.primary,
            isFullWidth: false,
            onPressed: () {
              final provider =
                  Provider.of<ResumeProvider>(context, listen: false);

              final newProj = Project(
                id: proj?.id,
                title: titleController.text,
                techStack: techController.text,
                description: descController.text,
              );

              if (proj == null) {
                provider.addProject(newProj);
              } else {
                provider.updateProject(newProj);
              }

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Projects')),
      body: Consumer<ResumeProvider>(
        builder: (context, provider, child) {
          final projects = provider.projectsList;

          if (projects.isEmpty) {
            return const Center(child: Text('No projects added yet.'));
          }

          return ReorderableListView.builder(
            itemCount: projects.length,
            onReorder: (oldIndex, newIndex) {
              provider.reorderProjects(oldIndex, newIndex);
            },
            itemBuilder: (context, index) {
              final proj = projects[index];
              return ListTile(
                key: ValueKey(proj.id),
                title: Text(proj.title),
                subtitle: Text(proj.techStack),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showAddEditDialog(context, proj: proj),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => provider.deleteProject(proj.id!),
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
