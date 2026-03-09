# DEMO VIDEO PRESENTATION SCRIPT

## Complete Guide: What to Say & What Code to Show

---

##  VIDEO TIMELINE: 10 Minutes Total

---

## **PART 1: INTRODUCTION (0:00 - 1:30) - 1.5 minutes**

### **What to Say:**

"Hi, I'm demonstrating the Kigali Services Directory app, a mobile application built with Flutter and Firebase that helps users find and manage public service locations in Kigali, Rwanda.

Today I'll show you:
1. How users sign up and verify their email with Firebase Authentication
2. How to create, edit, and delete service listings
3. How search and filtering works with real-time data
4. How the map displays listings at their coordinates
5. How the entire application is architected with clean separation of concerns

The key thing I want to demonstrate is the **three-layer architecture** I used:
- **Service Layer** - Talks directly to Firebase
- **Provider Layer** - Manages application state
- **UI Layer** - Shows data to users

This separation ensures that data flows smoothly from Firestore through our state management into the UI automatically. Let me show you how this works with a real example."

### **Visual Setup:**
- ✅ Have VS Code open on one side with the project
- ✅ Have the app (Chrome with mobile emulator) on the other side
- ✅ Have Firebase Console ready to switch to
- ✅ Test your mic and screen recording

---

## **PART 2: ARCHITECTURE OVERVIEW (1:30 - 3:00) - 1.5 minutes**

### **What to Say:**

"Before we see the features, let me show you the project structure so you understand how everything is organized.

I'm using **Provider pattern for state management**, which is a Flutter best practice. Here's how it works:

**Layer 1: Services** (Direct Firebase Communication)
This is where all Firebase operations happen. Firebase is completely isolated from the UI.

**Layer 2: Providers** (State Management)
Providers listen to services and expose state to the UI. When Firestore data changes, the Provider notifies all listeners.

**Layer 3: UI (Widgets)**
UI widgets never call Firebase directly. They only listen to Providers and rebuild when Provider state changes.

Let me show you the folder structure:"

### **Code to Show:**

**Show Folder Structure in VS Code:**
```
Click on lib/ folder in VS Code
Expand to show:
lib/
├── services/              ← Firebase operations only
│   ├── auth_service.dart
│   └── listing_service.dart
├── providers/             ← State management
│   ├── auth_provider.dart
│   ├── listing_provider.dart
│   └── settings_provider.dart
├── screens/               ← UI only, no Firebase
│   ├── auth/
│   ├── directory/
│   ├── listings/
│   ├── map/
│   └── settings/
├── models/                ← Data structures
│   ├── user_model.dart
│   ├── listing_model.dart
│   └── category.dart
└── main.dart
```

**Say:** "This structure ensures:
- Services are testable and reusable
- Providers manage state consistently
- UI stays clean and simple
- Changes to Firebase automatically update all screens"

---

## **PART 3: AUTHENTICATION (3:00 - 4:30) - 1.5 minutes**

### **What to Say:**

"Let me start by showing you **Firebase Authentication with email verification**.

When a user signs up, three things happen:
1. Firebase Auth creates a login credential (email + password)
2. A verification email is sent
3. A user profile is created in Firestore with the user's details

The app won't let users access the Directory until they verify their email. This is important because it ensures only real email addresses can access the service.

Let me show you the code first, then demonstrate it in the app."

### **Code to Show:**

**Open: `lib/services/auth_service.dart`**

Show the `signUp()` method:

```dart
Future<UserCredential?> signUp({
  required String email,
  required String password,
  required String displayName,
}) async {
  try {
    // STEP 1: Create Firebase Auth user
    UserCredential userCredential = await _auth
        .createUserWithEmailAndPassword(email: email, password: password);

    // STEP 2: Send email verification
    await userCredential.user?.sendEmailVerification();

    // STEP 3: Update display name
    await userCredential.user?.updateDisplayName(displayName);

    // STEP 4: Create user profile in Firestore
    if (userCredential.user != null) {
      await _createUserProfile(userCredential.user!, displayName);
    }

    return userCredential;
  } on FirebaseAuthException catch (e) {
    throw _handleAuthException(e);
  }
}
```

