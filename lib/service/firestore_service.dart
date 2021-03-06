import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FireStoreService {
  //* private constructor
  FireStoreService._();
  //* синглтон инстанса
  static final instance = FireStoreService._();

  Future<void> setData({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);

    //! await убираем
    reference.set(data);
  }

  Future<void> deleteData({@required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('delete: $path');

    //! await убираем
    reference.delete();
  }

  Future<void> deleteAllDone({@required String path}) async {
    //TODO в цикле удалить все документы

    //? получаем список всех доков по заданному пути
    //? удаляем все документы

    FirebaseFirestore.instance.collection(path).get().then((value) => {
          value.docs.forEach((element) {
            if (element['isDeleted'] == true) {
              var ref = element.reference;
              ref.delete();
            }
          })
        });
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data) builder,
  }) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map(
          (snapshot) => builder(snapshot.data()),
        )
        .toList());
  }
}
