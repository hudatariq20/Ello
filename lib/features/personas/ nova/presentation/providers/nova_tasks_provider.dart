import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_input/features/personas/ nova/data/datasources/nova_datasources.dart';
import 'package:voice_input/features/personas/%20nova/presentation/providers/nova_task_controller.dart';
import 'package:voice_input/shared/models/task_item.dart';

//Providers
final novaTaskRepositoryProvider = Provider<NovaTaskRepository>((ref) {
  final staticSource = NovaStaticSource();
  final firestoreSource = NovaFirestoreSource();
  return NovaTaskRepository(staticSource: staticSource, firestoreSource: firestoreSource);
});

final novaTasksProvider = FutureProvider<List<TaskItem>>((ref) {
  final repo = ref.watch(novaTaskRepositoryProvider);
  return repo.getAllTasks();
});
