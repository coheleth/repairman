import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:repairman/data/db/db_controller.dart';
import 'package:repairman/data/models/status.dart';

part 'status_list.g.dart';

@riverpod
class StatusList extends _$StatusList {
  @override
  Future<List<Status>> build() async {
    return DBController().getAllStatus();
  }
}
