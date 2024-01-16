import 'package:docotors_02/app/database/firebase_service.dart';
import 'package:firebase_database/firebase_database.dart';

class DataService {
  late String name;
  late String age;

  DataService(this.name, this.age);

  final DatabaseReference _dbRef =
      FirebaseService().databaseRef.child('person');

  Future<void> createItem(String name, String age) async {
    final newItemRef = _dbRef.push();
    await newItemRef.set({
      'name': name,
      'age': age,
    });
  }

  Future<DatabaseEvent> readItems() async {
    return await _dbRef.once();
  }

  Future<void> updateItem(String itemId, String newName, String age) async {
    final itemRef = _dbRef.child('person');
    await itemRef.update({
      'name': newName,
      'age': age,
    });
  }

  Future<void> deleteItem(String itemId) async {
    final itemRef = _dbRef.child(itemId);
    await itemRef.remove();
  }
}