**Explain each step:**
- Line 1-3: Firebase Auth creates account with email/password
- Line 5-6: Sends verification email to that address
- Line 8-9: Stores display name in Firebase Auth
- Line 11-14: Creates a Firestore document with user's profile data
- Line 16-17: If error, handle it gracefully

**Say:** "Notice how three things happen:
1. Firebase **Authentication** - Stores login credentials
2. Verification email - Security check
3. **Firestore user profile** - Stores additional user data

These are three separate systems working together."

### **Also Show: `_createUserProfile()` method**

```dart
Future<void> _createUserProfile(User user, String displayName) async {
  final userModel = UserModel(
    uid: user.uid,                    // Unique user ID from Firebase Auth
    email: user.email ?? '',
    displayName: displayName,
    emailVerified: user.emailVerified,  // Initially false
    createdAt: DateTime.now(),
  );

  // This is stored in Firestore at: users/{uid}
  await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
}
```

**Say:** "The UID (unique identifier) from Firebase Auth becomes the document ID in Firestore. This links everything together. When the user verifies their email, this field gets updated to true."

### **Now Show Sign In Logic:**

**Open: `lib/services/auth_service.dart` → `signIn()` method**

```dart
Future<UserCredential?> signIn({
  required String email,
  required String password,
}) async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // CHECK: Email must be verified
    if (userCredential.user != null && !userCredential.user!.emailVerified) {
      throw Exception('Please verify your email before signing in');
    }

    // If Firestore profile is missing, recreate it
    if (userCredential.user != null) {
      final profileExists = await _checkUserProfileExists(userCredential.user!.uid);
      if (!profileExists) {
        await _createUserProfile(userCredential.user!,
          userCredential.user!.displayName ?? 'User');
      }
    }

    return userCredential;
  } on FirebaseAuthException catch (e) {
    throw _handleAuthException(e);
  }
}
```

**Explain:**
- Lines 6-7: Check credentials against Firebase Auth
- Lines 10-13: **IMPORTANT** - Block login if email not verified
- Lines 15-21: Auto-recreate missing Firestore profile (handles deleted accounts)

### **Demo in App:**

1. **Click "Sign Up"**
2. **Fill form:**
   - Name: "Test User"
   - Email: "test@example.com"
   - Password: "Password123!"
   - Confirm: "Password123!"
3. **Click "Sign Up"**
4. **App shows:** "Email verification screen" with message "Check your email for verification link"

**Say:** "The app is now blocking access. Users can't do anything until they verify. Let me open the verification email."

5. **Open email → Click verification link**
6. **Return to app → Click "I've verified my email"**
7. **Now login works**

### **Show in Firebase Console:**

**Switch to Firebase Console:**
1. Click **Authentication** tab
2. **Show** the new user in the list
3. **Explain:** "This is the email/password credential in Firebase Auth"
4. Click on the user → Show `emailVerified: false` → `true` after verification
5. Click **Firestore Database** → `users` collection
6. **Show** the new user document with all profile fields
7. **Explain:** "This is the user's profile data we created with `_createUserProfile()`"

---

## **PART 4: CREATING LISTINGS (4:30 - 5:45) - 1.25 minutes**

### **What to Say:**

"Now let's see how **Creating listings works** with the three-layer architecture.

When a user creates a listing, data flows like this:
1. **UI Layer** - User fills a form
2. **Provider Layer** - Calls the service
3. **Service Layer** - Writes to Firestore
4. **Back to Provider** - Stream automatically detects new data
5. **Back to UI** - All screens showing listings rebuild automatically

Let me show you the code for each layer:"

### **Code to Show:**

#### **LAYER 1: Service (Firestore Write)**

**Open: `lib/services/listing_service.dart`**

Show `createListing()` method:

```dart
Future<void> createListing(ListingModel listing) async {
  try {
    // Converts listing to map and writes to Firestore
    await _firestore
        .collection('listings')           // Collection name
        .add(listing.toMap());            // Document data

    // That's it! The service only handles Firestore
  } catch (e) {
    throw Exception('Failed to create listing: $e');
  }
}
```

**Say:** "The service is simple - it just writes to Firestore. No business logic, no UI code. It's reusable and testable."

