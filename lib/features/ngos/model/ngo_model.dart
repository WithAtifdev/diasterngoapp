import 'package:cloud_firestore/cloud_firestore.dart';

enum NGOStatus { active, inactive, pending }

enum NGOCategory { rescue, medical, food, shelter, all }

extension NGOCategoryLabel on NGOCategory {
  String get label {
    switch (this) {
      case NGOCategory.rescue:
        return 'Rescue';
      case NGOCategory.medical:
        return 'Medical';
      case NGOCategory.food:
        return 'Food Relief';
      case NGOCategory.shelter:
        return 'Shelter';
      case NGOCategory.all:
        return 'All';
    }
  }

  static NGOCategory fromString(String value) {
    switch (value.toLowerCase()) {
      case 'rescue':
        return NGOCategory.rescue;
      case 'medical':
        return NGOCategory.medical;
      case 'food':
      case 'food relief':
        return NGOCategory.food;
      case 'shelter':
        return NGOCategory.shelter;
      default:
        return NGOCategory.rescue;
    }
  }
}

class NGOModel {
  final String id;
  final String name;
  final NGOCategory category;
  final String location;
  final String phone;
  final String email;
  final String description;
  final NGOStatus status;
  final String easypaisa;
  final String jazzcash;
  final String bankTransfer;
  final String? imageUrl;

  // UI fields
  final String? bannerUrl;
  final String? logoUrl;
  final List<String> categories;
  final DateTime? createdAt;
  const NGOModel({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.phone,
    required this.email,
    required this.description,
    required this.status,
    this.imageUrl,
    this.bannerUrl,
    this.logoUrl,
    this.categories = const [],
    this.createdAt,
    required this.bankTransfer,
    required this.easypaisa,
    required this.jazzcash,
  });
  factory NGOModel.fromMap(
      Map<String, dynamic> data,
      String docId,
      ) {
    return NGOModel(
      id: docId,
      name: data['name'] ?? '',
      category: NGOCategoryLabel.fromString(data['category'] ?? 'rescue'),
      location: data['location'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      description: data['description'] ?? '',
      status: _statusFromString(data['status'] ?? 'active'),
      imageUrl: data['imageUrl'],
      bannerUrl: data['bannerUrl'],
       logoUrl: data['logoUrl'],
      categories: List<String>.from(data['categories'] ?? []),
      createdAt:
      data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : null,
      easypaisa: data['easypaisa'] ?? '',
      jazzcash: data['jazzcash'] ?? '',
      bankTransfer: data['bankTransfer'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category.label,
      'location': location,
      'phone': phone,
      'email': email,
      'description': description,
      'status': status.name,
      'imageUrl': imageUrl,
      'bannerUrl': bannerUrl,
      'logoUrl': logoUrl,
      'categories': categories,
      'easypaisa': easypaisa,
      'jazzcash': jazzcash,
      'bankTransfer': bankTransfer,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }

  NGOModel copyWith({
    String? id,
    String? name,
    NGOCategory? category,
    String? location,
    String? phone,
    String? email,
    String? description,
    NGOStatus? status,
    String? imageUrl,
    String? bannerUrl,
    String? easypaisa,
    String? jazzcash,
    String? bankTransfer,
    String? logoUrl,
    List<String>? categories,
    DateTime? createdAt,
  }) {
    return NGOModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      location: location ?? this.location,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      description: description ?? this.description,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      logoUrl: logoUrl ?? this.logoUrl,
      categories: categories ?? this.categories,
      easypaisa: easypaisa ?? this.easypaisa,
      jazzcash: jazzcash ?? this.jazzcash,
      bankTransfer:
      bankTransfer ?? this.bankTransfer,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static NGOStatus _statusFromString(String value) {
    switch (value.toLowerCase()) {
      case 'inactive':
        return NGOStatus.inactive;
      case 'pending':
        return NGOStatus.pending;
      default:
        return NGOStatus.active;
    }
  }
}