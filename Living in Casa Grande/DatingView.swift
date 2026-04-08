import SwiftUI

struct DatingProfile: Identifiable {
    let id = UUID()
    let name: String
    let age: Int
    let bio: String
    let interests: [String]
    let lookingFor: String
    let distance: String
    let isVerified: Bool
    let isMilitary: Bool
    let isStudent: Bool
    let imageColor: Color
    let education: String
    let occupation: String
    let gender: String
}

struct DatingPreferences {
    var minAge: Int = 18
    var maxAge: Int = 65
    var maxDistance: Int = 50 // miles
    var lookingFor: Set<String> = ["Friends", "Relationship", "Casual"]
    var showMilitary: Bool = true
    var showStudents: Bool = true
}

struct DatingView: View {
    @State private var currentIndex = 0
    @State private var matchedProfiles: [DatingProfile] = []
    @State private var passedProfiles: [DatingProfile] = []
    @State private var showingMatches = false
    @State private var showingPreferences = false
    @State private var preferences = DatingPreferences()
    @State private var offset: CGSize = .zero
    @State private var isDragging = false
    
    @State private var profiles: [DatingProfile] = [
        // Military Profiles
        DatingProfile(name: "James T.", age: 29, bio: "Air Force Officer at the base. Originally from Texas. Into fitness, football, and finding the best BBQ in AZ. Let's grab a beer!", interests: ["Fitness", "Football", "BBQ", "Gaming"], lookingFor: "Relationship", distance: "2 miles", isVerified: true, isMilitary: true, isStudent: false, imageColor: .blue, education: "Bachelor's", occupation: "Air Force Officer", gender: "Male"),
        DatingProfile(name: "Brandon H.", age: 25, bio: "Just PCS'd to the AFB. From California. Looking to explore CG and meet some cool people. Anyone want to show me around?", interests: ["Gaming", "Movies", "Exploring", "Hiking"], lookingFor: "Casual", distance: "5 miles", isVerified: true, isMilitary: true, isStudent: false, imageColor: .indigo, education: "Some College", occupation: "Security Forces", gender: "Male"),
        DatingProfile(name: "Marcus W.", age: 31, bio: "Pilot in the Air Force. Been here 2 years now. Looking for someone to explore AZ with. Love road trips and sunsets.", interests: ["Flying", "Road Trips", "Sunsets", "Photography"], lookingFor: "Relationship", distance: "8 miles", isVerified: true, isMilitary: true, isStudent: false, imageColor: .cyan, education: "Master's", occupation: "Pilot", gender: "Male"),
        DatingProfile(name: "Tyler R.", age: 27, bio: "Air Force Security Forces. Work long hours but weekends are free. Looking for low-key fun and good conversations.", interests: ["Working Out", "Netflix", "Music", "Food"], lookingFor: "Friends", distance: "3 miles", isVerified: true, isMilitary: true, isStudent: false, imageColor: .navy, education: "Bachelor's", occupation: "Security Forces", gender: "Male"),
        
        // ASU Poly Student Profiles
        DatingProfile(name: "Sophia M.", age: 23, bio: "ASU Poly Senior! Business major. Love coffee, live music, and exploring Phoenix on weekends. Looking to meet new people!", interests: ["Coffee", "Music", "Art", "Shopping"], lookingFor: "Friends", distance: "1 mile", isVerified: false, isMilitary: false, isStudent: true, imageColor: .purple, education: "Bachelor's (Senior)", occupation: "Student", gender: "Female"),
        DatingProfile(name: "David L.", age: 28, bio: "ASU Poly Graduate Student. Researching renewable energy. Into sustainability, farming, and good conversations.", interests: ["Sustainability", "Farming", "Reading", "Cooking"], lookingFor: "Relationship", distance: "1 mile", isVerified: true, isMilitary: false, isStudent: true, imageColor: .mint, education: "Master's", occupation: "Graduate Student", gender: "Male"),
        DatingProfile(name: "Emma K.", age: 21, bio: "Nursing student at ASU Poly. Future RN! Love helping people. In my free time I do yoga and volunteer.", interests: ["Nursing", "Yoga", "Volunteering", "Netflix"], lookingFor: "Relationship", distance: "2 miles", isVerified: false, isMilitary: false, isStudent: true, imageColor: .pink, education: "Bachelor's (Junior)", occupation: "Student", gender: "Female"),
        DatingProfile(name: "Noah G.", age: 22, bio: "Engineering student. I'm into robotics and tech. Looking for someone who can handle my nerdy humor.", interests: ["Engineering", "Robotics", "Video Games", "BBQ"], lookingFor: "Casual", distance: "1 mile", isVerified: false, isMilitary: false, isStudent: true, imageColor: .orange, education: "Bachelor's (Senior)", occupation: "Student", gender: "Male"),
        DatingProfile(name: "Olivia S.", age: 24, bio: "Graduate student in Education. Future teacher! Love kids and making a difference. Let's grab coffee!", interests: ["Teaching", "Kids", "Coffee", "Books"], lookingFor: "Relationship", distance: "3 miles", isVerified: true, isMilitary: false, isStudent: true, imageColor: .yellow, education: "Master's", occupation: "Graduate Student", gender: "Female"),
        DatingProfile(name: "Liam M.", age: 23, bio: "Computer Science major. Hackathon champion. Looking for someone who can appreciate my nerdy humor.", interests: ["Coding", "Gaming", "Anime", "Tech"], lookingFor: "Friends", distance: "1 mile", isVerified: false, isMilitary: false, isStudent: true, imageColor: .green, education: "Bachelor's (Junior)", occupation: "Student", gender: "Male"),
        
        // Snowbird Profiles
        DatingProfile(name: "Ashley K.", age: 55, bio: "Snowbird from Chicago! Here for the winter. Love yoga, the beach, and meeting new people. Let's grab drinks!", interests: ["Yoga", "Beach", "Meeting New People", "Wine"], lookingFor: "Casual", distance: "4 miles", isVerified: true, isMilitary: false, isStudent: false, imageColor: .coral, education: "Bachelor's", occupation: "Retired HR Manager", gender: "Female"),
        DatingProfile(name: "Robert R.", age: 62, bio: "Retired from Chicago. Homebody who loves gardening and cooking. Looking for someone to share quiet evenings with.", interests: ["Gardening", "Cooking", "Netflix", "Travel"], lookingFor: "Relationship", distance: "6 miles", isVerified: true, isMilitary: false, isStudent: false, imageColor: .brown, education: "Master's", occupation: "Retired Engineer", gender: "Male"),
        DatingProfile(name: "Linda M.", age: 58, bio: "Recently widowed. Ready to get back out there! Love dancing, travel, and good conversations.", interests: ["Dancing", "Travel", "Conversation", "Dinner"], lookingFor: "Relationship", distance: "5 miles", isVerified: true, isMilitary: false, isStudent: false, imageColor: .magenta, education: "Bachelor's", occupation: "Retired Teacher", gender: "Female"),
        
        // Young Professional Profiles
        DatingProfile(name: "Emily R.", age: 26, bio: "New to Casa Grande! Military spouse, love hiking and trying local restaurants. Looking to make friends and maybe more.", interests: ["Hiking", "Food", "Travel", "Yoga"], lookingFor: "Relationship", distance: "2 miles", isVerified: true, isMilitary: false, isStudent: false, imageColor: .pink, education: "Bachelor's", occupation: "Marketing Manager", gender: "Female"),
        DatingProfile(name: "Michael S.", age: 32, bio: "Software developer, work remote. Looking for someone who appreciates good conversations and bad puns.", interests: ["Tech", "Gaming", "Cooking", "Movies"], lookingFor: "Relationship", distance: "7 miles", isVerified: true, isMilitary: false, isStudent: false, imageColor: .green, education: "Master's", occupation: "Software Developer", gender: "Male"),
        DatingProfile(name: "Jessica P.", age: 30, bio: "Elementary school teacher in CG. Love kids, arts & crafts, and weekend adventures. Looking for genuine connections.", interests: ["Teaching", "Arts & Crafts", "Adventure", "Family"], lookingFor: "Relationship", distance: "3 miles", isVerified: true, isMilitary: false, isStudent: false, imageColor: .red, education: "Bachelor's", occupation: "Elementary Teacher", gender: "Female"),
        DatingProfile(name: "Chris H.", age: 34, bio: "Physical therapist at the hospital. Fit, active, and love the outdoors. Looking for someone who enjoys an active lifestyle.", interests: ["Fitness", "Outdoors", "Sports", "Health"], lookingFor: "Relationship", distance: "4 miles", isVerified: true, isMilitary: false, isStudent: false, imageColor: .teal, education: "Doctorate", occupation: "Physical Therapist", gender: "Male"),
        DatingProfile(name: "Amanda T.", age: 28, bio: "Nurse at the hospital. Long shifts but when I'm off I love live music, good food, and exploring Arizona.", interests: ["Nursing", "Live Music", "Food", "Travel"], lookingFor: "Friends", distance: "5 miles", isVerified: true, isMilitary: false, isStudent: false, imageColor: .crimson, education: "Bachelor's", occupation: "Registered Nurse", gender: "Female"),
        DatingProfile(name: "Ryan B.", age: 35, bio: "Real estate agent in CG. I love my job and my city! Looking for someone who appreciates a good deal and a good time.", interests: ["Real Estate", "Investing", "Networking", "Golf"], lookingFor: "Casual", distance: "2 miles", isVerified: true, isMilitary: false, isStudent: false, imageColor: .gold, education: "Bachelor's", occupation: "Real Estate Agent", gender: "Male"),
        DatingProfile(name: "Nicole P.", age: 29, bio: "Marketing manager for a local company. Creative, ambitious, and love a good book. Looking for genuine connection.", interests: ["Marketing", "Reading", "Coffee", "Art"], lookingFor: "Relationship", distance: "6 miles", isVerified: true, isMilitary: false, isStudent: false, imageColor: .lavender, education: "Master's", occupation: "Marketing Manager", gender: "Female"),
        DatingProfile(name: "Daniel K.", age: 38, bio: "Contractor/handyman. Good with my hands and honest work. Looking for someone who appreciates that.", interests: ["Construction", "DIY", "Fishing", "Grilling"], lookingFor: "Relationship", distance: "8 miles", isVerified: true, isMilitary: false, isStudent: false, imageColor: .khaki, education: "Certification", occupation: "Contractor", gender: "Male"),
        DatingProfile(name: "Sarah J.", age: 27, bio: "Veterinarian at the local animal clinic. Animal lover to the core! Looking for someone with a big heart.", interests: ["Animals", "Vet Med", "Hiking", "Wine"], lookingFor: "Relationship", distance: "3 miles", isVerified: true, isMilitary: false, isStudent: false, imageColor: .rose, education: "Doctorate", occupation: "Veterinarian", gender: "Female"),
        DatingProfile(name: "Jason W.", age: 33, bio: "Firefighter with CG Fire Dept. When I'm not fighting fires I love camping, sports, and cooking.", interests: ["Firefighting", "Camping", "Sports", "Cooking"], lookingFor: "Relationship", distance: "4 miles", isVerified: true, isMilitary: false, isStudent: false, imageColor: .red, education: "Certification", occupation: "Firefighter", gender: "Male"),
        DatingProfile(name: "Michelle L.", age: 31, bio: "HR manager at a local company. Work hard, play hard. Love concerts, travel, and good food.", interests: ["HR", "Concerts", "Travel", "Food"], lookingFor: "Casual", distance: "5 miles", isVerified: true, isMilitary: false, isStudent: false, imageColor: .violet, education: "Bachelor's", occupation: "HR Manager", gender: "Female")
    ]
    
