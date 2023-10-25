import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as img;

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseService._privateConstructor();

  static final FirebaseService instance = FirebaseService._privateConstructor();

  Future<List<Face>> detectFaces(InputImage inputImage) async {
    // Initialize the face detector
    final FaceDetector faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        enableClassification: true,
        enableLandmarks: true,
      ),
    );

    try {
      return await faceDetector.processImage(inputImage);
    } catch (e) {
      print('Error detecting faces: $e');
      return [];
    } finally {
      faceDetector.close();
    }
  }

  Future<String?> uploadImageToStorage(XFile imageFile, String userId) async {
    final storage = FirebaseStorage.instance;
    final Reference storageReference = storage.ref().child(
        'user_images/$userId.jpg');
    final UploadTask uploadTask = storageReference.putFile(
        File(imageFile.path));

    try {
      await uploadTask;
      final imageUrl = await storageReference.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> processAndSaveImage(XFile capturedImage, String userId) async {
    // final storage = FirebaseStorage.instance;
    // final Reference storageReference = storage.ref().child('user_image/$userId.jpg');
    //
    // try {
    //   // Load the captured image
    //   final File imageFile = File(capturedImage.path);
    //
    //   // Read and decode the image
    //   final img.Image originalImage = img.decodeImage(imageFile.readAsBytesSync())!;
    //
    //   // Resize the image to the desired width and height
    //   final img.Image resizedImage = img.copyResize(
    //     originalImage,
    //     width: 224,
    //     height: 224,
    //   );
    //
    //   // Rotate the image to the desired rotation degrees
    //   final img.Image rotatedImage = img.copyRotate(
    //       resizedImage,
    //       angle: 0,
    //   );
    //
    //   // Encode the processed image as bytes
    //   final Uint8List processedImageBytes = img.encodeJpg(rotatedImage);
    //
    //   // Upload the processed image to Firebase Cloud Storage
    //   await storageReference.putData(processedImageBytes);
    //
    //   print('Processed image uploaded successfully');
    // } catch (e) {
    //   print('Error processing and saving image: $e');
    // }
  }

  Future<void> associateImageWithUser(String userId, String imageUrl) async {
    try {
      // Update the user's profile image URL in Firestore
      final CollectionReference usersCollection = FirebaseFirestore.instance
          .collection('users');

      // Replace this with your Firestore update logic
      try {
        // Update the 'profileImage' field with the new imageUrl
        await usersCollection.doc(userId).update({
          'profileImage': imageUrl,
        });
        print('Profile image URL updated successfully');
      } catch (e) {
        print('Error updating profile image URL: $e');
      }
    } catch (e) {
      print('Error updating user profile image: $e');
    }
  }

}