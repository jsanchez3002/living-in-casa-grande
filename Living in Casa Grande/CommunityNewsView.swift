import SwiftUI

struct NewsItem: Identifiable {
    let id = UUID()
    let title: String
    let summary: String
    let category: String
    let author: String
    let timeAgo: String
    let commentCount: Int
    let imageUrl: String?
    let isPinned: Bool
}

struct CommunityNewsView: View {
    @State private var newsItems: [NewsItem] = [
        NewsItem(title: "🔥 House Fire on Florence Blvd — All Safe", summary: "FD responded to a house fire on Florence Blvd early this morning. All residents escaped safely. Road closures in effect.", category: "🚨 Safety Alert", author: "CG Fire Dept", timeAgo: "2h", commentCount: 24, imageUrl: nil, isPinned: true),
        NewsItem(title: "🌵 Casa Grande Farmers Market Starts Saturday!", summary: "The beloved downtown farmers market kicks off its spring season this Saturday at Downtown Plaza. Fresh produce, artisan goods, and live music!", category: "📣 Announcement", author: "City of CG", timeAgo: "4h", commentCount: 18, imageUrl: nil, isPinned: true),
        NewsItem(title: "🏠 New Listing: 4BR/2BA in subdivision", summary: "Just listed! Beautiful 4-bedroom home in desirable neighborhood. asking $389K. DM for details.", category: "🏠 Real Estate", author: "Sanchez Group", timeAgo: "6h", commentCount: 12, imageUrl: nil, isPinned: false),
        NewsItem(title: "💼 Now Hiring: Server at Brewer's", summary: "Brewer's Restaurant is looking for an experienced server. Flexible hours, great tips. Apply in person.", category: "💼 Jobs", author: "Brewer's CG", timeAgo: "8h", commentCount: 3, imageUrl: nil, isPinned: false),
        NewsItem(title: "🔎 Lost: Black Lab named Max", summary: "Lost dog in the Florence & Marshall area. Answers to Max. Very friendly but anxious. Please call if found!", category: "🔎 Lost & Found", author: "Maria G.", timeAgo: "12h", commentCount: 8, imageUrl: nil, isPinned: false),
        NewsItem(title: "🎓 ASU Poly Spring Festival Next Week", summary: "ASU Polytechnic campus invites the community to their annual Spring Festival. Free admission, food trucks, live bands, and family activities.", category: "🎓 Campus", author: "ASU Poly", timeAgo: "1d", commentCount: 31, imageUrl: nil, isPinned: false),
        NewsItem(title: "✈️ AFB Open House Announced", summary: "Barry M. Goldwater Air Force Base announces community open house for April 20th. Military equipment displays, air shows, and recruitment info.", category: "✈️ Military", author: "AFB Info", timeAgo: "1d", commentCount: 45, imageUrl: nil, isPinned: false),
        NewsItem(title: "⚡ Power Outage Resolved", summary: "APS reports power has been restored to the downtown area following this morning's outage. Thank you for your patience!", category: "⚡ Utility", author: "APS Updates", timeAgo: "2d", commentCount: 6, imageUrl: nil, isPinned: false),
        NewsItem(title: "🏆 Local Business Spotlight: Mi Casita", summary: "This week's spotlight on Mi Casita Restaurant — voted Best Mexican in Casa Grande for 2025! Family recipes since 1985.", category: "🏪 Business Spotlight", author: "Living in CG", timeAgo: "3d", commentCount: 22, imageUrl: nil, isPinned: false),
        NewsItem(title: "❓ Poll: What Should the City Prioritize?", summary: "Casa Grande residents: what should the city council focus on this year? Roads, parks, businesses, or public safety?", category: "🗳️ Community Poll", author: "Living in CG", timeAgo: "4d", commentCount: 67, imageUrl: nil, isPinned: false)
    ]
    
    @State private var selectedCategory = "All"
    @State private var showingNewPost = false
    
    var categories = ["All", "🚨 Safety Alert", "📣 Announcement", "🏠 Real Estate", "💼 Jobs", "🔎 Lost & Found", "🎓 Campus", "✈️ Military", "⚡ Utility", "🏪 Business Spotlight", "🗳️ Community Poll"]
    
    var filteredNews: [NewsItem] {
        if selectedCategory == "All" {
            return newsItems
        }
        return newsItems.filter { $0.category == selectedCategory }
    }
    
    var pinnedNews: [NewsItem] {
        newsItems.filter { $0.isPinned }
    }
    
    var body: some View {
        NavigationStack {
            List {
                // Pinned Section
                if selectedCategory == "All" && !pinnedNews.isEmpty {
                    Section {
                        ForEach(pinnedNews) { item in
                            NewsRowView(newsItem: item)
                        }
                    } header: {
                        HStack {
                            Image(systemName: "pin.fill")
                                .foregroundColor(.red)
                            Text("Pinned")
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
                
                // News Feed
                Section {
                    ForEach(filteredNews.filter { !$0.isPinned || selectedCategory != "All" }) { item in
                        NewsRowView(newsItem: item)
                    }
                } header: {
                    Text(selectedCategory == "All" ? "Recent Posts" : selectedCategory)
                }
            }
            .navigationTitle("Community")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingNewPost = true }) {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            .sheet(isPresented: $showingNewPost) {
                NewPostView()
            }
        }
    }
}

struct NewsRowView: View {
    let newsItem: NewsItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(newsItem.category)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(categoryColor(for: newsItem.category))
                    .cornerRadius(4)
                
                Spacer()
                
                Text(newsItem.timeAgo)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(newsItem.title)
                .font(.headline)
            
            Text(newsItem.summary)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(3)
            
            HStack {
                Image(systemName: "person.circle")
                    .font(.caption)
                Text(newsItem.author)
                    .font(.caption)
                    .foregroundColor(.blue)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "bubble.left")
                        .font(.caption)
                    Text("\(newsItem.commentCount)")
                        .font(.caption)
                }
                .foregroundColor(.secondary)
                
                Button(action: {}) {
                    Image(systemName: "bookmark")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
                
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
    
    func categoryColor(for category: String) -> Color {
        switch category {
        case "🚨 Safety Alert": return .red
        case "📣 Announcement": return .blue
        case "🏠 Real Estate": return .green
        case "💼 Jobs": return .purple
        case "🔎 Lost & Found": return .orange
        case "🎓 Campus": return .cyan
        case "✈️ Military": return .indigo
        case "⚡ Utility": return .yellow
        case "🏪 Business Spotlight": return .pink
        case "🗳️ Community Poll": return .mint
        default: return .gray
        }
    }
}

struct NewPostView: View {
    @Environment(\.dismiss) var dismiss
    @State private var postTitle = ""
    @State private var postContent = ""
    @State private var selectedCategory = "📣 Announcement"
    
    let categories = ["📣 Announcement", "🏠 Real Estate", "💼 Jobs", "🔎 Lost & Found", "🏪 Business Spotlight", "🗳️ Community Poll"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Category") {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { cat in
                            Text(cat).tag(cat)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section("Title") {
                    TextField("What's happening?", text: $postTitle)
                }
                
                Section("Details") {
                    TextEditor(text: $postContent)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Post") {
                        // Post functionality
                        dismiss()
                    }
                    .disabled(postTitle.isEmpty)
                }
            }
        }
    }
}

#Preview {
    CommunityNewsView()
}
