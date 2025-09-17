import 'package:flutter/foundation.dart';

import '../../data/models/education.dart';
import '../../data/models/experience.dart';
import '../../data/models/personal_info.dart';
import '../../data/models/project.dart';
import '../../data/models/skill.dart';

import '../../data/repositories/education_repository.dart';
import '../../data/repositories/experience_repository.dart';
import '../../data/repositories/personal_info_repository.dart';
import '../../data/repositories/project_repository.dart';
import '../../data/repositories/skill_repository.dart';

import '../../data/services/sqlite_service.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;



class ResumeProvider extends ChangeNotifier {
  // Repositories
  final PersonalInfoRepository _personalRepo = PersonalInfoRepository();
  final EducationRepository _eduRepo = EducationRepository();
  final ExperienceRepository _expRepo = ExperienceRepository();
  final SkillRepository _skillRepo = SkillRepository();
  final ProjectRepository _projRepo = ProjectRepository();

  // State
  PersonalInfo? _personalInfo;
  List<Education> _educationList = [];
  List<Experience> _experienceList = [];
  List<Skill> _skillsList = [];
  List<Project> _projectsList = [];

  // Getters
  PersonalInfo? get personalInfo => _personalInfo;
  List<Education> get educationList => _educationList;
  List<Experience> get experienceList => _experienceList;
  List<Skill> get skillsList => _skillsList;
  List<Project> get projectsList => _projectsList;

  // Constructor
  ResumeProvider() {
    _loadAllData();
  }

  // Init: Load all data
  Future<void> _loadAllData() async {
    _personalInfo = await _personalRepo.getPersonalInfo();
    _educationList = await _eduRepo.getAll();
    _experienceList = await _expRepo.getAll();
    _skillsList = await _skillRepo.getAll();
    _projectsList = await _projRepo.getAll();
    notifyListeners();
  }

  // Personal Info
  Future<void> savePersonalInfo(PersonalInfo info) async {
    await _personalRepo.savePersonalInfo(info);
    _personalInfo = info;
    notifyListeners();
  }

  // Education
  Future<void> addEducation(Education edu) async {
    final id = await _eduRepo.save(edu);
    final newEdu = Education(
      id: id,
      degree: edu.degree,
      school: edu.school,
      year: edu.year,
      position: edu.position,
    );
    _educationList.add(newEdu);
    notifyListeners();
  }

  Future<void> updateEducation(Education edu) async {
    await _eduRepo.save(edu);
    final index = _educationList.indexWhere((e) => e.id == edu.id);
    if (index != -1) {
      _educationList[index] = edu;
      notifyListeners();
    }
  }

