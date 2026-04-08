import SwiftUI

struct HousingListing: Identifiable {
    let id = UUID()
    let title: String
    let address: String
    let price: Double
    let priceType: String
    let bedrooms: Int
    let bathrooms: Double
    let sqft: Int
    let description: String
    let imageUrls: [String]
    let listedDaysAgo: Int
    let featured: Bool
    let type: String
}

struct HousingView: View {
    @State private var listings: [HousingListing] = [
        HousingListing(title: "Beautiful 4BR Home in subdivision", address: "1234 E Oak Lane, Casa Grande", price: 389000, priceType: "For Sale", bedrooms: 4, bathrooms: 2.5, sqft: 2200, description: "Stunning 4-bedroom home with open floor plan, updated kitchen, large backyard. Great schools nearby.", imageUrls: [], listedDaysAgo: 2, featured: true, type: "sale"),
        HousingListing(title: "Cozy 2BR Apartment Near ASU Poly", address: "789 W Century Blvd #12", price: 1200, priceType: "/month", bedrooms: 2, bathrooms: 1, sqft: 900, description: "Clean 2BR apartment minutes from ASU Poly. W/D in unit, pool access. Perfect for students or young professionals.", imageUrls: [], listedDaysAgo: 3, featured: true, type: "rent"),
        HousingListing(title: "3BR House with Mountain Views", address: "456 S Palo Verde, Arizona City", price: 1650, priceType: "/month", bedrooms: 3, bathrooms: 2, sqft: 1400, description: "Spacious 3BR home with stunning mountain views. Large yard, 2-car garage. No HOA!", imageUrls: [], listedDaysAgo: 5, featured: false, type: "rent"),
        HousingListing(title: "New Construction 5BR Estate", address: "1000 E Ranchero Dr, Casa Grande", price: 525000, priceType: "For Sale", bedrooms: 5, bathrooms: 3, sqft: 3200, description: "Brand new 5-bedroom estate on 1 acre lot. Custom cabinets, granite throughout, 3-car garage.", imageUrls: [], listedDaysAgo: 7, featured: false, type: "sale"),
        HousingListing(title: "Room for Rent - Female Preferred", address: "Downtown Casa Grande", price: 600, priceType: "/month", bedrooms: 1, bathrooms: 1, sqft: 150, description: "Shared room in 3BR house. Female preferred. Utilities included. Walking distance to downtown.", imageUrls: [], listedDaysAgo: 1, featured: false, type: "roommate"),
        HousingListing(title: "RV Lot with Full Hookups", address: "500 E RV Resort Blvd", price: 800, priceType: "/month", bedrooms: 0, bathrooms: 0, sqft: 0, description: "Premium RV lot with full hookups, wifi, laundry facilities. Monthly resort community.", imageUrls: [], listedDaysAgo: 10, featured: false, type: "rent"),
        HousingListing(title: "Affordable 3BR Starter Home", address: "234 N Desert Willow Dr", price: 245000, priceType: "For Sale", bedrooms: 3, bathrooms: 2, sqft: 1350, description: "Perfect starter home! Updated bathroom, new roof 2024, large corner lot. FHA financing available.", imageUrls: [], listedDaysAgo: 14, featured: false, type: "sale"),
        HousingListing(title: "Luxury 4BR Rental Near AFB", address: "789 Military Parkway", price: 2200, priceType: "/month", bedrooms: 4, bathrooms: 2.5, sqft: 2400, description: "Military-friendly rental near Barry M. Goldwater AFB. Pet friendly with large yard. Close to base.", imageUrls: [], listedDaysAgo: 4, featured: false, type: "rent")
    ]
    
    @State private var selectedType = "All"
    @State private var showingNewListing = false
    
    var listingTypes = ["All", "For Sale", "For Rent", "Room for Rent"]
    
    var filteredListings: [HousingListing] {
        if selectedType == "All" {
            return listings
        }
        return listings.filter { $0.priceType.contains(selectedType) }
    }
    
