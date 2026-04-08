import SwiftUI

struct Place: Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let address: String
    let price: String
    let category: String
}

struct ContentView: View {
    @State private var places: [Place] = [
        Place(name: "Brewer's restaurant & Grill", type: "American | Sports Bar", address: "201 N Florence St", price: "$$", category: "🍽️ Dining"),
        Place(name: "Cactus Jack's", type: "Mexican Restaurant", address: "500 E Cottonwood Ln", price: "$$", category: "🌮 Mexican"),
        Place(name: "Mi Casagz", type: "Authentic Mexican", address: "1114 E Florence Blvd", price: "$", category: "🌮 Mexican"),
        Place(name: "Big Deck BBQ", type: "BBQ Restaurant", address: "300 E Cottonwood Ln", price: "$$", category: "🍖 BBQ"),
        Place(name: "The Hangar", type: "Bar & Grill", address: "201 E Florence St", price: "$$", category: "🍺 Nightlife"),
        Place(name: "Sullivan's", type: "Steakhouse", address: "1945 E Florence Blvd", price: "$$$", category: "🥩 Fine Dining"),
        Place(name: "Pita Pit", type: "Mediterranean", address: "1004 E Florence Blvd", price: "$", category: "🥙 Fast Casual"),
        Place(name: "Sonic", type: "Drive-In", address: "445 E Cottonwood Ln", price: "$", category: "🍦 Fast Food")
    ]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(places) { place in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(place.category)
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(place.name)
                            .font(.headline)
                        Text(place.type)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        HStack {
                            Image(systemName: "mappin")
                            Text(place.address)
                                .font(.caption)
                            Spacer()
                            Text(place.price)
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                        .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Dining & Nightlife")
        }
    }
}

#Preview {
    ContentView()
}
