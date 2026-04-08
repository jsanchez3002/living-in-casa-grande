# Living in Casa Grande — Data Sync & Integration Architecture

**Version 1.0 | April 8, 2026**

---

## Overview

Living in Casa Grande app connects to:
1. **Firebase** (primary backend)
2. **livingincasagrande.com** (website data)
3. **External APIs** (future integrations)

This document explains how data flows between all systems.

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        LIVING IN CASA GRANDE                        │
│                         Complete Ecosystem                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                         │
│   ┌─────────────────────┐         ┌─────────────────────────────┐   │
│   │ livingincasagrande  │◄───────►│  Living in Casa Grande App  │   │
│   │       .com          │   Sync  │        (SwiftUI)           │   │
│   │                     │         │                             │   │
│   │ • WordPress/WP      │         │ • Events (real-time)       │   │
│   │ • Real estate       │         │ • Business Directory        │   │
│   │   listings          │         │ • Dating profiles           │   │
│   │ • Blog posts        │         │ • Marketplace              │   │
│   │ • Lead capture      │         │ • Jobs board               │   │
│   │ • Contact forms     │         │ • Housing/Rentals          │   │
│   └──────────┬──────────┘         └──────────────┬──────────────┘   │
│              │                                      │                  │
│              │            ┌────────────────────────┘                  │
│              │            │                                           │
│              ▼            ▼                                           │
│   ┌─────────────────────────────────────────────────────────────┐   │
│   │                    FIREBASE BACKEND                          │   │
│   │                                                              │   │
│   │  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │   │
│   │  │ Authentication│  │ Firestore   │  │ Cloud Storage      │  │   │
│   │  │ (Apple/Google│  │ Database    │  │ (Images/Files)    │  │   │
│   │  │ Sign-In)    │  │             │  │                   │  │   │
│   │  └─────────────┘  └─────────────┘  └─────────────────────┘  │   │
│   │                                                              │   │
│   │  ┌──────────────────────────────────────────────────────┐   │   │
│   │  │                    COLLECTIONS                        │   │   │
│   │  │                                                       │   │   │
│   │  │  users/        - User accounts & profiles             │   │   │
│   │  │  events/       - Community events calendar           │   │   │
│   │  │  businesses/   - Local business directory           │   │   │
│   │  │  marketplace/  - Buy/sell listings                  │   │   │
│   │  │  jobs/         - Job postings                         │   │   │
│   │  │  housing/       - Housing/rental listings             │   │   │
│   │  │  deals/        - Local deals & specials               │   │   │
│   │  │  matches/       - Dating matches                      │   │   │
│   │  │  chats/         - Direct messages                      │   │   │
│   │  │  website_content/ - Synced from livingincasagrande.com │   │   │
│   │  │  leads/          - Form submissions (to Sanchez CRM)   │   │   │
│   │  │                                                       │   │   │
│   │  └──────────────────────────────────────────────────────┘   │   │
│   │                                                              │   │
│   │  ┌──────────────────────────────────────────────────────┐   │   │
│   │  │               FIREBASE FUNCTIONS                      │   │   │
│   │  │                                                       │   │   │
│   │  │  • onUserCreate()     - Welcome sequence             │   │   │
│   │  │  • onEventCreate()    - Push notification           │   │   │
│   │  │  • onMatchCreate()    - Notify users                 │   │   │
│   │  │  • syncWebsiteData()  - Cron job sync                │   │   │
│   │  │  • sendLeadToCRM()   - Route leads                  │   │   │
│   │  │  • sendPushNotif()    - Scheduled notifications     │   │   │
│   │  │                                                       │   │   │
│   │  └──────────────────────────────────────────────────────┘   │   │
│   │                                                              │   │
│   └──────────────────────────────────────────────────────────────┘   │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Data Flow Diagrams

### 1. User Authentication Flow

```
User opens app
       │
       ▼
┌──────────────────┐
│  Firebase Auth   │
│                  │
│  Options:        │
│  • Apple Sign-In │
│  • Google Sign-In│
│  • Email/Password │
└──────┬───────────┘
       │
       ▼ (Success)
┌──────────────────┐
│ Firestore User   │
│ Document Created │
│                  │
│ users/{uid}      │
│  - name          │
│  - email         │
│  - createdAt     │
│  - isPremium     │
│  - profileComplete│
└──────────────────┘
       │
       ▼
┌──────────────────┐
│ App Access       │
│                  │
│ Full access to   │
│ all features     │
└──────────────────┘
```

### 2. Events Sync Flow

