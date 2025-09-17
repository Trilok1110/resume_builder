import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resume_builder/presantation/screens/experience_screen.dart';
import 'package:resume_builder/presantation/screens/personal_info_screen.dart';
import 'package:resume_builder/presantation/screens/preview_screen.dart';
import 'package:resume_builder/presantation/screens/projects_screen.dart';
import 'package:resume_builder/presantation/screens/skills_screen.dart';

import '../providers/resume_provider.dart';
import 'education_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resume Builder')),
      body: Consumer<ResumeProvider>(
        builder: (context, provider, child) {
          return ListView(
            children: [
              _buildSectionCard(
                context,
                'Personal Info',
                Icons.person,
                    () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PersonalInfoScreen()),
                ),
              ),
              _buildSectionCard(
                context,
                'Education',
                Icons.school,
                    () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EducationScreen()),
                ),
              ),
              _buildSectionCard(
                context,
                'Experience',
                Icons.work,
                    () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ExperienceScreen()),
                ),
              ),
              _buildSectionCard(
                context,
                'Skills',
                Icons.star,
                    () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SkillsScreen()),
                ),
              ),
              _buildSectionCard(
                context,
                'Projects',
                Icons.code,
                    () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProjectsScreen()),
                ),
              ),
              const SizedBox(height: 80), // For FAB
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PreviewScreen())),
        child: const Icon(Icons.preview),
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}