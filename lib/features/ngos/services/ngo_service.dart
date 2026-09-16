import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaster_ngo_app/features/ngos/model/ngo_model.dart';



final List<Map<String, dynamic>> _seedNGOs = [
  {
    'id': 'rescue_1122',
    'name': 'Rescue 1122',
    'category': 'Rescue',
    'location': 'KPK Region',
    'phone': '1122',
    'email': 'rescue@pk.gov',
    'description': 'Government emergency rescue service operating 24/7.',
    'status': 'active',
    'imageUrl': 'assets/images/Rescue1122.jpeg',
  },
  {
    'id': 'edhi_foundation',
    'name': 'Edhi Foundation',
    'category': 'Medical',
    'location': 'Pakistan',
    'phone': '021-111-111',
    'email': 'info@edhi.org',
    'description': 'Pakistan\'s largest private welfare organization providing ambulance, medical, and shelter services.',
    'status': 'active',
    'imageUrl': 'assets/images/edhi_foundation.jpeg',
  },
  {
    'id': 'alkhidmat',
    'name': 'Al-Khidmat Foundation',
    'category': 'Food Relief',
    'location': 'Pakistan',
    'phone': '0800-22222',
    'email': 'info@alkhidmat.org',
    'description': 'Provides food, shelter, and humanitarian aid across Pakistan.',
    'status': 'active',
    'imageUrl': 'assets/images/alhidmat.png',
  },
  {
    'id': 'srsp',
    'name': 'SRSP',
    'category': 'Shelter',
    'location': 'Peshawar',
    'phone': '091-111-777',
    'email': 'info@srsp.org.pk',
    'description': 'Sarhad Rural Support Programme — community development and disaster response.',
    'status': 'active',
    'imageUrl': 'assets/images/Srsp_support.png',
  },
];

class NGOService {
  final FirebaseFirestore _firestore;
  final String _collection = 'ngos';

  NGOService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;
  Stream<List<NGOModel>> watchNGOs() {
    return _firestore
        .collection(_collection)
        .orderBy(
      'createdAt',
      descending: false,
    )
        .snapshots()
        .map((snap) {
      if (snap.docs.isEmpty) {
        return _seedFallback();
      }

      return snap.docs.map((doc) {
        return NGOModel.fromMap(
          doc.data(),
          doc.id,
        );
      }).toList();
    });
  }

  Future<void> registerNGO(NGOModel ngo) async {
    /// NGO create
    await _firestore.collection(_collection).add(ngo.toMap());
  }

  Future<void> updateNGO(NGOModel ngo) async {
    await _firestore
        .collection(_collection)
        .doc(ngo.id)
        .update(ngo.toMap());
  }

  List<NGOModel> _seedFallback() {
    return _seedNGOs.map((data) {
      return NGOModel(
        id: data['id'] as String,
        name: data['name'] as String,
        category: NGOCategoryLabel.fromString(data['category'] as String),
        location: data['location'] as String,
        phone: data['phone'] as String,
        email: data['email'] as String,
        description: data['description'] as String,
        status: NGOStatus.active,
        imageUrl: data['imageUrl'] as String,
        easypaisa: '',
        jazzcash: '',
        bankTransfer: '',
      );
    }).toList();
  }
}