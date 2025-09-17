import '../models/personal_info.dart';
import '../services/sqlite_service.dart';

class PersonalInfoRepository {
  final SQLiteService _service = SQLiteService.instance;
  final String table = 'personal_info';

  Future<PersonalInfo?> getPersonalInfo() => _service.getPersonalInfo();

  Future<int> savePersonalInfo(PersonalInfo info) async {
    if (info.id != null) {
      return await _service.updatePersonalInfo(info);
    } else {
      return await _service.insertPersonalInfo(info);
    }
  }

  Future<void> deletePersonalInfo(int id) => _service.deletePersonalInfo(id);
  Future<void> reorder(List<int> ids) => _service.updatePositions(table, ids);

}