```
livingincasagrande.com          Firebase                App
     │                              │                    │
     │  WordPress Plugin           │                    │
     │  creates event              │                    │
     ▼                             ▼                    │
┌─────────────┐            ┌─────────────┐           │
│ wp_posts    │ ───────►  │ events/      │ ◄──────────│
│ (WordPress) │  Sync     │ {eventId}    │  Real-time  │
└─────────────┘  (every   └─────────────┘  updates   │
                   15min)        │                    │
                                 ▼                    │
                          Push notification sent to   │
                          all users subscribed to     │
                          event category               │
```

### 3. Lead Generation Flow

```
App User                           Firebase              livingincasagrande.com
    │                                   │                        │
    │  taps "Get Info" on listing      │                        │
    ▼                                  ▼                        │
┌─────────────┐                ┌─────────────┐               │
│ Lead Form   │ ────►         │ leads/       │ ────────►     │
│ (in app)    │  Submit        │ {leadId}    │  Webhook      │
└─────────────┘                └─────────────┘  to WordPress │
                                   │                        │
                                   ▼                        ▼
                            ┌─────────────┐          ┌─────────────┐
                            │ Cloud       │          │ Contact     │
                            │ Function    │          │ Form DB     │
                            │             │          │             │
                            │ Sends to:   │          │ Assigned to │
                            │ • Email     │          │ Sanchez     │
                            │ • CRM       │          │ Group       │
                            └─────────────┘          └─────────────┘
```

### 4. Business Directory Sync Flow

```
livingincasagrande.com          Firebase                App
     │                              │                    │
     │  WordPress plugin             │                    │
     │  manages business data       │                    │
     ▼                             ▼                    │
┌─────────────┐            ┌─────────────┐           │
│ wp_business │ ───────►  │ businesses/ │ ◄──────────│
│ (Custom     │  Sync     │ {bizId}     │  Real-time  │
│ Post Type)  │            └─────────────┘  updates   │
└─────────────┘                   │                    │
                                 ▼                    │
                          Featured businesses         │
                          shown at top of app        │
                          (Grande Rentals,           │
                           Sanchez Group,             │
                           AA Cleaning prominently)   │
```

---

## Firebase Collections Schema

### Users Collection
```javascript
users/{userId}
  ├── name: string
  ├── email: string
  ├── phone: string (optional)
  ├── photoURL: string (optional)
  ├── createdAt: timestamp
  ├── lastLogin: timestamp
  ├── isPremium: boolean
  ├── premiumExpiresAt: timestamp
  ├── datingProfile: {
  │     bio: string
  │     photos: [string]
  │     interests: [string]
  │     lookingFor: "friends" | "casual" | "relationship"
  │     age: number
  │     location: geopoint
  │     isVerified: boolean
  │     isMilitaryVerified: boolean
  │     militaryUnit: string (optional)
  │     studentAt: "ASU Poly" | null
  │   }
  ├── savedEvents: [eventId]
  ├── savedBusinesses: [businessId]
  ├── listingsPosted: number
  ├── rating: number
  └── reportCount: number
```

### Events Collection
```javascript
events/{eventId}
  ├── title: string
  ├── date: timestamp
  ├── endDate: timestamp
  ├── location: {
  │     address: string
  │     latitude: number
  │     longitude: number
  │   }
  ├── category: string
  ├── description: string
  ├── imageURL: string
  ├── organizerId: string
  ├── organizerName: string
  ├── organizerLogo: string
  ├── rsvpCount: number
  ├── attendees: [userId]
  ├── isPublic: boolean
  ├── isFeatured: boolean
  ├── ticketPrice: number (0 = free)
  ├── ticketURL: string
  ├── source: "manual" | "website" | "facebook"
  ├── syncedFromWebsite: boolean
  ├── websitePostId: string (if synced)
  ├── createdAt: timestamp
  └── updatedAt: timestamp
```

### Businesses Collection
```javascript
businesses/{businessId}
  ├── name: string
  ├── category: string
  ├── subcategory: string
  ├── address: {
  │     street: string
  │     city: string
  │     state: string
  │     zip: string
  │     latitude: number
  │     longitude: number
  │   }
  ├── contact: {
  │     phone: string
  │     email: string
  │     website: string
  │   }
  ├── hours: {
  │     monday: { open: string, close: string }
  │     tuesday: { open: string, close: string }
  │     // ... etc
  │   }
  ├── description: string
  ├── images: [string]
  ├── featured: boolean
  ├── featuredUntil: timestamp
  ├── featuredTier: "gold" | "silver" | "bronze"
  ├── ownerId: string (userId of business owner)
  ├── isVerified: boolean
  ├── rating: number
  ├── reviewCount: number
  ├── priceRange: "$" | "$$" | "$$$" | "$$$$"
  ├── amenities: [string]
  ├── specialOffers: [string]
  ├── socialLinks: {
  │     facebook: string
  │     instagram: string
  │     twitter: string
  │   }
  ├── isOwnedByJesus: boolean  // Sanchez Group, AA Cleaning, Grande Rentals
  ├── ownerDisplayName: string
  ├── syncedFromWebsite: boolean
  ├── websiteListingId: string
  ├── createdAt: timestamp
  └── updatedAt: timestamp
```

