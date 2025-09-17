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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


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
      appBar: AppBar(
        title: const Text(
          'Resume Builder',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Export Resume',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PreviewScreen()),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 600;
            final sections = [
              SectionCard(
                title: 'Personal Info',
                icon: Icons.person_outline,
                onTap: () => _navigateToScreen(
                  context,
                  const PersonalInfoScreen(),
                ),
              ),
              SectionCard(
                title: 'Education',
                icon: Icons.school_outlined,
                onTap: () => _navigateToScreen(
                  context,
                  const EducationScreen(),
                ),
              ),
              SectionCard(
                title: 'Experience',
                icon: Icons.work_outline,
                onTap: () => _navigateToScreen(
                  context,
                  const ExperienceScreen(),
                ),
              ),
              SectionCard(
                title: 'Skills',
                icon: Icons.star_outline,
                onTap: () => _navigateToScreen(
                  context,
                  const SkillsScreen(),
                ),
              ),
              SectionCard(
                title: 'Projects',
                icon: Icons.code_outlined,
                onTap: () => _navigateToScreen(
                  context,
                  const ProjectsScreen(),
                ),
              ),
            ];

            Widget buildSectionsList() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMedium,
                      vertical: AppTheme.spacingLarge,
                    ),
                    child: Text(
                      'Resume Sections',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: sections.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      itemBuilder: (context, index) => sections[index],
                    ),
                  ),
                ],
              );
            }

            if (isDesktop) {
              return Row(
                children: [
                  // Left Pane: Sections
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(2, 0),
                          ),
                        ],
                      ),
                      child: buildSectionsList(),
                    ),
                  ),
                  // Right Pane: Mini Preview
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.all(AppTheme.spacingMedium),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(AppTheme.spacingMedium),
                            child: Text(
                              'Live Preview',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Consumer<ResumeProvider>(
                              builder: (context, provider, child) {
                                return SingleChildScrollView(
                                  padding: const EdgeInsets.all(AppTheme.spacingMedium),
                                  child: _buildMiniPreview(provider, context),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              // Mobile: Full ListView
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(AppTheme.spacingLarge),
                      child: Text(
                        'Build Your Resume',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      ...sections,
                    ]),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: AppTheme.spacingLarge * 5), // Extra for FAB
                  ),
                ],
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PreviewScreen()),
        ),
        icon: const Icon(Icons.visibility),
        label: const Text('Preview'),
        tooltip: 'View Full Resume Preview',
      ),
    );
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
        settings: const RouteSettings(name: 'Section Screen'),
      ),
    );
  }

  Widget _buildMiniPreview(ResumeProvider provider, BuildContext context) {
    if (provider.personalInfo == null && provider.educationList.isEmpty && provider.experienceList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.drafts, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Add sections to see a preview here',
              style: TextStyle(color: Colors.grey, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (provider.personalInfo != null) ...[
          Text(
            provider.personalInfo!.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(provider.personalInfo!.email, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: AppTheme.spacingLarge),
        ],
        const Text(
          'Sections Overview',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: AppTheme.spacingMedium),
        Expanded(
          child: Column(
            children: [
              if (provider.educationList.isNotEmpty) ...[
                const Text('Education', style: TextStyle(fontWeight: FontWeight.w500)),
                ...provider.educationList.take(2).map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text('${e.degree} • ${e.school}', style: const TextStyle(fontSize: 14)),
                )),
                if (provider.educationList.length > 2) ...[
                  const SizedBox(height: 8),
                  Text('+${provider.educationList.length - 2} more', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
                const SizedBox(height: AppTheme.spacingLarge),
              ],
              // Similar condensed for other sections (Experience, Skills, Projects)
              if (provider.experienceList.isNotEmpty) ...[
                const Text('Experience', style: TextStyle(fontWeight: FontWeight.w500)),
                ...provider.experienceList.take(1).map((exp) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text('${exp.job} at ${exp.company}', style: const TextStyle(fontSize: 14)),
                )),
                if (provider.experienceList.length > 1) ...[
                  const SizedBox(height: 8),
                  Text('+${provider.experienceList.length - 1} more', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
                const SizedBox(height: AppTheme.spacingLarge),
              ],
              // Add similar for Skills and Projects if space
            ],
          ),
        ),
      ],
    );
  }
}