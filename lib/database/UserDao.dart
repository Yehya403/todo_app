import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/User.dart';

class UserDao {
  static CollectionReference<User> getUsersCollection() {
    var db = FirebaseFirestore.instance;
    var usersCollection = db
        .collection(User.collectionName)
        .withConverter<User>(
          fromFirestore: (snapshot, _) => User.fromFireStore(snapshot.data()!),
          toFirestore: (user, _) => user.toFireStore(),
        );
    return usersCollection;
  }

  static Future<void> createUser(User user) {
    var usersCollection = getUsersCollection();
    var doc = usersCollection.doc(user.id);
    return doc.set(user);
  }

  static Future<User?> getUser(String? uid) async {
    var usersCollection = getUsersCollection();
    var doc = usersCollection.doc(uid);
    var docSnapshot = await doc.get();
    return docSnapshot.data();
  }
}