    var filteredProfiles: [DatingProfile] {
        profiles.filter { profile in
            let ageMatch = profile.age >= preferences.minAge && profile.age <= preferences.maxAge
            let distanceMatch = true // Simplified for now
            let lookingForMatch = preferences.lookingFor.contains(profile.lookingFor)
            let militaryMatch = preferences.showMilitary || !profile.isMilitary
            let studentMatch = preferences.showStudents || !profile.isStudent
            let notPassed = !passedProfiles.contains(where: { $0.id == profile.id })
            return ageMatch && distanceMatch && lookingForMatch && militaryMatch && studentMatch && notPassed
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color.gray.opacity(0.1)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    headerView
                    
                    // Profile Cards
                    if let profile = filteredProfiles.dropFirst(currentIndex).first {
                        ZStack {
                            SwipeCardView(profile: profile)
                                .offset(offset)
                                .gesture(
                                    DragGesture()
                                        .onChanged { gesture in
                                            offset = gesture.translation
                                            isDragging = true
                                        }
                                        .onEnded { gesture in
                                            if gesture.translation.width > 100 {
                                                // Swipe right - Like
                                                withAnimation(.spring()) {
                                                    offset = CGSize(width: 500, height: 0)
                                                }
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                    likeProfile(profile)
                                                }
                                            } else if gesture.translation.width < -100 {
                                                // Swipe left - Pass
                                                withAnimation(.spring()) {
                                                    offset = CGSize(width: -500, height: 0)
                                                }
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                    passProfile(profile)
                                                }
                                            } else {
                                                withAnimation(.spring()) {
                                                    offset = .zero
                                                }
                                            }
                                            isDragging = false
                                        }
                                )
                            
                            // Action Buttons
                            actionButtonsView(profile: profile)
                        }
                        .padding(.horizontal)
                    } else {
                        noMoreProfilesView
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Dating")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { showingPreferences = true }) {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingMatches = true }) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.pink)
                    }
                }
            }
            .sheet(isPresented: $showingMatches) {
                MatchesView(matches: matchedProfiles)
            }
            .sheet(isPresented: $showingPreferences) {
                PreferencesView(preferences: $preferences)
            }
        }
    }
    
    var headerView: some View {
        HStack {
            Text("Going Local")
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(filteredProfiles.count) nearby")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(preferences.maxDistance) mi radius")
                    .font(.caption2)
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
    
    func actionButtonsView(profile: DatingProfile) -> some View {
        HStack(spacing: 30) {
            // Pass Button
            Button(action: {
                withAnimation(.spring()) {
                    offset = CGSize(width: -500, height: 0)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    passProfile(profile)
                }
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.red)
                    .frame(width: 60, height: 60)
                    .background(Color.red.opacity(0.1))
                    .clipShape(Circle())
            }
            
            // Super Like Button
            Button(action: {
                // Super like - always matches
                withAnimation(.spring()) {
                    offset = CGSize(width: 0, height: -500)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    matchedProfiles.append(profile)
                    passedProfiles.append(profile)
                    offset = .zero
                }
            }) {
                Image(systemName: "star.fill")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.blue)
                    .frame(width: 50, height: 50)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
            }
            
            // Like Button
            Button(action: {
                withAnimation(.spring()) {
                    offset = CGSize(width: 500, height: 0)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    likeProfile(profile)
                }
            }) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.green)
                    .frame(width: 60, height: 60)
                    .background(Color.green.opacity(0.1))
                    .clipShape(Circle())
            }
        }
        .padding(.vertical, 20)
    }
    
    var noMoreProfilesView: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash")
                .font(.system(size: 80))
                .foregroundColor(.gray)
            
            Text("No more profiles!")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Try adjusting your preferences or check back later")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: { showingPreferences = true }) {
                Text("Adjust Preferences")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(25)
            }
            
            Button(action: resetProfiles) {
                Text("Start Over")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
    
    func likeProfile(_ profile: DatingProfile) {
        matchedProfiles.append(profile)
        passedProfiles.append(profile)
        offset = .zero
        currentIndex += 1
    }
    
    func passProfile(_ profile: DatingProfile) {
        passedProfiles.append(profile)
        offset = .zero
        currentIndex += 1
    }
    
    func resetProfiles() {
        passedProfiles.removeAll()
        matchedProfiles.removeAll()
        currentIndex = 0
    }
}

