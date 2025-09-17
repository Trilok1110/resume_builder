import '../models/experience.dart';
import '../services/sqlite_service.dart';

class ExperienceRepository {
  final SQLiteService _service = SQLiteService.instance;
  final String table = 'experience';

  Future<List<Experience>> getAll() async {
    return _service.getList(table, (map) => Experience.fromMap(map));
  }

  Future<int> save(Experience exp) async {
    if (exp.id != null) {
      return _service.updateItem(table, exp.toMap(), exp.id!);
    } else {
      return _service.insertItem(table, exp.toMap());
    }
  }

  Future<int> delete(int id) => _service.deleteItem(table, id);

  Future<void> reorder(List<int> ids) => _service.updatePositions(table, ids);
}