#### **LAYER 2: Provider (State Management)**

**Open: `lib/providers/listing_provider.dart`**

Show how provider listens to service:

```dart
class ListingProvider extends ChangeNotifier {
  final ListingService _service = ListingService();
  List<ListingModel> _allListings = [];
  
  Stream<List<ListingModel>> getListingsStream() {
    return _service.getListingsStream();  // Listens to Firestore stream
  }

  Future<void> createListing(ListingModel listing) async {
    try {
      await _service.createListing(listing);  // Calls service
      // Firestore stream automatically notifies when data is added
      notifyListeners();  // Tell UI to rebuild
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
```

**Say:** "The provider calls the service method. When Firestore updates, the stream notifies all listeners automatically. Then we call notifyListeners() so the UI rebuilds."

#### **LAYER 3: UI (The Form)**

**Open: `lib/screens/listings/create_listing_screen.dart`**

Show how UI uses provider:

```dart
class CreateListingScreen extends StatefulWidget {
  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  String category = '';
  // ... more fields

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // Create ListingModel
      final listing = ListingModel(
        title: title,
        description: description,
        category: category,
        latitude: latitude,
        longitude: longitude,
        // ... other fields
        createdBy: authProvider.user!.uid,  // Current user ID
        timestamp: DateTime.now(),
      );

      // Call Provider (NOT Firebase directly!)
      final listingProvider = Provider.of<ListingProvider>(context, listen: false);
      listingProvider.createListing(listing);
      
      Navigator.pop(context);  // Return to previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            onSaved: (value) => title = value!,
            // ... more fields
          ),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('Create Listing'),
          ),
        ],
      ),
    );
  }
}
```

**Say:** "Notice - the UI never calls Firestore. It only calls listingProvider.createListing(). The provider handles getting data to Firestore. This separation is crucial."

### **Demo in App:**

1. **Click "Create Listing" button**
2. **Fill the form:**
   - Title: "Kigali Central Hospital"
   - Description: "Main public hospital in Kigali"
   - Category: "Hospital"
   - Address: "KN 3 Ave, Kigali"
   - Phone: "+250-788-123-456"
   - Website: "hospital.rw"
   - Latitude: -1.9441
   - Longitude: 29.8739
3. **Click "Create"**

**Say:** "Now let me switch to Firebase Console while we watch this process..."

### **Show in Firebase Console (Real-Time):**

1. **Open Firestore → listings collection**
2. **Refresh or watch in real-time**
3. **NEW DOCUMENT APPEARS INSTANTLY**
4. **Show the data:**
   ```json
   {
     "title": "Kigali Central Hospital",
     "category": "Hospital",
     "latitude": -1.9441,
     "longitude": 29.8739,
     "createdBy": "user123uid",
     "timestamp": "2024-03-09..."
   }
   ```

**Say:** "See how the data appeared in Firestore immediately? That's the service writing to Firestore. Now let me switch back to the app to show how the Directory screen automatically updated:"

5. **Switch back to app → Click "Directory" tab**
6. **Show the new hospital listing appears instantly**

**Say:** "The Directory screen didn't refresh manually. It's listening to a Firestore stream via the Provider. When the document was created, the stream pushed the update, the Provider notified the widget, and it rebuilt automatically. This is real-time synchronization."

---

## **PART 5: SEARCH & FILTERING (5:45 - 6:45) - 1 minute**

### **What to Say:**

"**Search and filtering** work differently than CRUD operations. Instead of querying Firestore, we filter the data that's already loaded in memory via the Provider.

Here's why: The Directory screen has already loaded all listings from Firestore through the Provider's stream. Now when the user searches or filters, we apply those filters to the in-memory list. This is instant and doesn't require additional Firestore queries."

### **Code to Show:**

**Open: `lib/providers/listing_provider.dart`**

Show the search/filter methods:

