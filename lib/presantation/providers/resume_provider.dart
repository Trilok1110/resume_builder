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
}
