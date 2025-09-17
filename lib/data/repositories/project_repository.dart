import '../models/project.dart';
import '../services/sqlite_service.dart';

class ProjectRepository {
  final SQLiteService _service = SQLiteService.instance;
  final String table = 'projects';

  Future<List<Project>> getAll() async {
    return _service.getList(table, (map) => Project.fromMap(map));
  }

  Future<int> save(Project project) async {
    if (project.id != null) {
      return _service.updateItem(table, project.toMap(), project.id!);
    } else {
      return _service.insertItem(table, project.toMap());
    }
  }

  Future<int> delete(int id) => _service.deleteItem(table, id);

  Future<void> reorder(List<int> ids) => _service.updatePositions(table, ids);
}