    var body: some View {
        NavigationStack {
            List {
                // Grande Rentals Featured
                let grandeRentalsFeatured = filteredListings.filter { $0.featured }
                if !grandeRentalsFeatured.isEmpty && selectedType == "All" {
                    Section {
                        ForEach(grandeRentalsFeatured) { listing in
                            HousingRowView(listing: listing, isFeatured: true)
                        }
                    } header: {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("Grande Rentals Featured")
                                .font(.headline)
                        }
                    }
                }
                
                // Type Filter
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(listingTypes, id: \.self) { type in
                                Button(action: { selectedType = type }) {
                                    Text(type)
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(selectedType == type ? Color.blue : Color.gray.opacity(0.2))
                                        .foregroundColor(selectedType == type ? .white : .primary)
                                        .cornerRadius(16)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                
                // All Listings
                Section {
                    ForEach(filteredListings.filter { !$0.featured || selectedType != "All" }) { listing in
                        HousingRowView(listing: listing, isFeatured: false)
                    }
                } header: {
                    Text(selectedType == "All" ? "All Listings (\(filteredListings.count))" : "\(selectedType) (\(filteredListings.count))")
                }
            }
            .navigationTitle("Housing & Rentals")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingNewListing = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewListing) {
                NewHousingView()
            }
        }
    }
}

struct HousingRowView: View {
    let listing: HousingListing
    let isFeatured: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(listing.priceType)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(listing.type == "sale" ? Color.green : Color.blue)
                    .cornerRadius(4)
                
                if listing.type == "roommate" {
                    Text("Room")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.purple)
                        .cornerRadius(4)
                }
                
                Spacer()
                
                if listing.featured {
                    Text("FEATURED")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.orange)
                        .cornerRadius(4)
                }
                
                Text("\(listing.listedDaysAgo)d ago")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(listing.title)
                .font(.headline)
            
            HStack {
                Image(systemName: "mappin")
                Text(listing.address)
                    .font(.caption)
            }
            .foregroundColor(.secondary)
            
            if listing.bedrooms > 0 {
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "bed.double")
                        Text("\(listing.bedrooms) BR")
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "shower")
                        Text("\(Int(listing.bathrooms)) BA")
                    }
                    if listing.sqft > 0 {
                        HStack(spacing: 4) {
                            Image(systemName: "square")
                            Text("\(listing.sqft) sqft")
                        }
                    }
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            Text(listing.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack(spacing: 12) {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "phone.fill")
                        Text("Call")
                    }
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.green)
                    .cornerRadius(8)
                }
                .buttonStyle(.plain)
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "envelope")
                        Text("Email")
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 8)
    }
}

struct NewHousingView: View {
    @Environment(\.dismiss) var dismiss
    @State private var listingType = "For Rent"
    @State private var title = ""
    @State private var address = ""
    @State private var price = ""
    @State private var bedrooms = ""
    @State private var bathrooms = ""
    @State private var sqft = ""
    @State private var description = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Listing Type") {
                    Picker("Type", selection: $listingType) {
                        Text("For Sale").tag("For Sale")
                        Text("For Rent").tag("For Rent")
                        Text("Room for Rent").tag("Room for Rent")
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Property Details") {
                    TextField("Title", text: $title)
                    TextField("Address", text: $address)
                    TextField("Price", text: $price)
                    TextField("Bedrooms", text: $bedrooms)
                    TextField("Bathrooms", text: $bathrooms)
                    TextField("Sqft", text: $sqft)
                }
                
                Section("Description") {
                    TextEditor(text: $description)
                        .frame(minHeight: 100)
                }
                
                Section {
                    Text("Photos can be added after posting")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("New Listing")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Post") {
                        dismiss()
                    }
                    .disabled(title.isEmpty || address.isEmpty)
                }
            }
        }
    }
}

#Preview {
    HousingView()
}
