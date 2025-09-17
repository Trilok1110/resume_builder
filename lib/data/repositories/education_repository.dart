import '../models/education.dart';
import '../services/sqlite_service.dart';

class EducationRepository {
  final SQLiteService _service = SQLiteService.instance;
  final String table = 'education';

  Future<List<Education>> getAll() async {
    return _service.getList(table, (map) => Education.fromMap(map));
  }

  Future<int> save(Education edu) async {
    if (edu.id != null) {
      return _service.updateItem(table, edu.toMap(), edu.id!);
    } else {
      return _service.insertItem(table, edu.toMap());
    }
  }

  Future<int> delete(int id) => _service.deleteItem(table, id);

  Future<void> reorder(List<int> ids) => _service.updatePositions(table, ids);
}