```dart
void setSearchQuery(String query) {
  _searchQuery = query.toLowerCase();  // Make case-insensitive
  _applyFilters();  // Apply all filters
  notifyListeners();  // UI rebuilds
}

void setCategory(String? category) {
  _selectedCategory = category;
  _applyFilters();  // Apply all filters
  notifyListeners();  // UI rebuilds
}

List<ListingModel> get filteredListings {
  List<ListingModel> results = _allListings;
  
  // Apply search filter
  if (_searchQuery.isNotEmpty) {
    results = results.where((listing) =>
      listing.title.toLowerCase().contains(_searchQuery) ||
      listing.description.toLowerCase().contains(_searchQuery)
    ).toList();
  }
  
  // Apply category filter
  if (_selectedCategory != null) {
    results = results.where((listing) =>
      listing.category == _selectedCategory
    ).toList();
  }
  
  return results;
}
```

**Explain line by line:**
- Line 1: When user types in search box, call setSearchQuery()
- Line 2: Convert to lowercase so search is case-insensitive
- Line 3: Reapply all filters (this might sound weird, but read on...)
- Line 6-8: Same for category filter selection
- Line 11-29: The actual filtering logic
  - Start with all listings
  - If search text exists, filter by title or description match
  - If category selected, filter by category match
  - Return matching results

**Say:** "The filtering happens in the Provider, not in Firestore. We're just checking strings in the already-loaded list. This is instant because there's no network request."

### **Show in UI Code:**

**Open: `lib/screens/directory/directory_screen.dart`**

Show how UI uses filtered listings:

```dart
Consumer<ListingProvider>(
  builder: (context, provider, child) {
    return Column(
      children: [
        // Search box
        TextFormField(
          onChanged: (value) {
            provider.setSearchQuery(value);  // Call filter on each keystroke
          },
        ),
        
        // Category filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              FilterChip(
                label: Text('Hospital'),
                onSelected: (selected) {
                  provider.setCategory(selected ? 'Hospital' : null);
                },
              ),
              // ... more categories
            ],
          ),
        ),
        
        // Display filtered results
        Expanded(
          child: ListView.builder(
            itemCount: provider.filteredListings.length,
            itemBuilder: (context, index) {
              return ListingCard(
                listing: provider.filteredListings[index],
              );
            },
          ),
        ),
      ],
    );
  },
)
```

**Say:** "The UI uses Consumer<ListingProvider> to listen to the provider. When setSearchQuery() or setCategory() is called, the Provider's notifyListeners() tells the Consumer widget to rebuild with the new filteredListings."

### **Demo in App:**

1. **Go to Directory**
2. **Type in search box:** "Hospital"
3. **Show filtered results appear instantly**
4. **Clear search**
5. **Select category:** "Hospital" (FilterChip)
6. **Show only hospitals displayed**
7. **Select different category:** "Restaurant"
8. **Show only restaurants**
9. **Select multiple filters** (search + category)
10. **Show combined filtering works**

**Say:** "As you can see, search and filtering are instant because they're working with data already in memory. No waiting for network requests. The Provider manages the filtered list and notifies the UI whenever filters change."

---

## **PART 6: EDITING & DELETING (6:45 - 7:45) - 1 minute**

### **What to Say:**

"Now let's look at **Update and Delete operations**.

Important: Users can only edit or delete their own listings. The app checks that the `createdBy` field matches the current user ID before allowing these operations. This is enforced both in the app and in Firestore security rules."

### **Code to Show:**

#### **Show My Listings Screen First:**

**Open: `lib/screens/listings/my_listings_screen.dart`**

```dart
class MyListingsScreen extends StatefulWidget {
  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  @override
  void initState() {
    super.initState();
    _initializeUserListings();
  }

  void _initializeUserListings() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final listingProvider = Provider.of<ListingProvider>(context, listen: false);
    
    if (authProvider.user != null) {
      // IMPORTANT: Only initialize stream for current user
      listingProvider.initializeUserListingsStream(authProvider.user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return Consumer<ListingProvider>(
          builder: (context, listingProvider, _) {
            return ListView.builder(
              itemCount: listingProvider.userListings.length,
              itemBuilder: (context, index) {
                final listing = listingProvider.userListings[index];
                return ListingCard(
                  listing: listing,
                  showActions: true,  // Show edit/delete buttons
                  onEdit: () => _editListing(listing),
                  onDelete: () => _deleteListing(listing),
                );
              },
            );
          },
        );
      },
    );
  }

  void _editListing(ListingModel listing) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditListingScreen(listing: listing),
      ),
    );
  }

  void _deleteListing(ListingModel listing) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Listing?'),
        content: Text('Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<ListingProvider>(context, listen: false)
                  .deleteListing(listing.id);
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
```

