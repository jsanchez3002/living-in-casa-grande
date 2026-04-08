import SwiftUI

struct Business: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let address: String
    let phone: String
    let website: String
    let description: String
    let rating: Double
    let reviewCount: Int
    let featured: Bool
}

struct BusinessDirectoryView: View {
    @State private var businesses: [Business] = [
        Business(name: "Sanchez Group | REAL Brokerage", category: "🏠 Real Estate", address: "Casa Grande, AZ", phone: "(480) 531-0428", website: "realsanchez.com", description: "Your trusted AZ real estate experts. Buying, selling, investing.", rating: 5.0, reviewCount: 127, featured: true),
        Business(name: "AA Cleaning AZ", category: "🧹 Cleaning Services", address: "Casa Grande, AZ", phone: "(480) 531-5584", website: "aacleaningaz.com", description: "Professional home and commercial cleaning services.", rating: 4.9, reviewCount: 89, featured: true),
        Business(name: "Grande Rentals", category: "🏠 Property Management", address: "Casa Grande, AZ", phone: "(480) 531-0428", website: "granderentals.com", description: "Quality rental properties in Casa Grande and surrounding areas.", rating: 4.8, reviewCount: 56, featured: true),
        Business(name: "Brewer's Restaurant & Grill", category: "🍽️ Dining", address: "201 N Florence St", phone: "(520) 836-1050", website: "brewerscg.com", description: "American sports bar with great food and drinks.", rating: 4.5, reviewCount: 312, featured: false),
        Business(name: "Cactus Jack's Mexican Grill", category: "🌮 Mexican", address: "500 E Cottonwood Ln", phone: "(520) 836-8900", website: "", description: "Authentic Mexican food and margaritas.", rating: 4.4, reviewCount: 256, featured: false),
        Business(name: "Big Deck BBQ", category: "🍖 BBQ", address: "300 E Cottonwood Ln", phone: "(520) 836-2337", website: "", description: "Slow-smoked Texas-style BBQ in Arizona.", rating: 4.6, reviewCount: 189, featured: false),
        Business(name: "Mi Casita Restaurant", category: "🌮 Mexican", address: "1114 E Florence Blvd", phone: "(520) 836-1234", website: "", description: "Family-owned authentic Mexican cuisine.", rating: 4.7, reviewCount: 201, featured: false),
        Business(name: "The Hangar Bar & Grill", category: "🍺 Nightlife", address: "201 E Florence St", phone: "(520) 836-9500", website: "", description: "Local favorite bar with live music on weekends.", rating: 4.3, reviewCount: 145, featured: false),
        Business(name: "Sullivan's Steakhouse", category: "🥩 Fine Dining", address: "1945 E Florence Blvd", phone: "(520) 836-5000", website: "", description: "Premium steaks and seafood.", rating: 4.8, reviewCount: 178, featured: false),
        Business(name: "Pita Pit", category: "🥙 Fast Casual", address: "1004 E Florence Blvd", phone: "(520) 836-7482", website: "pitapitusa.com", description: "Fresh Mediterranean wraps and bowls.", rating: 4.2, reviewCount: 98, featured: false),
        Business(name: "Mariscos Culiacan", category: "🐟 Seafood", address: "300 E Cottonwood Ln", phone: "(520) 836-8721", website: "", description: "Authentic Mexican seafood.", rating: 4.5, reviewCount: 167, featured: false),
        Business(name: "Sonic Drive-In", category: "🍦 Fast Food", address: "445 E Cottonwood Ln", phone: "(520) 836-1000", website: "", description: "Classic drive-in with carhop service.", rating: 4.0, reviewCount: 223, featured: false)
    ]
    
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    
    var categories = ["All", "🏠 Real Estate", "🧹 Cleaning Services", "🍽️ Dining", "🌮 Mexican", "🍖 BBQ", "🍺 Nightlife", "🥩 Fine Dining", "🥙 Fast Casual", "🐟 Seafood", "🍦 Fast Food"]
    
    var filteredBusinesses: [Business] {
        businesses.filter { business in
            (selectedCategory == "All" || business.category == selectedCategory) &&
            (searchText.isEmpty || business.name.localizedCaseInsensitiveContains(searchText))
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                // Featured Section
                let featured = filteredBusinesses.filter { $0.featured }
                if !featured.isEmpty && selectedCategory == "All" {
                    Section {
                        ForEach(featured) { business in
                            BusinessRowView(business: business, isFeatured: true)
                        }
                    } header: {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("Featured")
                                .font(.headline)
                        }
                    }
                }
                
                // All Businesses
                Section {
                    ForEach(filteredBusinesses.filter { !$0.featured || selectedCategory != "All" }) { business in
                        BusinessRowView(business: business, isFeatured: false)
                    }
                } header: {
                    Text(selectedCategory == "All" ? "All Businesses" : selectedCategory)
                }
            }
            .searchable(text: $searchText, prompt: "Search businesses")
            .navigationTitle("Business Directory")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        ForEach(categories, id: \.self) { category in
                            Button(action: { selectedCategory = category }) {
                                HStack {
                                    Text(category)
                                    if selectedCategory == category {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
        }
    }
}

struct BusinessRowView: View {
    let business: Business
    let isFeatured: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(business.category)
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                if business.featured {
                    Text("FEATURED")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.orange)
                        .cornerRadius(4)
                }
            }
            
            Text(business.name)
                .font(.headline)
            
            Text(business.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack {
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text(String(format: "%.1f", business.rating))
                        .font(.caption)
                        .fontWeight(.semibold)
                    Text("(\(business.reviewCount))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "mappin")
                        .font(.caption)
                    Text(business.address)
                        .font(.caption)
                }
                .foregroundColor(.secondary)
            }
            
            HStack(spacing: 16) {
                if !business.phone.isEmpty {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "phone.fill")
                            Text("Call")
                        }
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.green)
                        .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }
                
                if !business.website.isEmpty && business.website != "realsanchez.com" && business.website != "aacleaningaz.com" {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "globe")
                            Text("Website")
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    BusinessDirectoryView()
}
