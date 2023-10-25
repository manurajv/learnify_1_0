import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:learnify_1_0/home_screen.dart';
import 'auth_service.dart';
import 'firebase_service.dart';

class FaceRecognitionScreen extends StatefulWidget {
  late final VoidCallback registerCallback;
  FaceRecognitionScreen({required this.registerCallback});
  @override
  _FaceRecognitionScreenState createState() => _FaceRecognitionScreenState();
}

class _FaceRecognitionScreenState extends State<FaceRecognitionScreen> {
  late CameraController _cameraController;
  int _selectedCameraIndex = 0;
  bool _isCameraInitialized = false;
  FaceDetector? _faceDetector;
  AuthService _authService = AuthService();
  List<Uint8List> _registeredFaces = [];

  // State variable to indicate whether registration is in progress
  bool _isRegistrationInProgress = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeFaceDetector();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      // Handle the case when no cameras are available on the device
      return;
    }

    final camera = cameras[_selectedCameraIndex];

    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium, // Adjust resolution as needed
    );

    try {
      await _cameraController.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _initializeFaceDetector() async {
    _faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        enableClassification: true,
        enableLandmarks: true,
      ),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _faceDetector?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Face Recognition"),
        actions: [
          IconButton(
            icon: Icon(Icons.switch_camera),
            onPressed: _toggleCamera,
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: _cameraController.value.aspectRatio,
              child: CameraPreview(_cameraController),
            ),
            if (!_isRegistrationInProgress)
              ElevatedButton(
                onPressed: _captureFaceData,
                child: Text("Register Face"),
              ),
            if (_isRegistrationInProgress)
              Text("Performing face registration..."),
          ],
        ),
      ),
    );
  }

  void _captureFaceData() async {
    if (_cameraController.value.isTakingPicture) {
      return;
    }

    setState(() {
      _isRegistrationInProgress = true;
    });

    try {
      final XFile imageFile = await _cameraController.takePicture();

      // Process the captured image with Google ML Kit
      final inputImage = InputImage.fromFilePath(imageFile.path);
      final List<Face> faces = await _faceDetector!.processImage(inputImage);

      if (faces.isNotEmpty) {
        // Faces were detected in the image
        for (final Face face in faces) {
          // Process and save face data as needed
          final faceBounds = face.boundingBox;
          final landmarks = face.landmarks;

          final leftEye = landmarks[FaceLandmarkType.leftEye]!;
          final rightEye = landmarks[FaceLandmarkType.rightEye]!;
          final noseBase = landmarks[FaceLandmarkType.noseBase]!;
          final bottomMouth = landmarks[FaceLandmarkType.bottomMouth]!;
          // You can extract other relevant face data as needed


          //Update firebase authentication details
          widget.registerCallback();

          // Save the captured image and face data
          // Upload it to Firebase Cloud Storage or your preferred storage solution
          final imageUrl = await FirebaseService.instance
              .uploadImageToStorage(
              imageFile, _authService.getCurrentUser()!.uid);

          //await FirebaseService.instance.processAndSaveImage(imageFile, _authService.getCurrentUser()!.uid);

          if (imageUrl != null) {
            // Associate the image URL with the user's account
            await FirebaseService.instance.associateImageWithUser(
                _authService.getCurrentUser()!.uid, imageUrl);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HomeScreen(),
              ),
            );
          }

          // } else {
          //   // The user's face is recognized, show an error message
          //   showFaceRecognized(context);
          // }

        }
      } else {
        // No faces were detected in the image
        print('No faces detected.');
        showNoFaceDetected(context);
      }
    } catch (e) {
      print('Error capturing image: $e');
      showNoFaceDetected(context);
    } finally {
      setState(() {
        _isRegistrationInProgress = false;
      });
    }
  }

  void _toggleCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      return;
    }

    setState(() {
      _selectedCameraIndex = (_selectedCameraIndex + 1) % cameras.length;
    });

    await _cameraController.dispose();
    await _initializeCamera();
  }

  void showNoFaceDetected(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No face Detected'),
          content: Text('Please try to capture face again in good light condition'),
          actions: <Widget>[
            TextButton(
              child: Text('Capture Again'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showFaceRecognized(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Face Recognized'),
          content: Text('The face is recognized. Please try again or contact support.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}