**Explain:**
- Lines 6-11: initState() - Called when screen loads
- Lines 13-19: Initialize the stream to load ONLY current user's listings
- Line 18-19: **KEY**: `initializeUserListingsStream(userId)` - This queries Firestore with `where('createdBy', isEqualTo: userId)`
- Lines 34-36: Show edit/delete buttons
- Lines 50-56: Edit navigates to EditListingScreen with the listing data
- Lines 58-81: Delete shows confirmation dialog and calls deleteListing()

#### **Show Database Query:**

**Open: `lib/providers/listing_provider.dart`**

```dart
Future<void> initializeUserListingsStream(String userId) async {
  // This creates a Firestore query:
  // Get all listings where the 'createdBy' field equals the current user's ID
  
  _userListingsStream = _firestore
      .collection('listings')
      .where('createdBy', isEqualTo: userId)  // FILTER: Only user's listings
      .orderBy('timestamp', descending: true)  // SORT: Newest first
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => ListingModel.fromMap(doc.data(), doc.id))
          .toList());
          
  notifyListeners();  // Tell UI that stream is ready
}
```

**Say:** "This is a Firestore query. It says: 'Get all listings where createdBy equals userId'. The `.where()` method filters at the database level, so only matching documents are downloaded. This is efficient."

#### **Show Update Operation:**

**Open: `lib/services/listing_service.dart`**

```dart
Future<void> updateListing(ListingModel listing) async {
  try {
    await _firestore
        .collection('listings')
        .doc(listing.id)  // Specific document ID
        .update(listing.toMap());  // Update the fields
  } catch (e) {
    throw Exception('Failed to update listing: $e');
  }
}
```

**Say:** "Update is simple: we specify the document ID and pass new data. The fields in the map will be updated, others stay the same."

#### **Show Delete Operation:**

```dart
Future<void> deleteListing(String listingId) async {
  try {
    await _firestore
        .collection('listings')
        .doc(listingId)
        .delete();  // Remove the document
  } catch (e) {
    throw Exception('Failed to delete listing: $e');
  }
}
```

**Say:** "Delete just removes the document from Firestore. The id parameter identifies which document to delete."

#### **Show Firestore Security Rules:**

**Open: `firestore.rules`**

```
match /listings/{listingId} {
  allow read: if true;  // Anyone can read
  
  allow create: if request.auth != null;  // Only logged-in users can create
  
  allow update, delete: if request.auth.uid == resource.data.createdBy;
  // Only the user who created it can edit/delete
}
```

**Say:** "Firestore security rules enforce ownership. Even if someone modifies the app code, the rules will block unauthorized updates or deletes at the database level. This is defense in depth."

### **Demo in App:**

1. **Go to "My Listings"**
2. **Show all your created listings**
3. **Click edit button on one listing**
4. **Edit a field** (e.g., phone number)
5. **Click save**

**Say:** "Let me switch to Firebase Console to show the update..."

6. **Show in Firestore:** The listing document now has the new phone number
7. **Switch back to app:** "Notice My Listings already updated without refreshing. The stream from Firestore pushed the update automatically."

8. **Click delete button on a listing**
9. **Confirm delete**
10. **Show the listing disappears from My Listings**
11. **Switch to Firestore:** "The document is gone from the database"

---

## **PART 7: MAP INTEGRATION (7:45 - 8:45) - 1 minute**

### **What to Say:**

"The map feature shows all service locations on a map. Each listing has latitude and longitude coordinates stored in Firestore. The app retrieves these coordinates and displays markers on the map.

Let me show you how coordinates flow from Firestore into the map widget:"

### **Code to Show:**

#### **Firestore Data Structure:**

**Open: Firebase Console → Firestore → listings collection**

**Show a document:**
```json
{
  "title": "Kigali Central Hospital",
  "latitude": -1.9441,
  "longitude": 29.8739,
  ... other fields
}
```

**Say:** "Every listing has latitude and longitude. These are what the map uses to position markers."

#### **ListingModel holding coordinates:**

