import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            EventsView()
                .tabItem {
                    Label("Events", systemImage: "calendar")
                }
                .tag(0)
            
            BusinessDirectoryView()
                .tabItem {
                    Label("Discover", systemImage: "magnifyingglass")
                }
                .tag(1)
            
            MarketplaceView()
                .tabItem {
                    Label("Shop", systemImage: "bag")
                }
                .tag(2)
            
            DatingView()
                .tabItem {
                    Label("Dating", systemImage: "heart.fill")
                }
                .tag(3)
            
            CommunityNewsView()
                .tabItem {
                    Label("Community", systemImage: "person.3.fill")
                }
                .tag(4)
        }
        .tint(.blue)
    }
}

#Preview {
    ContentView()
}
