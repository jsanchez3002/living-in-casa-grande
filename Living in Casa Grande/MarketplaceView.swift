import SwiftUI

struct MarketplaceItem: Identifiable {
    let id = UUID()
    let title: String
    let price: Double
    let category: String
    let condition: String
    let description: String
    let sellerName: String
    let location: String
    let postedDaysAgo: Int
    let isFree: Bool
    let isFeatured: Bool
}

struct MarketplaceView: View {
    @State private var items: [MarketplaceItem] = [
        MarketplaceItem(title: "Moving Sale - Furniture Set", price: 450, category: "Furniture", condition: "Good", description: "Complete living room set. Couch, loveseat, coffee table, 2 end tables. Selling due to relocation.", sellerName: "Mike R.", location: "Florence & Congress", postedDaysAgo: 1, isFree: false, isFeatured: true),
        MarketplaceItem(title: "FREE - Moving Boxes", price: 0, category: "Free Stuff", condition: "Good", description: "About 30 moving boxes. Various sizes. Free to anyone who can pick up today!", sellerName: "Sarah M.", location: "Downtown CG", postedDaysAgo: 1, isFree: true, isFeatured: false),
        MarketplaceItem(title: "iPhone 14 Pro - Excellent", price: 699, category: "Electronics", condition: "Excellent", description: "iPhone 14 Pro 128GB. Unlocked, excellent condition, includes case and charger. No scratches.", sellerName: "David L.", location: "Sunwest", postedDaysAgo: 2, isFree: false, isFeatured: true),
        MarketplaceItem(title: "Kids Bike - 20 inch", price: 75, category: "Kids Items", condition: "Good", description: "Schwinn kids bike, 20 inch wheels. Good condition, minor wear. Has training wheels option.", sellerName: "Jennifer K.", location: "Cottonwood Ln", postedDaysAgo: 2, isFree: false, isFeatured: false),
        MarketplaceItem(title: "2018 Honda Civic - $12K", price: 12000, category: "Vehicles", condition: "Good", description: "2018 Honda Civic LX. 65,000 miles. Clean title, no accidents. AC works great.", sellerName: "Carlos G.", location: "AFB Area", postedDaysAgo: 3, isFree: false, isFeatured: false),
        MarketplaceItem(title: "Samsung 55\" TV", price: 250, category: "Electronics", condition: "Good", description: "Samsung 55 inch 4K Smart TV. Works perfectly, just upgrading to larger size.", sellerName: "Amanda T.", location: "Sunwest", postedDaysAgo: 4, isFree: false, isFeatured: false),
        MarketplaceItem(title: "FREE - Garden Soil", price: 0, category: "Free Stuff", condition: "New", description: "5 bags of garden soil, barely used. Need them gone this week.", sellerName: "Tom B.", location: "Arizona City", postedDaysAgo: 4, isFree: true, isFeatured: false),
        MarketplaceItem(title: "Dining Table Set", price: 200, category: "Furniture", condition: "Fair", description: "Dining table with 4 chairs. Some scratches on surface but very sturdy. Cash only.", sellerName: "Linda H.", location: "Cottonwood Ln", postedDaysAgo: 5, isFree: false, isFeatured: false),
        MarketplaceItem(title: "ASU Textbooks Bundle", price: 150, category: "Books", condition: "Good", description: "Biology, Chemistry, Math textbooks. Used one semester. Great for current students!", sellerName: "Chris P.", location: "ASU Poly Area", postedDaysAgo: 5, isFree: false, isFeatured: false),
        MarketplaceItem(title: "Washer/Dryer Set", price: 400, category: "Appliances", condition: "Good", description: "LG washer and dryer set. 3 years old, works great. Moving and can't take with.", sellerName: "Rachel S.", location: "Desert Oaks", postedDaysAgo: 6, isFree: false, isFeatured: false),
        MarketplaceItem(title: "Guitar - Acoustic", price: 85, category: "Musical Instruments", condition: "Good", description: "Yamaha acoustic guitar. Great for beginners. Includes case and extra strings.", sellerName: "Jake W.", location: "Downtown CG", postedDaysAgo: 7, isFree: false, isFeatured: false),
        MarketplaceItem(title: "Treadmill - Lightly Used", price: 175, category: "Sports", condition: "Like New", description: "ProForm treadmill. Less than 6 months old. Too busy to use. Must pick up.", sellerName: "Nicole M.", location: "Sunwest", postedDaysAgo: 8, isFree: false, isFeatured: false)
    ]
    