**Open: `lib/models/listing_model.dart`**

```dart
class ListingModel {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  
  final double latitude;   // ← Coordinate from Firestore
  final double longitude;  // ← Coordinate from Firestore
  
  final String category;
  final String address;
  // ... other fields
  
  ListingModel({
    required this.id,
    required this.title,
    required this.latitude,   // ← Must provide
    required this.longitude,  // ← Must provide
    // ...
  });
}
```

**Say:** "The ListingModel has latitude and longitude fields. When we load listings from Firestore, these fields are populated with the coordinates."

#### **Map Widget Implementation:**

**Open: `lib/screens/listings/listing_detail_screen.dart`**

```dart
class ListingDetailScreen extends StatelessWidget {
  final ListingModel listing;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(listing.title)),
      body: Column(
        children: [
          // Title and details...
          
          // Map showing this listing's location
          Container(
            height: 300,
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(
                  listing.latitude,    // ← From Firestore
                  listing.longitude,   // ← From Firestore
                ),
                zoom: 15,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 80,
                      height: 80,
                      point: LatLng(listing.latitude, listing.longitude),
                      builder: (ctx) => Container(
                        child: Icon(Icons.location_on, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Launch navigation button
          ElevatedButton(
            onPressed: () {
              // Open Google Maps with these coordinates
              final googleMapsUrl =
                'https://www.google.com/maps/search/?api=1&query=${listing.latitude},${listing.longitude}';
              launch(googleMapsUrl);
            },
            child: Text('Launch Navigation'),
          ),
        ],
      ),
    );
  }
}
```

**Explain section by section:**
- Line 9-11: Get the listing (passed to this screen)
- Line 22-25: Create map centered at listing's coordinates (from Firestore)
- Line 31-33: Tile layer - the actual map background (OpenStreetMap, free)
- Line 34-48: Marker layer - place a pin at the listing's location
- Line 44-45: Pin coordinates come directly from Firestore `listing.latitude` and `listing.longitude`
- Line 53-60: "Launch Navigation" button opens Google Maps with those same coordinates

**Say:** "The data flow is: Firestore → ListingModel → Map Widget. The coordinates from Firestore are used to center the map and position the marker."

#### **Map View with All Listings:**

**Open: `lib/screens/map/map_view_screen.dart`**

```dart
class MapViewScreen extends StatefulWidget {
  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ListingProvider>(
      builder: (context, provider, child) {
        return FlutterMap(
          options: MapOptions(
            center: LatLng(-1.9500, 29.8739),  // Center on Kigali
            zoom: 12,
          ),
          layers: [
            // Map tiles
            TileLayerOptions(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),
            
            // All listing markers
            MarkerLayerOptions(
              markers: provider.listings
                  .map((listing) => Marker(
                    point: LatLng(listing.latitude, listing.longitude),
                    builder: (ctx) => _buildMarker(listing),
                  ))
                  .toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMarker(ListingModel listing) {
    Color markerColor = _getCategoryColor(listing.category);
    return Container(
      decoration: BoxDecoration(
        color: markerColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(Icons.location_on, color: Colors.white),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Hospital':
        return Colors.red;
      case 'Police':
        return Colors.blue;
      case 'Restaurant':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
```

**Explain:**
- Line 10: Listen to ListingProvider to get all listings
- Line 24-28: For each listing in provider.listings, create a marker
- Line 25: `point: LatLng(listing.latitude, listing.longitude)` - Position from Firestore
- Line 38-43: Build colored circle for marker based on category
- Line 45-53: Different colors for different categories (Hospital=red, Police=blue, etc.)

**Say:** "This screen shows all listings from Firestore as color-coded markers. The Provider listens to the Firestore stream and automatically updates all markers when listings change."

### **Demo in App:**

1. **Click "Map View" tab**
2. **Show map with multiple markers**
3. **Point to different colored markers:** "Red is Hospital, Blue is Police, Orange is Restaurant"
4. **Click on a marker**
5. **App navigates to listing detail with that location's map**
6. **Show the marker positioned exactly at the coordinates**
7. **Click "Launch Navigation"**
8. **Google Maps opens** showing the location

---

