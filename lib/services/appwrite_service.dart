import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:on_time/services/collection_ids.dart';

class AppwriteService {
  final Client _client = Client();
  late final Account _account;
  late final Databases _databases;
  final String dbId = "6795113b000bf45203a7";
  final CollectionIds collectionIds = CollectionIds(
    tasks: "67a7a3d0003093d673e0",
    workouts: "67a7a0ee00212afdc490",
    exercises: "67a7fc860016fce94754",
  );

  AppwriteService() {
    _initializeClient();
  }

  void _initializeClient() {
    _client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('678aa790002d7c50d1a8');
    _account = Account(_client);
    _databases = Databases(_client);
  }

  /// Register a new user
  Future<void> registerUser({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      await _account.create(
        name: username,
        email: email,
        password: password,
        userId: ID.unique(),
      );
      print('Registration successful!');
    } catch (e) {
      print('Registration Error: $e');
      rethrow;
    }
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _account.createEmailPasswordSession(email: email, password: password);
      print('Login successful!');

      // Check if the session is valid
      final session = await _account.getSession(sessionId: 'current');
      print('Session ID: ${session.$id}');
    } catch (e) {
      print('Login Error: $e');
      rethrow;
    }
  }

  Future<String> getUsername() async {
    String username;
    try {
      username = (await _account.get()).name;
    } catch (e) {
      print("Fetching error: $e");
      rethrow;
    }
    return username;
  }

  /// Logout user
  Future<void> logoutUser() async {
    try {
      // Get the current session
      final session = await _account.getSession(sessionId: 'current');
      await _account.deleteSession(sessionId: session.$id);
      print('Logout successful!');
    } catch (e) {
      print('Logout Error: $e');
      rethrow;
    }
  }

  Future<bool> hasActiveSession() async {
    try {
      final session = await _account.getSession(sessionId: 'current');
      return session.$id.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  void deleteSessionId() async {
    if((await hasActiveSession())) {
      logoutUser();
    }
  }

  Future<String> getUserEmail() async => (await _account.get()).email;

  Future<String> getCurrentUserId() async {
    try {
      final user = await _account.get();
      return user.$id;
    } catch (e) {
      print("Error getting current user ID: $e");
      rethrow;
    }
  }

  Future<List<Document>> getTasks(String userId) async {
    try {
      final response = await _databases.listDocuments(
        databaseId: dbId,
        collectionId: collectionIds.tasks,
        queries: [
          Query.equal('userId', userId),
        ],
      );
      return response.documents;
    } catch (e) {
      print("Error fetching tasks: $e");
      rethrow;
    }
  }

  Future<void> addTask(Map<String, dynamic> task) async {
    try {
      await _databases.createDocument(
        databaseId: dbId,
        collectionId: collectionIds.tasks,
        documentId: ID.unique(),
        data: task,
      );
    } catch (e) {
      print("Adding Error: $e");
      rethrow;
    }
  }

  Future<void> updateTask(Map<String, dynamic> task) async {
    try {
      final userId = await getCurrentUserId();
      final documents = await getTasks(userId);

      await _databases.updateDocument(
        databaseId: dbId,
        collectionId: collectionIds.tasks,
        documentId: documents.firstWhere((t) => t.data["id"] == task["id"]).$id,
        data: Map.from(task)..removeWhere((k, v) => k.startsWith("\$")),
      );
    } catch (e) {
      print("Update Error: $e");
      rethrow;
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      final userId = await getCurrentUserId();
      final documents = await getTasks(userId);

      await _databases.deleteDocument(
        databaseId: dbId,
        collectionId: collectionIds.tasks,
        documentId: documents.firstWhere((t) => t.data["id"] == id).$id,
      );
    } catch (e) {
      print("Delete Error: $e");
      rethrow;
    }
  }

  Future<List<Document>> getExercisesTable() async =>
      (await _databases.listDocuments(
        databaseId: dbId,
        collectionId: collectionIds.exercises,
      )).documents;

  Future<List<Document>> getWorkouts() async =>
      (await _databases.listDocuments(
        databaseId: dbId,
        collectionId: collectionIds.workouts,
      )).documents;

  void addWorkout(Map<String, dynamic> workout) async {
    workout.addAll({ "user_id": (await _account.get()).$id });
    try {
      await _databases.createDocument(
        databaseId: dbId,
        collectionId: collectionIds.workouts,
        documentId: ID.unique(),
        data: workout,
      );
    } catch (e) {
      print("Adding Error: $e");
      rethrow;
    }
  }

  Future<Document> addExercise(Map<String, dynamic> exercise) async =>
      await _databases.createDocument(
        databaseId: dbId,
        collectionId: collectionIds.exercises,
        documentId: ID.unique(),
        data: {},
      );

  void addExercises(String workoutName, List<Map<String, dynamic>> exercises) async {
    try {
      final workouts = await getWorkouts();

      for (Map<String, dynamic> exercise in exercises) {
        await _databases.updateDocument(
          databaseId: dbId,
          collectionId: collectionIds.workouts,
          documentId: workouts.firstWhere((workout) => workout.data["name"] == workoutName).$id,
          data: {
            "name": workoutName,
            "user_id": (await _account.get()).$id,
            "exercise_id": (await addExercise(exercise)).$id,
          },
        );
      }
    } catch (e) {
      print("Adding Error: $e");
      rethrow;
    }
  }
}