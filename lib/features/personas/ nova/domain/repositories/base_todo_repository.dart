import '../entities/todo.dart';

abstract class BaseTodoRepository {
  Future<void> addTodo(String userId, String personaId, Todo todo);
  Future<void> updateTodo(String userId, String personaId, Todo todo);
  Future<void> deleteTodo(String userId, String personaId, String todoId);
  Stream<List<Todo>> watchTodos(String userId, String personaId);
}
