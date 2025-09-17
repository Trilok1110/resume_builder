import '../models/skill.dart';
import '../services/sqlite_service.dart';

class SkillRepository {
  final SQLiteService _service = SQLiteService.instance;
  final String table = 'skills';

  Future<List<Skill>> getAll() async {
    return _service.getList(table, (map) => Skill.fromMap(map));
  }

  Future<int> save(Skill skill) async {
    if (skill.id != null) {
      return _service.updateItem(table, skill.toMap(), skill.id!);
    } else {
      return _service.insertItem(table, skill.toMap());
    }
  }

  Future<int> delete(int id) => _service.deleteItem(table, id);

  Future<void> reorder(List<int> ids) => _service.updatePositions(table, ids);
}
