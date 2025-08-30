import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:voice_input/features/personas/%20nova/domain/entities/todo.dart';
import 'package:voice_input/features/personas/%20nova/domain/repositories/base_todo_repository.dart';

import '../models/todo_dto.dart';

class TodoRepository extends BaseTodoRepository {
  final FirebaseFirestore _firestore;

  TodoRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

//Collection
  CollectionReference<Map<String, dynamic>> _userTodos(
      String userId, String personaId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('personas')
        .doc(personaId)
        .collection('todos');
  }

  @override
  Future<void> addTodo(String userId, String personaId, Todo todo) async {
  try{
       final todoId = Uuid().v4();
       final dto = TodoDto.fromDomain(todo.copyWith(id: todoId));
       await _userTodos(userId, personaId).doc(todoId).set(
      {...dto.toDocument(),
       'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),});
    }on FirebaseException catch (e, stack) {
      print('🔥 Firebase error adding todo: ${e.message}');
      print(stack);
      rethrow;
    } catch (e, stack) {
      print('❌ Unexpected error adding todo: $e');
      print(stack);
      rethrow;
    }
  }

  @override
  Future<void> deleteTodo(String userId, String personaId, String todoId) async{
    try{
      if(todoId.isEmpty){
        throw ArgumentError('Todo ID cannot be null or empty for deletion.');
      }
      await _userTodos(userId, personaId).doc(todoId).delete();
    }on FirebaseException catch (e, stack) {
      print('🔥 Firebase error deleting todo: ${e.message}');
      print(stack);
      rethrow;
    } catch (e, stack) {
      print('❌ Unexpected error deleting todo: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateTodo(String userId, String personaId, Todo todo) async{
    try{
      if(todo.id == null){
        throw ArgumentError('Todo ID cannot be null for updates.');
      }
      final dto = TodoDto.fromDomain(todo);
      await _userTodos(userId, personaId).doc(todo.id).set(
      {...dto.toDocument(),
       'updatedAt': FieldValue.serverTimestamp( ),});
    }on FirebaseException catch (e, stack) {
      print('🔥 Firebase error updating todo: ${e.message}');
      print(stack);
      rethrow;
    } catch (e, stack) {
      print('❌ Unexpected error updating todo: $e');
      print(stack);
      rethrow;
    }
  }

  @override
  Stream<List<Todo>> watchTodos(String userId, String personaId) {
    return _userTodos(userId, personaId)
      .snapshots()
      .handleError((e, stack) {
        print('🔥 Error in watchTodos: $e');
      })
      .map((snap) => snap.docs
          .map((doc) => TodoDto.fromSnapshot(doc).toDomain())
          .toList());
  }
}