### Marketplace Collection
```javascript
marketplace/{listingId}
  ├── title: string
  ├── price: number
  ├── isFree: boolean
  ├── category: string
  ├── condition: "new" | "like_new" | "good" | "fair"
  ├── description: string
  ├── images: [string]
  ├── sellerId: string
  ├── sellerName: string
  ├── location: {
  │     generalArea: string  // "Downtown", "Near ASU", etc
  │     latitude: number (approximate)
  │     longitude: number
  │   }
  ├── status: "active" | "pending" | "sold"
  ├── featured: boolean
  ├── featuredUntil: timestamp
  ├── views: number
  ├── savedCount: number
  ├── createdAt: timestamp
  └── updatedAt: timestamp
```

### Dating Matches Collection
```javascript
matches/{matchId}
  ├── user1Id: string
  ├── user2Id: string
  ├── matchedAt: timestamp
  ├── lastInteraction: timestamp
  ├── messages: [
  │     {
  │       senderId: string
  │       text: string
  │       sentAt: timestamp
  │       readAt: timestamp
  │     }
  │   ]
  └── status: "active" | "unmatched"
```

### Leads Collection (Website Sync)
```javascript
leads/{leadId}
  ├── type: "real_estate" | "cleaning" | "rentals" | "general"
  ├── name: string
  ├── email: string
  ├── phone: string
  ├── message: string
  ├── source: "app" | "website" | "facebook"
  ├── propertyInterest: string (optional)
  ├── budget: string (optional)
  ├── timeline: string (optional)
  ├── assignedTo: string (Sanchez Group agent)
  ├── status: "new" | "contacted" | "qualified" | "closed_won" | "closed_lost"
  ├── notes: [string]
  ├── createdAt: timestamp
  └── assignedAt: timestamp
```

---

## Sync Mechanisms

### 1. Firebase WordPress Plugin Sync

**Purpose:** Keep events and businesses in sync between livingincasagrande.com (WordPress) and Firebase.

**How it works:**
1. WordPress plugin detects post create/update/delete
2. Plugin calls Firebase Cloud Function endpoint
3. Function updates Firestore collection
4. App receives real-time update via Firestore listeners

**WordPress Plugin Features:**
```php
// Triggers on event/business post save
add_action('save_post', 'sync_to_firebase', 10, 3);

function sync_to_firebase($post_id, $post, $update) {
    // Convert WP post to Firebase format
    $data = convert_to_firebase_format($post);
    
    // Call Firebase Function
    wp_remote_post('https://us-central1-livingincg.cloudfunctions.net/syncFromWebsite', [
        'body' => [
            'type' => $post->post_type,
            'data' => $data,
            'action' => $update ? 'update' : 'create'
        ]
    ]);
}
```

### 2. Scheduled Sync (Cron)

**Purpose:** Ensure data consistency every 15 minutes.

**Firebase Function:**
```javascript
exports.scheduledSync = functions.pubsub
    .schedule('every 15 minutes')
    .onRun(async (context) => {
        // Sync events from WordPress
        await syncEventsFromWebsite();
        
        // Sync business listings
        await syncBusinessesFromWebsite();
        
        // Clean up expired deals
        await cleanupExpiredDeals();
        
        // Update event counts
        await updateEventCounts();
        
        console.log('Scheduled sync completed');
    });
```

### 3. Real-time Listeners (App)

**Purpose:** App receives instant updates when data changes.

**SwiftUI Implementation:**
```swift
@FirestoreListener(path: "events")
var events: [Event] = []

@FirestoreListener(path: "businesses", 
                   filters: [.where("featured", isEqualTo: true)])
var featuredBusinesses: [Business] = []
```

### 4. Push Notifications

**Purpose:** Alert users about new events, matches, messages.

**Trigger Points:**
- New event in user's saved category
- Someone RSVPs to user's event
- New match in dating
- Message from match
- Price drop on saved marketplace item
- New job matching user's interests

---

## livingincasagrande.com Integration Points

### 1. Real Estate Listings → App

**Source:** livingincasagrande.com WordPress (Real Estate theme)

**Sync to App:**
- Featured listings appear in Housing section
- "View Details" opens listing on website
- "Contact Agent" routes to lead form → Firebase → CRM