    @State private var selectedCategory = "All"
    @State private var showingNewItem = false
    
    var categories = ["All", "Furniture", "Electronics", "Vehicles", "Kids Items", "Appliances", "Books", "Sports", "Musical Instruments", "Free Stuff", "Services"]
    
    var filteredItems: [MarketplaceItem] {
        if selectedCategory == "All" {
            return items
        }
        return items.filter { $0.category == selectedCategory }
    }
    
    var body: some View {
        NavigationStack {
            List {
                // Featured Section
                let featured = filteredItems.filter { $0.isFeatured }
                if !featured.isEmpty && selectedCategory == "All" {
                    Section {
                        ForEach(featured) { item in
                            MarketplaceRowView(item: item, isFeatured: true)
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
                
                // Category Filter
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
                
                // All Items
                Section {
                    ForEach(filteredItems.filter { !$0.isFeatured || selectedCategory != "All" }) { item in
                        MarketplaceRowView(item: item, isFeatured: false)
                    }
                } header: {
                    Text(selectedCategory == "All" ? "All Items (\(filteredItems.count))" : "\(selectedCategory) (\(filteredItems.count))")
                }
            }
            .navigationTitle("Marketplace")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingNewItem = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewItem) {
                NewMarketplaceItemView()
            }
        }
    }
}

struct MarketplaceRowView: View {
    let item: MarketplaceItem
    let isFeatured: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(item.category)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(categoryColor(for: item.category))
                    .cornerRadius(4)
                
                Text(item.condition)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if item.isFeatured {
                    Text("FEATURED")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.orange)
                        .cornerRadius(4)
                }
                
                Text("\(item.postedDaysAgo)d ago")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(item.title)
                .font(.headline)
            
            HStack {
                if item.isFree {
                    Text("FREE")
                        .font(.headline)
                        .foregroundColor(.green)
                } else {
                    Text("$\(Int(item.price))")
                        .font(.headline)
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "mappin")
                    Text(item.location)
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            Text(item.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack {
                Image(systemName: "person.circle")
                    .font(.caption)
                Text(item.sellerName)
                    .font(.caption)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "envelope")
                        Text("Message")
                    }
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 8)
    }
    
    func categoryColor(for category: String) -> Color {
        switch category {
        case "Furniture": return .brown
        case "Electronics": return .purple
        case "Vehicles": return .blue
        case "Kids Items": return .pink
        case "Appliances": return .gray
        case "Books": return .orange
        case "Sports": return .green
        case "Musical Instruments": return .indigo
        case "Free Stuff": return .mint
        case "Services": return .cyan
        default: return .gray
        }
    }
}

struct NewMarketplaceItemView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var selectedCategory = "Furniture"
    @State private var selectedCondition = "Good"
    @State private var price = ""
    @State private var isFree = false
    @State private var description = ""
    @State private var location = ""
    
    let categories = ["Furniture", "Electronics", "Vehicles", "Kids Items", "Appliances", "Books", "Sports", "Musical Instruments", "Free Stuff", "Services"]
    let conditions = ["New", "Like New", "Excellent", "Good", "Fair"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Item Details") {
                    TextField("Title", text: $title)
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { cat in
                            Text(cat).tag(cat)
                        }
                    }
                    Picker("Condition", selection: $selectedCondition) {
                        ForEach(conditions, id: \.self) { cond in
                            Text(cond).tag(cond)
                        }
                    }
                    Toggle("This item is FREE", isOn: $isFree)
                    if !isFree {
                        TextField("Price ($)", text: $price)
                            .keyboardType(.numberPad)
                    }
                }
                
                Section("Description") {
                    TextEditor(text: $description)
                        .frame(minHeight: 80)
                }
                
                Section("Location") {
                    TextField("Pickup Location (general area)", text: $location)
                }
                
                Section {
                    Text("Photos can be added after posting")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Sell an Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Post") {
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

#Preview {
    MarketplaceView()
}