  Future<void> deleteEducation(int id) async {
    await _eduRepo.delete(id);
    _educationList.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void reorderEducation(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = _educationList.removeAt(oldIndex);
    _educationList.insert(newIndex, item);
    _saveOrder('education', _educationList.map((e) => e.id!).toList());
    notifyListeners();
  }

  // Experience
  Future<void> addExperience(Experience exp) async {
    final id = await _expRepo.save(exp);
    final newExp = Experience(
      id: id,
      job: exp.job,
      company: exp.company,
      duration: exp.duration,
      description: exp.description,
      position: exp.position,
    );
    _experienceList.add(newExp);
    notifyListeners();
  }

  Future<void> updateExperience(Experience exp) async {
    await _expRepo.save(exp);
    final index = _experienceList.indexWhere((e) => e.id == exp.id);
    if (index != -1) {
      _experienceList[index] = exp;
      notifyListeners();
    }
  }

  Future<void> deleteExperience(int id) async {
    await _expRepo.delete(id);
    _experienceList.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void reorderExperience(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = _experienceList.removeAt(oldIndex);
    _experienceList.insert(newIndex, item);
    _saveOrder('experience', _experienceList.map((e) => e.id!).toList());
    notifyListeners();
  }

  // Skills
  Future<void> addSkill(Skill skill) async {
    final id = await _skillRepo.save(skill);
    final newSkill = Skill(
      id: id,
      name: skill.name,
      level: skill.level,
      position: skill.position,
    );
    _skillsList.add(newSkill);
    notifyListeners();
  }

  Future<void> updateSkill(Skill skill) async {
    await _skillRepo.save(skill);
    final index = _skillsList.indexWhere((s) => s.id == skill.id);
    if (index != -1) {
      _skillsList[index] = skill;
      notifyListeners();
    }
  }

  Future<void> deleteSkill(int id) async {
    await _skillRepo.delete(id);
    _skillsList.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  void reorderSkills(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = _skillsList.removeAt(oldIndex);
    _skillsList.insert(newIndex, item);
    _saveOrder('skills', _skillsList.map((s) => s.id!).toList());
    notifyListeners();
  }

  // Projects
  Future<void> addProject(Project proj) async {
    final id = await _projRepo.save(proj);
    final newProj = Project(
      id: id,
      title: proj.title,
      techStack: proj.techStack,
      description: proj.description,
      position: proj.position,
    );
    _projectsList.add(newProj);
    notifyListeners();
  }

  Future<void> updateProject(Project proj) async {
    await _projRepo.save(proj);
    final index = _projectsList.indexWhere((p) => p.id == proj.id);
    if (index != -1) {
      _projectsList[index] = proj;
      notifyListeners();
    }
  }

  Future<void> deleteProject(int id) async {
    await _projRepo.delete(id);
    _projectsList.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void reorderProjects(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = _projectsList.removeAt(oldIndex);
    _projectsList.insert(newIndex, item);
    _saveOrder('projects', _projectsList.map((p) => p.id!).toList());
    notifyListeners();
  }

  // Save Order Helper
  Future<void> _saveOrder(String table, List<int> ids) async {
    await SQLiteService.instance.updatePositions(table, ids);
  }
  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          if (personalInfo != null) ...[
            pw.Text(personalInfo!.name,
                style: pw.TextStyle(fontSize: 26, fontWeight: pw.FontWeight.bold)),
            pw.Text(personalInfo!.email),
            if (personalInfo!.phone.isNotEmpty) pw.Text(personalInfo!.phone),
            pw.SizedBox(height: 16),
          ],

          // Education
          if (educationList.isNotEmpty) ...[
            pw.Header(level: 1, text: 'Education'),
            ...educationList.map((e) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(e.degree,
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.Text('${e.school} (${e.year})'),
                pw.SizedBox(height: 8),
              ],
            )),
          ],

          // Experience
          if (experienceList.isNotEmpty) ...[
            pw.Header(level: 1, text: 'Experience'),
            ...experienceList.map((e) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(e.job,
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.Text('${e.company} (${e.duration})'),
                if (e.description.isNotEmpty) pw.Text(e.description),
                pw.SizedBox(height: 8),
              ],
            )),
          ],

          // Skills
          if (skillsList.isNotEmpty) ...[
            pw.Header(level: 1, text: 'Skills'),
            pw.Wrap(
              spacing: 8,
              runSpacing: 4,
              children: skillsList
                  .map((s) => pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                ),
                child: pw.Text('${s.name} (${s.level})',
                    style: const pw.TextStyle(fontSize: 12)),
              ))
                  .toList(),
            ),
            pw.SizedBox(height: 8),
          ],

          // Projects
          if (projectsList.isNotEmpty) ...[
            pw.Header(level: 1, text: 'Projects'),
            ...projectsList.map((p) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(p.title,
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                if (p.techStack.isNotEmpty) pw.Text('Tech: ${p.techStack}'),
                if (p.description.isNotEmpty) pw.Text(p.description),
                pw.SizedBox(height: 8),
              ],
            )),
          ],
        ],
      ),
    );

    return await pdf.save();
  }

  Future<File> exportPdf({String fileName = 'resume.pdf'}) async {
    final bytes = await generatePdf();
    final dir = await getExternalStorageDirectory();
    final file = File('${dir?.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file;
  }
}