**Data Flow:**
```
WordPress Property Listing
        │
        ▼ (Plugin on save)
Firebase /housing/{listingId}
        │
        ├──► App: Housing tab (featured listings)
        │
        └──► Lead Form
                 │
                 ▼ (Submit)
            Firebase /leads/{leadId}
                 │
                 ▼ (Webhook)
            Sanchez Group CRM
```

### 2. Blog Posts → Community News

**Source:** livingincasagrande.com WordPress (Blog)

**Sync to App:**
- Latest 10 posts appear in Community News
- Click opens full post on website
- Author credited to Sanchez Group

### 3. Lead Capture

**Source:** Contact forms on livingincasagrande.com

**Flow:**
1. User fills form on website
2. Webhook sends to Firebase `/leads`
3. Firebase Function routes to Sanchez Group email
4. Lead added to CRM

---

## Security Rules

### Firestore Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Users can read/write own profile
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    
    // Anyone can read events and businesses
    match /events/{eventId} {
      allow read: if true;
      allow create, update, delete: if request.auth != null 
        && getUserData(request.auth.uid).role == 'admin';
    }
    
    // Anyone can read businesses
    match /businesses/{businessId} {
      allow read: if true;
      allow write: if request.auth != null 
        && (getUserData(request.auth.uid).role == 'admin' 
            || request.auth.uid == resource.data.ownerId);
    }
    
    // Marketplace - sellers can only edit own listings
    match /marketplace/{listingId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth.uid == resource.data.sellerId;
    }
    
    // Dating - only see matches you're part of
    match /matches/{matchId} {
      allow read, write: if request.auth.uid == resource.data.user1Id 
        || request.auth.uid == resource.data.user2Id;
    }
    
    // Leads - only admins can read
    match /leads/{leadId} {
      allow read: if request.auth != null 
        && getUserData(request.auth.uid).isAdmin == true;
      allow create: if true; // Public form submissions
    }
  }
}
```

---

## API Endpoints (Firebase Functions)

### REST API

```
POST   /api/leads          - Submit lead form
GET    /api/events         - List events (with filters)
GET    /api/businesses     - List businesses (with filters)
POST   /api/marketplace    - Create listing
GET    /api/jobs           - List jobs
POST   /api/auth/apple     - Apple Sign-In
POST   /api/auth/google    - Google Sign-In
```

### Webhooks

```
POST   /webhook/wordpress    - WordPress data sync
POST   /webhook/stripe        - Payment confirmations
POST   /webhook/twilio        - SMS notifications
```

---

## Cost Estimation

### Firebase (MVP Stage)

| Service | Free Tier | Paid Usage | Cost |
|---------|-----------|------------|------|
| Firebase Auth | 10K/month | 0 | $0 |
| Firestore | 1GB stored, 50K reads/day | Per GB/ops | ~$0-25/mo |
| Cloud Storage | 5GB | $0.026/GB | ~$1/mo |
| Cloud Functions | 2M invocations/mo | $0.40/million | ~$0 |
| Hosting | 10GB | $0.026/GB | ~$0 |
| Analytics | Unlimited | $0 | $0 |
| **Total** | | | **~$1-25/mo** |

### Firebase (Growth Stage - 10K users)

| Service | Usage | Cost |
|---------|-------|------|
| Auth | 50K/month | $0 |
| Firestore | 5GB stored, 500K reads/day | ~$25/mo |
| Cloud Storage | 20GB | ~$0.50/mo |
| Cloud Functions | 5M invocations/mo | ~$1.20/mo |
| Hosting | 20GB | ~$0.50/mo |
| **Total** | | **~$27/mo** |

---

## Implementation Priority

### Phase 1 (MVP - Week 1-2)
1. [ ] Firebase project setup
2. [ ] Auth (Apple Sign-In)
3. [ ] Events collection with sample data
4. [ ] Businesses collection with sample data
5. [ ] Connect EventsView to Firebase
6. [ ] Connect BusinessDirectoryView to Firebase

### Phase 2 (Week 3-4)
1. [ ] Marketplace collection
2. [ ] Jobs collection
3. [ ] Connect MarketplaceView
4. [ ] Connect JobsView
5. [ ] User profiles

### Phase 3 (Month 2)
1. [ ] Dating feature
2. [ ] Matching logic
3. [ ] Messaging
4. [ ] Push notifications

### Phase 4 (Month 3+)
1. [ ] WordPress plugin development
2. [ ] livingincasagrande.com sync
3. [ ] Lead routing
4. [ ] Analytics dashboard

---

## Next Steps

1. **Set up Firebase project** (can do now, free)
2. **Configure Firestore collections** (can do now)
3. **Add sample data to Firebase** (can do now)
4. **Connect app to Firebase** (after Firebase is ready)
5. **Build WordPress plugin** (month 3)

---

*Architecture compiled by Joana AI | April 8, 2026*
