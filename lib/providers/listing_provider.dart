import 'package:flutter/material.dart';
import '../config/demo_config.dart';
import '../data/mock_data.dart';
import '../models/listing_model.dart';
import '../models/category.dart';
import '../services/listing_service.dart';

class ListingProvider with ChangeNotifier {
  final ListingService _listingService = ListingService();

  List<ListingModel> _listings = [];
  List<ListingModel> _userListings = [];
  List<ListingModel> _filteredListings = [];

  bool _isLoading = false;
  String? _errorMessage;
  Category? _selectedCategory;
  String _searchQuery = '';

  List<ListingModel> get listings => _filteredListings;
  List<ListingModel> get userListings => _userListings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Category? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  void initializeListingsStream() {
    if (DEMO_MODE) {
      Future.microtask(() {
        _listings = getMockListings();
        _applyFilters();
        notifyListeners();
      });
    } else {
      _listingService.getAllListings().listen(
        (listingsList) {
          _listings = listingsList;
          _applyFilters();
          notifyListeners();
        },
        onError: (error) {
          _errorMessage = 'Failed to load listings: $error';
          notifyListeners();
        },
      );
    }
  }

  void initializeUserListingsStream(String userId) {
    if (DEMO_MODE) {
      _userListings =
          getMockListings().where((l) => l.createdBy == 'demo-user').toList();
      notifyListeners();
    } else {
      _listingService.getListingsByUser(userId).listen(
        (listingsList) {
          _userListings = listingsList;
          notifyListeners();
        },
        onError: (error) {
          _errorMessage = 'Failed to load your listings: $error';
          notifyListeners();
        },
      );
    }
  }

  void _applyFilters() {
    _filteredListings = _listings.where((listing) {
      bool matchesSearch = _searchQuery.isEmpty ||
          listing.name.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesCategory =
          _selectedCategory == null || listing.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void setCategory(Category? category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    _applyFilters();
    notifyListeners();
  }

  Future<bool> createListing(ListingModel listing) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      if (DEMO_MODE) {
        await Future.delayed(const Duration(milliseconds: 500));
        _listings.add(listing);
        _userListings.add(listing);
        _applyFilters();
      } else {
        await _listingService.createListing(listing);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateListing(ListingModel listing) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      if (DEMO_MODE) {
        await Future.delayed(const Duration(milliseconds: 500));
        int index = _listings.indexWhere((l) => l.id == listing.id);
        if (index != -1) {
          _listings[index] = listing;
        }
        int userIndex = _userListings.indexWhere((l) => l.id == listing.id);
        if (userIndex != -1) {
          _userListings[userIndex] = listing;
        }
        _applyFilters();
      } else {
        await _listingService.updateListing(listing);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteListing(String listingId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      if (DEMO_MODE) {
        await Future.delayed(const Duration(milliseconds: 500));
        _listings.removeWhere((l) => l.id == listingId);
        _userListings.removeWhere((l) => l.id == listingId);
        _applyFilters();
      } else {
        await _listingService.deleteListing(listingId);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearUserListings() {
    _userListings = [];
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
