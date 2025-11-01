import 'package:get/get.dart';

enum SONotifierType { info, success, warning, error }

class SONotifier {
  const SONotifier({
    required this.id,
    this.message,
    this.type = SONotifierType.info,
  });

  final String id;
  final String? message;
  final SONotifierType type;
}

class SOGetXController extends GetxController {}
