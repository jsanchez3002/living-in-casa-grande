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
}

struct DatingView: View {
    @State private var currentIndex = 0
    @State private var matchedProfiles: [DatingProfile] = []
    @State private var showingMatches = false
    @State private var profiles: [DatingProfile] = [
        DatingProfile(name: "Emily R.", age: 26, bio: "New to Casa Grande! Military spouse, love hiking and trying local restaurants. Looking to make friends and maybe more.", interests: ["Hiking", "Food", "Travel"], lookingFor: "Friends or Relationship", distance: "2 miles", isVerified: true, isMilitary: false, isStudent: false, imageColor: .pink),
        DatingProfile(name: "James T.", age: 29, bio: "Air Force Officer at the base. Originally from Texas. Into fitness, football, and finding the best BBQ in AZ.", interests: ["Fitness", "Football", "BBQ"], lookingFor: "Casual or Relationship", distance: "5 miles", isVerified: true, isMilitary: true, isStudent: false, imageColor: .blue),
        DatingProfile(name: "Sophia M.", age: 23, bio: "ASU Poly Senior! Business major. Love coffee, live music, and exploring Phoenix on weekends.", interests: ["Coffee", "Music", "Art"], lookingFor: "Friends", distance: "1 mile", isVerified: false, isMilitary: false, isStudent: true, imageColor: .purple),
        DatingProfile(name: "Michael S.", age: 32, bio: "Software developer, work remote. Looking for someone who appreciates good conversations and bad puns.", interests: ["Tech", "Gaming", "Cooking"], lookingFor: "Relationship", distance: "8 miles", isVerified: true, isMilitary: false, isStudent: false, imageColor: .green),
        DatingProfile(name: "Ashley K.", age: 27, bio: "Nurse at the hospital. Snowbird from Chicago, here for the winter. Love yoga, the beach, and meeting locals.", interests: ["Yoga", "Beach", "Meeting New People"], lookingFor: "Friends or Casual", distance: "3 miles", isVerified: true, isMilitary: false, isStudent: false, imageColor: .orange),
        DatingProfile(name: "David L.", age: 28, bio: "ASU Poly Graduate Student. Researching renewable energy. Into sustainability, farming, and good conversations.", interests: ["Sustainability", "Farming", "Reading"], lookingFor: "Friends or Relationship", distance: "1 mile", isVerified: true, isMilitary: false, isStudent: true, imageColor: .mint),
        DatingProfile(name: "Jessica P.", age: 30, bio: "Elementary school teacher in CG. Love kids, arts & crafts, and weekend adventures. Looking for genuine connections.", interests: ["Teaching", "Arts & Crafts", "Adventure"], lookingFor: "Relationship", distance: "4 miles", isVerified: true, isMilitary: false, isStudent: false, imageColor: .red),
        DatingProfile(name: "Brandon H.", age: 25, bio: "Just PCS'd to the AFB. From California. Looking to explore CG and meet some cool people.", interests: ["Gaming", "Movies", "Exploring"], lookingFor: "Friends or Casual", distance: "6 miles", isVerified: true, isMilitary: true, isStudent: false, imageColor: .indigo)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Text("Going Local")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: { showingMatches = true }) {
                        HStack(spacing: 4) {
                            Image(systemName: "heart.fill")
                                .font(.title2)
                                .foregroundColor(.pink)
                            if !matchedProfiles.isEmpty {
                                Text("\(matchedProfiles.count)")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.pink)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
                .padding()
                
                if currentIndex < profiles.count {
                    ProfileCardView(profile: profiles[currentIndex])
                        .padding(.horizontal)
                    
                    HStack(spacing: 40) {
                        Button(action: { 
                            if currentIndex < profiles.count {
                                currentIndex += 1
                            }
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.gray)
                                .frame(width: 60, height: 60)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Circle())
                        }
                        
                        Button(action: { 
                            if currentIndex < profiles.count {
                                matchedProfiles.append(profiles[currentIndex])
                                currentIndex += 1
                            }
                        }) {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.pink)
                                .frame(width: 80, height: 80)
                                .background(Color.pink.opacity(0.2))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.vertical, 20)
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No more profiles nearby!")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        Text("Check back later for more people in Casa Grande")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.blue)
                        Text("Going Local")
                            .font(.headline)
                        Spacer()
                    }
                    Text("See who's checked into venues near you tonight")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationTitle("Dating")
            .sheet(isPresented: $showingMatches) {
                MatchesView(matches: matchedProfiles)
            }
        }
    }
}

struct ProfileCardView: View {
    let profile: DatingProfile
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(profile.imageColor.gradient)
                    .frame(height: 350)
                
                VStack {
                    Image(systemName: "person.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                VStack {
                    HStack {
                        Spacer()
                        if profile.isVerified {
                            BadgeView(text: "Verified", color: .green)
                        }
                    }
                    Spacer()
                    HStack {
                        if profile.isMilitary {
                            BadgeView(text: "Military", color: .blue)
                        }
                        if profile.isStudent {
                            BadgeView(text: "Student", color: .purple)
                        }
                        Spacer()
                        BadgeView(text: profile.distance, color: Color.black.opacity(0.6))
                    }
                }
                .padding(12)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("\(profile.name), \(profile.age)")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "location.fill")
                        .font(.caption)
                    Text(profile.distance)
                        .font(.subheadline)
                    Text("-")
                    Text(profile.lookingFor)
                        .font(.subheadline)
                        .foregroundColor(.pink)
                }
                .foregroundColor(.secondary)
                
                Text(profile.bio)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                
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
            .padding(.horizontal, 4)
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
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
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.white)
                                )
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(profile.name)
                                        .font(.headline)
                                    Text(", \(profile.age)")
                                        .foregroundColor(.secondary)
                                }
                                Text(profile.lookingFor)
                                    .font(.caption)
                                    .foregroundColor(.pink)
                            }
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Your Matches")
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
