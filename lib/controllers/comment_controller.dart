import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tictok_app/constants.dart';
import 'package:tictok_app/models/comment.dart';

class CommentController extends GetxController {
  final Rx<List<Comment>> _comments = Rx<List<Comment>>([]);
  List<Comment> get comments => _comments.value;
  String _postId = "";
  updatePostId(String id) {
    _postId = id;
    getComment();
  }

  getComment() async {}

  postComment(String commentText) async {
    try {
      if (commentText.isNotEmpty) {
        DocumentSnapshot userDoc = await firestore
            .collection('users')
            .doc(authController.user.uid)
            .get();
        var allDocs = await firestore.collection('comments').get();
        int len = allDocs.docs.length;
        Comment comment = Comment(
          comment: commentText.trim(),
          datePublished: DateTime.now(),
          id: 'Comment $len',
          likes: [],
          profilePhoto: (userDoc.data() as dynamic)['profilePhoto'],
          uid: authController.user.uid,
          username: (userDoc.data() as dynamic)['username'],
        );
        await firestore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .doc('Comment $len')
            .set(comment.toJason());
      }
    } catch (e) {
      Get.snackbar('Error while Commenting', e.toString());
    }
  }
}