struct SwipeCardView: View {
    let profile: DatingProfile
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(profile.imageColor.gradient)
                    .frame(height: 450)
                
                VStack {
                    Image(systemName: "person.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                // Gradient overlay for text
                VStack {
                    Spacer()
                    LinearGradient(colors: [.clear, .black.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                        .frame(height: 200)
                }
                .cornerRadius(20)
                
                // Badges
                VStack {
                    HStack {
                        if profile.isVerified {
                            BadgeView(text: "✓ Verified", color: .green)
                        }
                        Spacer()
                        if profile.isMilitary {
                            BadgeView(text: "✈️ Military", color: .blue)
                        }
                        if profile.isStudent {
                            BadgeView(text: "🎓 Student", color: .purple)
                        }
                    }
                    .padding()
                    Spacer()
                    HStack {
                        Text("\(profile.distance)")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(10)
                        Spacer()
                    }
                    .padding()
                }
            }
            
            // Info
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("\(profile.name), \(profile.age)")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "briefcase")
                        .font(.caption)
                    Text(profile.occupation)
                        .font(.caption)
                }
                .foregroundColor(.secondary)
                
                HStack {
                    Image(systemName: "graduationcap")
                        .font(.caption)
                    Text(profile.education)
                        .font(.caption)
                }
                .foregroundColor(.secondary)
                
                Text(profile.bio)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                // Interests
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(profile.interests, id: \.self) { interest in
                            Text(interest)
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(12)
                        }
                    }
                }
                
                // Looking for
                HStack {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.pink)
                    Text("Looking for: \(profile.lookingFor)")
                        .font(.caption)
                        .foregroundColor(.pink)
                }
            }
            .padding()
            .background(Color(.systemBackground))
        }
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

