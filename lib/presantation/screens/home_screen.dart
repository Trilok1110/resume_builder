import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resume_builder/presantation/screens/personal_info_screen.dart';
import 'package:resume_builder/presantation/screens/preview_screen.dart';
import 'package:resume_builder/presantation/screens/projects_screen.dart';
import 'package:resume_builder/presantation/screens/skills_screen.dart';

import '../providers/resume_provider.dart';
import '../widgets/section_card.dart';
import 'education_screen.dart';
import '../../core/theme.dart';
import 'experience_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resume Builder')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 600;
          final sections = [
            SectionCard(
              title: 'Personal Info',
              icon: Icons.person,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PersonalInfoScreen()),
              ),
            ),
            SectionCard(
              title: 'Education',
              icon: Icons.school,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EducationScreen()),
              ),
            ),
            SectionCard(
              title: 'Experience',
              icon: Icons.work,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ExperienceScreen()),
              ),
            ),
            SectionCard(
              title: 'Skills',
              icon: Icons.star,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SkillsScreen()),
              ),
            ),
            SectionCard(
              title: 'Projects',
              icon: Icons.code,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProjectsScreen()),
              ),
            ),
          ];

          if (isDesktop) {
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sections',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: AppTheme.spacingMedium),
                        Expanded(child: ListView(children: sections)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.grey[100],
                    child: const Center(
                      child: Text('Preview Pane (Desktop) - Navigate to sections above'),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Consumer<ResumeProvider>(
              builder: (context, provider, child) {
                return ListView(
                  padding: EdgeInsets.all(AppTheme.spacingMedium),
                  children: [
                    ...sections,
                    SizedBox(height: AppTheme.spacingLarge * 3), // For FAB
                  ],
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PreviewScreen()),
        ),
        child: const Icon(Icons.preview),
      ),
    );
  }
}