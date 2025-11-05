import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';

class IDScannerPage extends StatefulWidget {
  const IDScannerPage({super.key});

  @override
  State<IDScannerPage> createState() => _IDScannerPageState();
}

class _IDScannerPageState extends State<IDScannerPage> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  bool _isProcessing = false;
  XFile? _capturedImage;
  FlashMode _currentFlashMode = FlashMode.off;
  bool _isCardDetected = false;
  bool _isProcessingStream = false;
  final TextRecognizer _textRecognizer = TextRecognizer();

  @override
  void initState() {
    super.initState();
    _requestPermissionAndInitialize();
  }

  Future<void> _requestPermissionAndInitialize() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      await _initializeCamera();
    } else if (status.isPermanentlyDenied) {
      Get.dialog(
        AlertDialog(
          title: const Text('Camera Permission Required'),
          content: const Text(
              'Camera permission has been permanently denied. Please go to settings to enable it.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Get.back(); // Close dialog
                Get.back(); // Go back from scanner page
              },
            ),
            TextButton(
              child: const Text('Settings'),
              onPressed: () {
                openAppSettings();
                Get.back(); // Close dialog
                Get.back(); // Go back from scanner page
              },
            ),
          ],
        ),
      );
    } else {
      Get.snackbar('Permission Denied', 'Camera permission is required to scan.');
      Get.back();
    }
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras == null || cameras!.isEmpty) {
      Get.snackbar('Error', 'No cameras found.');
      return;
    }
    controller = CameraController(cameras![0], ResolutionPreset.high, enableAudio: false);
    await controller!.initialize();
    await controller!.setFlashMode(FlashMode.off);
    controller!.startImageStream(_processCameraImage);
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    controller?.stopImageStream();
    controller?.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isProcessingStream || !mounted) return;
    _isProcessingStream = true;

    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) {
      _isProcessingStream = false;
      return;
    }

    final recognizedText = await _textRecognizer.processImage(inputImage);
    final isDetected = recognizedText.blocks.length > 5;

    if (mounted && isDetected != _isCardDetected) {
      setState(() => _isCardDetected = isDetected);
    }
    _isProcessingStream = false;
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    final camera = cameras![0];
    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          (sensorOrientation + controller!.value.deviceOrientation.index * 90) % 360;
      switch (rotationCompensation) {
        case 0:
          rotation = InputImageRotation.rotation0deg;
          break;
        case 90:
          rotation = InputImageRotation.rotation90deg;
          break;
        case 180:
          rotation = InputImageRotation.rotation180deg;
          break;
        case 270:
          rotation = InputImageRotation.rotation270deg;
          break;
        default:
          rotation = InputImageRotation.rotation0deg;
      }
    }
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  Future<void> _capturePhoto() async {
    if (controller == null) return;
    await controller!.stopImageStream();
    final image = await controller!.takePicture();
    if (mounted) setState(() => _capturedImage = image);
  }

  void _retakePhoto() {
    controller?.startImageStream(_processCameraImage);
    if (mounted) {
      setState(() {
        _capturedImage = null;
        _isCardDetected = false;
      });
    }
  }

  Future<void> _processImageAndGoBack() async {
    if (_capturedImage == null || _isProcessing) return;
    setState(() => _isProcessing = true);

    try {
      final inputImage = InputImage.fromFilePath(_capturedImage!.path);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      final data = _parseIneText(recognizedText.text);

      Get.back(result: {'data': data, 'imagePath': _capturedImage!.path});
    } catch (e) {
      Get.snackbar('Error', 'Failed to process image: $e');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

 Map<String, String> _parseIneText(String rawText) {
    final text = rawText.toUpperCase();
    final lines = text.split('\n');
    final data = <String, String>{};

    final curpRegex = RegExp(r'[A-Z]{4}\d{6}[HM][A-Z]{5}[A-Z0-9]{2}');
    final claveElectorRegex = RegExp(r'[A-Z]{6}\d{8}[HM]\d{3}');
    final seccionRegex = RegExp(r'SECCION\s*(\d+)');

    data['curp'] = curpRegex.firstMatch(text)?.group(0) ?? '';
    data['electorKey'] = claveElectorRegex.firstMatch(text)?.group(0) ?? '';
    data['section'] = seccionRegex.firstMatch(text)?.group(1) ?? '';

    for (int i = 0; i < lines.length; i++) {
      if (lines[i].contains('NOMBRE')) {
        if (i + 1 < lines.length) data['lastName'] = lines[i + 1];
        if (i + 2 < lines.length) data['motherLastName'] = lines[i + 2];
        if (i + 3 < lines.length) data['name'] = lines[i + 3];
      }
      if (lines[i].contains('DOMICILIO')) {
        if (i + 1 < lines.length) data['address'] = lines[i + 1];
      }
    }

    return data;
  }

  void _toggleFlash() {
    if (controller == null) return;
    final newMode = _currentFlashMode == FlashMode.off ? FlashMode.torch : FlashMode.off;
    controller!.setFlashMode(newMode);
    setState(() => _currentFlashMode = newMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Scan INE'),
          actions: [
            if (_capturedImage == null && controller != null)
              IconButton(
                  icon: Icon(_currentFlashMode == FlashMode.off ? Icons.flash_off : Icons.flash_on),
                  onPressed: _toggleFlash),
          ]),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBody() {
    if (_capturedImage != null) {
      return Stack(fit: StackFit.expand, children: [
        Center(child: Image.file(File(_capturedImage!.path))),
        if (_isProcessing)
          Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator())),
      ]);
    }
    if (controller == null || !controller!.value.isInitialized)
      return const Center(child: CircularProgressIndicator());
    return Stack(
        fit: StackFit.expand, children: [CameraPreview(controller!), _buildOverlay()]);
  }

  Widget? _buildFloatingActionButton() {
    if (_capturedImage != null) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        FloatingActionButton.extended(
            onPressed: _retakePhoto,
            icon: const Icon(Icons.refresh),
            label: const Text('Retake')),
        FloatingActionButton.extended(
            onPressed: _processImageAndGoBack,
            icon: const Icon(Icons.check),
            label: const Text('Use Photo')),
      ]);
    }
    return FloatingActionButton(
        onPressed: _capturePhoto,
        backgroundColor: _isCardDetected ? Colors.green : null,
        child: const Icon(Icons.camera_alt));
  }

  Widget _buildOverlay() {
    final color = _isCardDetected ? Colors.green : Colors.white;
    return Center(
      child: Container(
        width: Get.width * 0.9,
        height: Get.width * 0.9 * (1 / 1.586),
        decoration: BoxDecoration(
            border: Border.all(color: color, width: _isCardDetected ? 4.0 : 2.0),
            borderRadius: BorderRadius.circular(12.0)),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8)),
            child: Text(_isCardDetected ? 'Card Detected' : 'Align ID Card Here',
                style: TextStyle(
                    color: color, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