## **PART 8: NAVIGATION & SETTINGS (8:45 - 9:30) - 45 seconds**

### **What to Say:**

"The app has four main screens accessible via bottom navigation:

1. **Directory** - Browse and search all listings
2. **My Listings** - User's created listings with edit/delete
3. **Map View** - All listings on a map
4. **Settings** - User profile and preferences"

### **Show Code:**

**Open: `lib/main.dart` → HomeScreen**

```dart
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;  // Track which tab is selected

  final List<Widget> _screens = [
    DirectoryScreen(),    // Tab 0
    MyListingsScreen(),   // Tab 1
    MapViewScreen(),      // Tab 2
    SettingsScreen(),     // Tab 3
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],  // Show selected screen
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Directory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_library_books),
            label: 'My Listings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
```

**Explain:**
- Line 7-12: Array of four screens
- Line 15: Show the current screen based on `_selectedIndex`
- Line 17-41: BottomNavigationBar with 4 buttons
- Line 24: When user taps a tab, update `_selectedIndex` and rebuild

### **Demo in App:**

1. **Click Directory tab** → Show directory with search/filter
2. **Click My Listings tab** → Show user's listings
3. **Click Map tab** → Show map view
4. **Click Settings tab** → Show user profile
5. **Click user profile area** → Show authentication user details
6. **Scroll down** → Show sign out button

---

## **PART 9: SUMMARY & ARCHITECTURE REVIEW (9:30 - 10:00) - 30 seconds**

### **What to Say:**

"Let me summarize what we saw:

**The complete data flow is:**
1. Firebase Firestore stores all data (users, listings)
2. Service layer directly communicates with Firestore
3. Provider listens to Firestore streams and manages state
4. UI widgets listen to Providers and rebuild automatically
5. When user takes action (create/edit/delete), UI calls Provider, Provider calls Service, Service updates Firestore
6. Firestore streams push updates, Provider notifies listeners, UI rebuilds
7. This cycle happens automatically without any manual refresh

**Why this architecture matters:**
- **Separation of concerns** - Each layer has one job
- **Reusability** - Services can be used by any provider
- **Testability** - Can test services without UI
- **Real-time updates** - UI always shows latest data
- **Auto-rebuild** - No manual refresh needed
- **Scalability** - Easy to add new features

**The complete code is on GitHub at:**
[Show GitHub URL: https://github.com/AnithaUwi/kigali_directory]

**Two documentation files explain this further:**
- IMPLEMENTATION_REFLECTION.md - Challenges and solutions
- DESIGN_SUMMARY.md - Architecture and design decisions

Thank you for watching!"

### **Final Visual:**

**Show on screen:**
- GitHub repository with all commits
- IMPLEMENTATION_REFLECTION.md
- DESIGN_SUMMARY.md
- Firebase project showing real data

---

## 📝 **KEY POINTS TO REMEMBER WHEN RECORDING:**

✅ **Speak clearly and at moderate pace** - Not too fast, not too slow
✅ **Show code as you explain it** - Pause code on screen long enough to read
✅ **Switch between app and Firebase Console** - Show database updates in real-time
✅ **Use specific file paths** - "In lib/services/listing_service.dart..."
✅ **Explain the WHY** - Not just "what" but "why this architecture"
✅ **Keep timestamp** - Should be 7-15 minutes (10 min is perfect)
✅ **Test before recording** - Create test listings, verify everything works
✅ **Record in good lighting** - Screen should be clear and readable
✅ **Have mic working** - People need to hear explanations clearly

---

## 🎬 **RECORDING CHECKLIST:**

- [ ] VS Code open on left side of screen
- [ ] App (Chrome mobile emulator) on right side
- [ ] Firebase Console browser tab ready
- [ ] GitHub tab ready
- [ ] Mic test - record first 10 seconds and listen
- [ ] Test screen recording quality
- [ ] Have test user email ready for signup demo
- [ ] Test account already created and verified for login
- [ ] Some sample listings already created
- [ ] Start with app fresh (no open modals or errors)
- [ ] Click record button
- [ ] Speak introduction twice if first one isn't perfect
- [ ] Take your time - it's okay to pause and redo sections

---

Good luck with your presentation! You've got this! 🎉
