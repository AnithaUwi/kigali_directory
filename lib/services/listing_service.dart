import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/listing_model.dart';
import '../models/category.dart';

class ListingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'listings';

  // Get all listings as a stream
  Stream<List<ListingModel>> getAllListings() {
    return _firestore
        .collection(_collection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ListingModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  // Get listings by user
  Stream<List<ListingModel>> getListingsByUser(String userId) {
    return _firestore
        .collection(_collection)
        .where('createdBy', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ListingModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  // Get listings by category
  Stream<List<ListingModel>> getListingsByCategory(Category category) {
    return _firestore
        .collection(_collection)
        .where('category', isEqualTo: category.value)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ListingModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  // Create a new listing
  Future<void> createListing(ListingModel listing) async {
    try {
      await _firestore.collection(_collection).add(listing.toMap());
    } catch (e) {
      throw Exception('Failed to create listing: $e');
    }
  }

  // Update a listing
  Future<void> updateListing(ListingModel listing) async {
    try {
      if (listing.id == null) {
        throw Exception('Listing ID cannot be null');
      }
      await _firestore
          .collection(_collection)
          .doc(listing.id)
          .update(listing.toMap());
    } catch (e) {
      throw Exception('Failed to update listing: $e');
    }
  }

  // Delete a listing
  Future<void> deleteListing(String listingId) async {
    try {
      await _firestore.collection(_collection).doc(listingId).delete();
    } catch (e) {
      throw Exception('Failed to delete listing: $e');
    }
  }

  // Get a single listing
  Future<ListingModel?> getListing(String listingId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_collection)
          .doc(listingId)
          .get();
      if (doc.exists) {
        return ListingModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get listing: $e');
    }
  }

  // Search listings by name
  Future<List<ListingModel>> searchListings(String query) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(_collection).get();

      List<ListingModel> allListings = snapshot.docs
          .map(
            (doc) => ListingModel.fromMap(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();

      // Filter by name (case-insensitive)
      return allListings
          .where(
            (listing) =>
                listing.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to search listings: $e');
    }
  }
}
