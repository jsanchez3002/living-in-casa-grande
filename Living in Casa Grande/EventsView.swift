import SwiftUI

struct Event: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    let dateDetail: String
    let location: String
    let category: String
    let time: String
    let description: String
    let organizer: String
    let attendeeCount: Int
    let imageColor: Color
}

struct EventsView: View {
    @State private var events: [Event] = [
        // Community Events
        Event(title: "Casa Grande Farmers Market", date: "Every Saturday", dateDetail: "April 12, 2025", location: "Downtown Plaza, Casa Grande", category: "🛒 Community", time: "8:00 AM - 1:00 PM", description: "Fresh local produce, artisan goods, live music, and food trucks. Support local farmers and small businesses!", organizer: "Casa Grande Chamber", attendeeCount: 250, imageColor: .green),
        Event(title: "Concerts in the Park", date: "Fridays in April", dateDetail: "April 11, 2025", location: "Murphy Park Amphitheater", category: "🎵 Events", time: "6:30 PM - 9:00 PM", description: "Free outdoor concerts featuring local bands. Bring blankets and lawn chairs. Food vendors on site.", organizer: "City of Casa Grande", attendeeCount: 400, imageColor: .purple),
        Event(title: "Casa Grande Art Walk", date: "First Friday Monthly", dateDetail: "May 2, 2025", location: "Downtown Arts District", category: "🎨 Arts", time: "5:00 PM - 9:00 PM", description: "Gallery openings, artist demonstrations, and studio tours. Free admission to all participating venues.", organizer: "CG Arts Council", attendeeCount: 180, imageColor: .pink),
        Event(title: "Community Pancake Breakfast", date: "April 20", dateDetail: "April 20, 2025", location: "Elks Lodge #2440", category: "🛒 Community", time: "8:00 AM - 11:00 AM", description: "All-you-can-eat pancakes, eggs, and sausage. Raffle prizes and 50/50 drawing. Benefits local youth programs.", organizer: "Elks Lodge #2440", attendeeCount: 150, imageColor: .orange),
        Event(title: "Easter Egg Hunt", date: "April 19", dateDetail: "April 19, 2025", location: "Stewart Field", category: "👨‍👩‍👧 Family", time: "9:00 AM - 12:00 PM", description: "Egg hunts by age group, face painting, bounce houses, and photos with the Easter Bunny!", organizer: "Casa Grande Rec Center", attendeeCount: 500, imageColor: .yellow),
        
        // Military Events
        Event(title: "AFB Open House & Air Show", date: "April 26", dateDetail: "April 26, 2025", location: "Barry M. Goldwater AFB", category: "✈️ Military", time: "9:00 AM - 4:00 PM", description: "Experience thrilling aerial demonstrations, static aircraft displays, food vendors, and family activities. FREE admission!", organizer: "Goldwater AFB", attendeeCount: 5000, imageColor: .blue),
        Event(title: "Military Spouse Coffee Social", date: "Every Wednesday", dateDetail: "April 16, 2025", location: "Airman & Family Readiness Center", category: "✈️ Military", time: "9:00 AM - 11:00 AM", description: "Meet other military spouses, make friends, and learn about local resources. Coffee and snacks provided.", organizer: "AFRC", attendeeCount: 35, imageColor: .indigo),
        Event(title: "Welcome to Base Tour", date: "April 15", dateDetail: "April 15, 2025", location: "Main Gate, Goldwater AFB", category: "✈️ Military", time: "10:00 AM - 12:00 PM", description: "New to the base? Join us for a guided tour of the installation and learn about all the amenities.", organizer: "AFRC", attendeeCount: 25, imageColor: .cyan),
        
        // ASU Poly Events
        Event(title: "ASU Poly Spring Festival", date: "April 18", dateDetail: "April 18, 2025", location: "ASU Polytechnic Campus", category: "🎓 Campus", time: "10:00 AM - 4:00 PM", description: "Carnival rides, live bands, food trucks, and student organization booths. Open to the community!", organizer: "ASU Student Government", attendeeCount: 2000, imageColor: .maroon),
        Event(title: "PolyTechnic Campus Farmers Market", date: "Thursdays", dateDetail: "April 17, 2025", location: "ASU Poly Campus Center", category: "🎓 Campus", time: "10:00 AM - 2:00 PM", description: "Fresh produce, local honey, baked goods, and handmade crafts from local vendors.", organizer: "ASU Poly", attendeeCount: 200, imageColor: .gold),
        Event(title: "Guest Lecture: Future of Renewable Energy", date: "April 22", dateDetail: "April 22, 2025", location: "ASU Poly Innovation Center", category: "🎓 Campus", time: "3:00 PM - 5:00 PM", description: "Dr. Sarah Martinez discusses emerging trends in solar and wind energy. Q&A session to follow.", organizer: "ASU Engineering", attendeeCount: 75, imageColor: .green),
        Event(title: "ASU Poly Baseball vs. NAU", date: "April 19", dateDetail: "April 19, 2025", location: "Sonnenblick Field", category: "🎓 Campus", time: "6:00 PM - 9:00 PM", description: "Cheer on the Sun Devils as they take on Northern Arizona University. FREE admission!", organizer: "ASU Athletics", attendeeCount: 350, imageColor: .orange),
        Event(title: "Student Art Exhibition Opening", date: "April 24", dateDetail: "April 24, 2025", location: "Polytechnic Art Gallery", category: "🎨 Arts", time: "5:00 PM - 7:00 PM", description: "Featuring works by ASU Poly art students. Light refreshments served.", organizer: "ASU Art Dept", attendeeCount: 80, imageColor: .purple),
        
        // Real Estate & Business Events
        Event(title: "First-Time Homebuyer Workshop", date: "April 16", dateDetail: "April 16, 2025", location: "Sanchez Group Office", category: "🏠 Real Estate", time: "6:00 PM - 8:00 PM", description: "Learn everything you need to know about buying your first home. FREE event with refreshments. RSVP required.", organizer: "Sanchez Group | REAL", attendeeCount: 25, imageColor: .blue),
        Event(title: "Investment Property Seminar", date: "April 23", dateDetail: "April 23, 2025", location: "Sanchez Group Office", category: "🏠 Real Estate", time: "6:00 PM - 8:00 PM", description: "Discover how to build wealth through real estate investing in the Casa Grande market.", organizer: "Sanchez Group | REAL", attendeeCount: 20, imageColor: .green),
        Event(title: "Chamber Business After Hours", date: "April 17", dateDetail: "April 17, 2025", location: "Brewer's Restaurant", category: "💼 Business", time: "5:30 PM - 7:30 PM", description: "Networking event for local business professionals. Meet new contacts and grow your business!", organizer: "CG Chamber of Commerce", attendeeCount: 60, imageColor: .red),
        Event(title: "Small Business Saturday Market", date: "April 26", dateDetail: "April 26, 2025", location: "Downtown Casa Grande", category: "💼 Business", time: "9:00 AM - 3:00 PM", description: "Shop small at 30+ local vendors! Crafts, food, and specialty items. Support local entrepreneurs.", organizer: "CG Main Street", attendeeCount: 400, imageColor: .orange),
        
        // Food & Dining Events
        Event(title: "Taco Festival", date: "April 13", dateDetail: "April 13, 2025", location: "Florence & 4th Street", category: "🍔 Food & Drink", time: "11:00 AM - 8:00 PM", description: "Taste tacos from 15+ local restaurants. Live mariachi music, Margarita bar, and kids activities.", organizer: "CG Restaurant Association", attendeeCount: 1500, imageColor: .yellow),
        Event(title: "Wine & Jazz Night", date: "April 18", dateDetail: "April 18, 2025", location: "Sullivan's Steakhouse", category: "🍔 Food & Drink", time: "6:00 PM - 9:00 PM", description: "Enjoy premium wines paired with jazz by local musicians. Special menu available.", organizer: "Sullivan's Steakhouse", attendeeCount: 80, imageColor: .red),
        Event(title: "Trivia Night at The Hangar", date: "Every Tuesday", dateDetail: "April 15, 2025", location: "The Hangar Bar & Grill", category: "🍔 Food & Drink", time: "7:00 PM - 9:00 PM", description: "Test your knowledge! Teams of up to 6 people. Winner gets a gift card to The Hangar!", organizer: "The Hangar", attendeeCount: 50, imageColor: .blue),
        
        // Sports & Fitness Events
        Event(title: "5K Color Run", date: "April 19", dateDetail: "April 19, 2025", location: "Murphy Park", category: "🏃 Fitness", time: "7:00 AM - 11:00 AM", description: "Run through color stations and get doused in colored powder! All ages welcome. Register online.", organizer: "CG Parks & Rec", attendeeCount: 300, imageColor: .mint),
        Event(title: "Youth Soccer League Games", date: "Saturdays", dateDetail: "April 12, 2025", location: "Johnson Park", category: "🏃 Fitness", time: "9:00 AM - 4:00 PM", description: "Watch the youth soccer league in action! Concessions available.", organizer: "CG Youth Soccer", attendeeCount: 200, imageColor: .green),
        
        // Religious & Cultural Events
        Event(title: "Easter Sunrise Service", date: "April 20", dateDetail: "April 20, 2025", location: "Mountain View Church", category: "⛪ Religious", time: "6:30 AM - 8:00 AM", description: "Celebrate Easter morning with a sunrise service, breakfast, and community fellowship.", organizer: "Mountain View Church", attendeeCount: 150, imageColor: .purple),
        Event(title: "Cinco de Mayo Festival", date: "May 3", dateDetail: "May 3, 2025", location: "Veterans Memorial Park", category: "🎉 Cultural", time: "10:00 AM - 10:00 PM", description: "Celebrate Mexican heritage with live music, dancers, authentic food vendors, and carnival rides!", organizer: "CG Cultural Council", attendeeCount: 3000, imageColor: .green)
    ]
    
