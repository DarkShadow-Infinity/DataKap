import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUserModel {
  AdminUserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.role,
    required this.goal,
    required this.verificationCode,
    required this.status,
    required this.isActive,
    required this.createdAt,
  });

  factory AdminUserModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return AdminUserModel(
      id: doc.id,
      email: data['email'] as String? ?? '',
      fullName: data['fullName'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      role: data['role'] as String? ?? 'promoter',
      goal: data['goal'] as int? ?? 0,
      verificationCode: data['verificationCode'] as String? ?? '',
      status: data['status'] as String? ?? 'registered',
      isActive: data['isActive'] as bool? ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  final String id;
  final String email;
  final String fullName;
  final String phone;
  final String role;
  final int goal;
  final String verificationCode;
  final String status;
  final bool isActive;
  final DateTime createdAt;

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'role': role,
      'goal': goal,
      'verificationCode': verificationCode,
      'status': status,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  AdminUserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phone,
    String? role,
    int? goal,
    String? verificationCode,
    String? status,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return AdminUserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      goal: goal ?? this.goal,
      verificationCode: verificationCode ?? this.verificationCode,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
