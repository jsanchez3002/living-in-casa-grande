import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1: Events
            EventsView()
                .tabItem {
                    Label("Events", systemImage: "calendar")
                }
                .tag(0)
            
            // Tab 2: Discover (Business + Dining)
            DiscoverView()
                .tabItem {
                    Label("Discover", systemImage: "magnifyingglass")
                }
                .tag(1)
            
            // Tab 3: Marketplace
            MarketplaceView()
                .tabItem {
                    Label("Shop", systemImage: "bag")
                }
                .tag(2)
            
            // Tab 4: Jobs
            JobsBoardView()
                .tabItem {
                    Label("Jobs", systemImage: "briefcase")
                }
                .tag(3)
            
            // Tab 5: Housing
            HousingView()
                .tabItem {
                    Label("Housing", systemImage: "house")
                }
                .tag(4)
            
            // Tab 6: Dating
            DatingView()
                .tabItem {
                    Label("Dating", systemImage: "heart.fill")
                }
                .tag(5)
            
            // Tab 7: Community
            CommunityNewsView()
                .tabItem {
                    Label("Community", systemImage: "person.3.fill")
                }
                .tag(6)
        }
        .tint(.blue)
    }
}

// MARK: - Discover View (Combines Business Directory + Dining)
struct DiscoverView: View {
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    
    let categories = ["All", "🏠 Real Estate", "🧹 Cleaning", "🍽️ Dining", "🌮 Mexican", "🍔 American", "🍺 Bars & Nightlife", "☕ Coffee", "🏋️ Fitness", "🛒 Shopping"]
    
    var body: some View {
        NavigationStack {
            List {
                // Categories
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(categories, id: \.self) { category in
                                Button(action: { selectedCategory = category }) {
                                    Text(category)
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(selectedCategory == category ? Color.blue : Color.gray.opacity(0.2))
                                        .foregroundColor(selectedCategory == category ? .white : .primary)
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
                
                // Featured Section
                Section {
                    NavigationLink(destination: BusinessDirectoryView()) {
                        FeaturedBusinessRow(
                            name: "Sanchez Group | REAL Brokerage",
                            category: "🏠 Real Estate",
                            description: "Your trusted AZ real estate experts",
                            color: .blue
                        )
                    }
                    NavigationLink(destination: BusinessDirectoryView()) {
                        FeaturedBusinessRow(
                            name: "AA Cleaning AZ",
                            category: "🧹 Cleaning Services",
                            description: "Professional home & commercial cleaning",
                            color: .green
                        )
                    }
                    NavigationLink(destination: BusinessDirectoryView()) {
                        FeaturedBusinessRow(
                            name: "Grande Rentals",
                            category: "🏠 Property Management",
                            description: "Quality rentals in Casa Grande",
                            color: .orange
                        )
                    }
                } header: {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("Featured")
                            .font(.headline)
                    }
                }
                
                // Local Businesses
                Section {
                    NavigationLink(destination: BusinessDirectoryView()) {
                        LocalBusinessRow(name: "Brewer's Restaurant", type: "American | Sports Bar", address: "201 N Florence St", price: "$$")
                    }
                    NavigationLink(destination: BusinessDirectoryView()) {
                        LocalBusinessRow(name: "Cactus Jack's", type: "Mexican Restaurant", address: "500 E Cottonwood Ln", price: "$$")
                    }
                    NavigationLink(destination: BusinessDirectoryView()) {
                        LocalBusinessRow(name: "Big Deck BBQ", type: "BBQ Restaurant", address: "300 E Cottonwood Ln", price: "$$")
                    }
                    NavigationLink(destination: BusinessDirectoryView()) {
                        LocalBusinessRow(name: "The Hangar", type: "Bar & Grill", address: "201 E Florence St", price: "$$")
                    }
                    NavigationLink(destination: BusinessDirectoryView()) {
                        LocalBusinessRow(name: "Mi Casita", type: "Authentic Mexican", address: "1114 E Florence Blvd", price: "$")
                    }
                } header: {
                    Text("Local Businesses")
                }
            }
            .searchable(text: $searchText, prompt: "Search businesses")
            .navigationTitle("Discover")
        }
    }
}

struct FeaturedBusinessRow: View {
    let name: String
    let category: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(color.gradient)
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: "star.fill")
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(category)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("FEATURED")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(Color.orange)
                        .cornerRadius(4)
                }
                Text(name)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct LocalBusinessRow: View {
    let name: String
    let type: String
    let address: String
    let price: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(name)
                .font(.headline)
            Text(type)
                .font(.caption)
                .foregroundColor(.secondary)
            HStack {
                Image(systemName: "mappin")
                    .font(.caption2)
                Text(address)
                    .font(.caption)
                Spacer()
                Text(price)
                    .font(.caption)
                    .foregroundColor(.green)
            }
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ContentView()
}