    @State private var selectedCategory = "All"
    @State private var searchText = ""
    @State private var showingFilters = false
    
    var categories = ["All", "🛒 Community", "🎓 Campus", "✈️ Military", "🎵 Events", "🎨 Arts", "👨‍👩‍👧 Family", "🏠 Real Estate", "💼 Business", "🍔 Food & Drink", "🏃 Fitness", "⛪ Religious", "🎉 Cultural"]
    
    var filteredEvents: [Event] {
        var result = events
        if selectedCategory != "All" {
            result = result.filter { $0.category == selectedCategory }
        }
        if !searchText.isEmpty {
            result = result.filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.location.localizedCaseInsensitiveContains(searchText) }
        }
        return result
    }
    
    var upcomingEvents: [Event] {
        Array(filteredEvents.prefix(5))
    }
    
    var body: some View {
        NavigationStack {
            List {
                // This Week Section
                Section {
                    ForEach(upcomingEvents) { event in
                        EventRowView(event: event)
                    }
                } header: {
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                        Text("This Week in Casa Grande")
                            .font(.headline)
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
                
                // All Events
                Section {
                    ForEach(filteredEvents) { event in
                        EventRowView(event: event)
                    }
                } header: {
                    Text(selectedCategory == "All" ? "All Events (\(filteredEvents.count))" : "\(selectedCategory) (\(filteredEvents.count))")
                }
            }
            .searchable(text: $searchText, prompt: "Search events")
            .navigationTitle("Events")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingFilters = true }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "plus.circle")
                    }
                }
            }
        }
    }
}

struct EventRowView: View {
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(event.category)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(event.imageColor)
                    .cornerRadius(4)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "person.2.fill")
                        .font(.caption2)
                    Text("\(event.attendeeCount)")
                        .font(.caption)
                }
                .foregroundColor(.secondary)
            }
            
            Text(event.title)
                .font(.headline)
            
            HStack {
                Image(systemName: "calendar")
                    .font(.caption)
                Text(event.dateDetail)
                    .font(.caption)
                Text("•")
                Text(event.time)
                    .font(.caption)
            }
            .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: "mappin")
                    .font(.caption)
                Text(event.location)
                    .font(.caption)
            }
            .foregroundColor(.secondary)
            
            Text(event.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack {
                Text("By: \(event.organizer)")
                    .font(.caption2)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "calendar.badge.plus")
                        Text("Add to Calendar")
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
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
}

#Preview {
    EventsView()
}
