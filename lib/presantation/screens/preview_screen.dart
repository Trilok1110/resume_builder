import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/resume_provider.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget _buildCard(Widget child) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resume Preview') , actions: [

        InkWell(onTap:  () async {
          final provider = Provider.of<ResumeProvider>(context, listen: false);
          final file = await provider.exportPdf();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('PDF saved at: ${file}')),

          );
        },
        child: Icon(Icons.print ),
      ),
        SizedBox(width: 10,)
      ],),
      body: Consumer<ResumeProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Personal Info
                if (provider.personalInfo != null) ...[
                  Center(
                    child: Column(
                      children: [
                        Text(
                          provider.personalInfo!.name,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(provider.personalInfo!.email),
                        Text(provider.personalInfo!.phone),
                        Text(provider.personalInfo!.address),
                      ],
                    ),
                  ),
                  const Divider(thickness: 1.2),
                ],

                // Education Section
                if (provider.educationList.isNotEmpty) ...[
                  _buildSectionTitle("Education"),
                  ...provider.educationList.map(
                        (edu) => _buildCard(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            edu.degree,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(edu.school),
                          Text("Year: ${edu.year}"),
                        ],
                      ),
                    ),
                  ),
                ],

                // Experience Section
                if (provider.experienceList.isNotEmpty) ...[
                  _buildSectionTitle("Experience"),
                  ...provider.experienceList.map(
                        (exp) => _buildCard(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exp.job,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(exp.company),
                          Text(exp.duration),
                          if (exp.description.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(exp.description),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],

                // Projects Section
                if (provider.projectsList.isNotEmpty) ...[
                  _buildSectionTitle("Projects"),
                  ...provider.projectsList.map(
                        (proj) => _buildCard(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            proj.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text("Tech: ${proj.techStack}"),
                          if (proj.description.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(proj.description),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],

                // Skills Section
                if (provider.skillsList.isNotEmpty) ...[
                  _buildSectionTitle("Skills"),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: provider.skillsList
                        .map(
                          (skill) => Chip(
                        label: Text("${skill.name} (${skill.level})"),
                        backgroundColor: Colors.blue.shade50,
                      ),
                    )
                        .toList(),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
