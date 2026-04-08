import SwiftUI

struct Event: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    let location: String
    let category: String
}

struct ContentView: View {
    @State private var events: [Event] = [
        Event(title: "Casa Grande Farmers Market", date: "Every Saturday", location: "Downtown Plaza", category: "🛒 Community"),
        Event(title: "ASU Poly Spring Festival", date: "April 15", location: "ASU Polytechnic Campus", category: "🎓 Campus"),
        Event(title: "Air Force Base Open House", date: "April 20", location: "Barry M. Goldwater AFB", category: "✈️ Military"),
        Event(title: "Concerts in the Park", date: "April 25", location: "Murphy Park", category: "🎵 Events"),
        Event(title: "Casa Grande Art Walk", date: "First Friday Monthly", location: "Downtown", category: "🎨 Arts"),
        Event(title: "Real Estate Investment Workshop", date: "April 30", location: "Sanchez Group Office", category: "🏠 Real Estate")
    ]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(events) { event in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(event.category)
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(event.title)
                            .font(.headline)
                        HStack {
                            Image(systemName: "calendar")
                            Text(event.date)
                                .font(.subheadline)
                            Spacer()
                            Image(systemName: "mappin")
                            Text(event.location)
                                .font(.subheadline)
                        }
                        .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Events")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
