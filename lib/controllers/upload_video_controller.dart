import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tictok_app/constants.dart';
import 'package:tictok_app/models/video.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoController extends GetxController {
  _compressVideo(String videopath) async {
    final compressedvideo = await VideoCompress.compressVideo(
      videopath,
      quality: VideoQuality.MediumQuality,
    );
    return compressedvideo!.file;
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('videos').child(id);
    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  _getThumbnail(String videopath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videopath);
    return thumbnail;
  }

  Future<String> _uploadImageToStorage(String id, String videopath) async {
    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videopath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadVideo(
    String songname,
    String caption,
    String videopath,
  ) async {
    try {
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();
      var allDoc = await firestore.collection('videos').get();
      int len = allDoc.docs.length;
      String videoUrl = await _uploadVideoToStorage("Video $len", videopath);
      String thumbnail = await _uploadImageToStorage('Video $len', videopath);
      Video video = Video(
          caption: caption,
          commentCount: 0,
          id: 'Video $len',
          likes: [],
          profilePhoto:
              (userDoc.data()! as Map<String, dynamic>)['profilePhoto'],
          shareCount: 0,
          songname: songname,
          thumbnail: thumbnail,
          uid: uid,
          username: (userDoc.data()! as Map<String, dynamic>)['name'],
          videoUrl: videoUrl);

      await firestore
          .collection('videos')
          .doc('Video $len')
          .set(video.toJason());

      Get.back();
      Get.snackbar('Upload status', 'video uploaded successfully');
    } catch (e) {
      Get.snackbar('Error Uploading video', e.toString());
    }
  }
}
