import 'package:firebase_database/firebase_database.dart';
import 'package:salon_user/backend/database_key.dart';

class DatabaseRef {
  static final DatabaseReference data = FirebaseDatabase.instance.ref();
  static final DatabaseReference vendor = data.child(DatabaseKey.vendor);
  static final DatabaseReference admin = data.child(DatabaseKey.admin);
  static final DatabaseReference category = data.child(DatabaseKey.category);
  static final DatabaseReference service = data.child(DatabaseKey.service);
  static final DatabaseReference staff = data.child(DatabaseKey.staff);
}
