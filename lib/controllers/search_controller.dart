import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tictok_app/constants.dart';
import 'package:tictok_app/models/user_model.dart';

class SearchController extends GetxController {
  final Rx<List<User>> _searchedUsers = Rx<List<User>>([]);

  List<User> get searchedUsers => _searchedUsers.value;
  searchUser(String typeUser) async {
    _searchedUsers.bindStream(
      firestore
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: typeUser)
          .snapshots()
          .map(
        (QuerySnapshot query) {
          List<User> retValue = [];
          for (var elem in query.docs) {
            retValue.add(User.fromSnap(elem));
          }
          return retValue;
        },
      ),
    );
  }
}