struct BadgeView: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color)
            .cornerRadius(8)
    }
}

struct PreferencesView: View {
    @Binding var preferences: DatingPreferences
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Age Range") {
                    Stepper("Min Age: \(preferences.minAge)", value: $preferences.minAge, in: 18...40)
                    Stepper("Max Age: \(preferences.maxAge)", value: $preferences.maxAge, in: 41...80)
                }
                
                Section("Distance") {
                    Stepper("Max Distance: \(preferences.maxDistance) miles", value: $preferences.maxDistance, in: 10...100, step: 10)
                }
                
                Section("Looking For") {
                    Toggle("Friends", isOn: Binding(
                        get: { preferences.lookingFor.contains("Friends") },
                        set: { if $0 { preferences.lookingFor.insert("Friends") } else { preferences.lookingFor.remove("Friends") } }
                    ))
                    Toggle("Relationship", isOn: Binding(
                        get: { preferences.lookingFor.contains("Relationship") },
                        set: { if $0 { preferences.lookingFor.insert("Relationship") } else { preferences.lookingFor.remove("Relationship") } }
                    ))
                    Toggle("Casual", isOn: Binding(
                        get: { preferences.lookingFor.contains("Casual") },
                        set: { if $0 { preferences.lookingFor.insert("Casual") } else { preferences.lookingFor.remove("Casual") } }
                    ))
                }
                
                Section("Show") {
                    Toggle("Show Military Members", isOn: $preferences.showMilitary)
                    Toggle("Show ASU Poly Students", isOn: $preferences.showStudents)
                }
            }
            .navigationTitle("Preferences")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct MatchesView: View {
    @Environment(\.dismiss) var dismiss
    let matches: [DatingProfile]
    
    var body: some View {
        NavigationStack {
            List {
                if matches.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No matches yet!")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        Text("Keep swiping to find your match in Casa Grande")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                } else {
                    ForEach(matches) { profile in
                        HStack(spacing: 12) {
                            Circle()
                                .fill(profile.imageColor)
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.white)
                                        .font(.title2)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(profile.name)
                                        .font(.headline)
                                    Text(", \(profile.age)")
                                        .foregroundColor(.secondary)
                                }
                                Text(profile.occupation)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(profile.lookingFor)
                                    .font(.caption)
                                    .foregroundColor(.pink)
                            }
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.blue)
                                    .font(.title2)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("Matches (\(matches.count))")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    DatingView()
}
