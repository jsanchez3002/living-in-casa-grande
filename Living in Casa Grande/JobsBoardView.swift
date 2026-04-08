import SwiftUI

struct Job: Identifiable {
    let id = UUID()
    let title: String
    let company: String
    let location: String
    let type: String
    let pay: String
    let description: String
    let requirements: String
    let contactEmail: String
    let postedDaysAgo: Int
    let featured: Bool
}

struct JobsBoardView: View {
    @State private var jobs: [Job] = [
        Job(title: "Real Estate Agent", company: "Sanchez Group | REAL Brokerage", location: "Casa Grande, AZ", type: "Full-time", pay: "$50,000 - $150,000+", description: "Join Arizona's fastest-growing real estate team. Lead generation, training provided, flexible schedule.", requirements: "AZ real estate license preferred but will train", contactEmail: "contact@realsanchez.com", postedDaysAgo: 1, featured: true),
        Job(title: "House Cleaner", company: "AA Cleaning AZ", location: "Casa Grande, AZ", type: "Part-time", pay: "$18-25/hour", description: "Professional house cleaning. Great for students or anyone needing flexible hours. Travel required.", requirements: "Valid driver's license, reliable transportation", contactEmail: "info@aacleaningaz.com", postedDaysAgo: 2, featured: true),
        Job(title: "Server", company: "Brewer's Restaurant", location: "201 N Florence St", type: "Part-time", pay: "$15-20/hr + tips", description: "Experienced server needed. Night and weekend availability required. Great work environment.", requirements: "1+ year serving experience", contactEmail: "manager@brewerscg.com", postedDaysAgo: 3, featured: false),
        Job(title: "Marketing Coordinator", company: "Sanchez Group", location: "Remote / Casa Grande", type: "Contract", pay: "$25-40/hour", description: "Social media management, content creation, photography for real estate listings.", requirements: "Experience with Instagram, Facebook, Canva", contactEmail: "contact@realsanchez.com", postedDaysAgo: 4, featured: false),
        Job(title: "Delivery Driver", company: "Pizza Hut", location: "Casa Grande, AZ", type: "Part-time", pay: "$15-18/hr + tips", description: "Delivery driver for busy pizza restaurant. Must have valid license and insurance.", requirements: "Valid AZ driver's license, insurance", contactEmail: "apply@pizzahut-cg.com", postedDaysAgo: 5, featured: false),
        Job(title: "Customer Service Rep", company: "Grande Rentals", location: "Casa Grande, AZ", type: "Full-time", pay: "$17-20/hour", description: "Property management customer service. Handle tenant inquiries, maintenance requests, leasing.", requirements: "1+ years property management experience", contactEmail: "jobs@granderentals.com", postedDaysAgo: 6, featured: false),
        Job(title: "Registered Nurse", company: "Casa Grande Regional Medical", location: "Casa Grande, AZ", type: "Full-time", pay: "$35-50/hour", description: "RN positions available for ER, ICU, and Med-Surg units. Sign-on bonus available.", requirements: "AZ RN license, BLS/ACLS certs", contactEmail: "hr@cgrmc.org", postedDaysAgo: 7, featured: false),
        Job(title: "Teaching Assistant", company: "ASU Polytechnic", location: "ASU Poly Campus", type: "Part-time", pay: "$16-18/hour", description: "Assist faculty with classroom instruction, grading, student support.", requirements: "Bachelor's degree preferred", contactEmail: "hr@asu.edu", postedDaysAgo: 8, featured: false),
        Job(title: "Retail Associate", company: "Target", location: "Casa Grande, AZ", type: "Part-time", pay: "$15-17/hour", description: "Customer service, stocking shelves, maintaining store appearance. Employee discount included.", requirements: "Available weekends", contactEmail: "apply@target.com", postedDaysAgo: 10, featured: false),
        Job(title: "HVAC Technician", company: "Local HVAC Company", location: "Casa Grande, AZ", type: "Full-time", pay: "$25-35/hour", description: "Residential and commercial HVAC installation and repair. EPA certification required.", requirements: "EPA 608 Universal, valid AZ driver's license", contactEmail: "apply@hvac-cg.com", postedDaysAgo: 12, featured: false)
    ]
    
    @State private var selectedType = "All"
    @State private var showingNewJob = false
    
    var jobTypes = ["All", "Full-time", "Part-time", "Contract", "Gig", "Internship"]
    
    var filteredJobs: [Job] {
        if selectedType == "All" {
            return jobs
        }
        return jobs.filter { $0.type == selectedType }
    }
    
    var body: some View {
        NavigationStack {
            List {
                // Featured Jobs
                let featuredJobs = filteredJobs.filter { $0.featured }
                if !featuredJobs.isEmpty && selectedType == "All" {
                    Section {
                        ForEach(featuredJobs) { job in
                            JobRowView(job: job, isFeatured: true)
                        }
                    } header: {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("Featured Jobs")
                                .font(.headline)
                        }
                    }
                }
                
                // Type Filter
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(jobTypes, id: \.self) { type in
                                Button(action: { selectedType = type }) {
                                    Text(type)
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(selectedType == type ? Color.blue : Color.gray.opacity(0.2))
                                        .foregroundColor(selectedType == type ? .white : .primary)
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
                
                // All Jobs
                Section {
                    ForEach(filteredJobs.filter { !$0.featured || selectedType != "All" }) { job in
                        JobRowView(job: job, isFeatured: false)
                    }
                } header: {
                    Text(selectedType == "All" ? "All Jobs (\(filteredJobs.count))" : "\(selectedType) (\(filteredJobs.count))")
                }
            }
            .navigationTitle("Jobs Board")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingNewJob = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewJob) {
                NewJobView()
            }
        }
    }
}

struct JobRowView: View {
    let job: Job
    let isFeatured: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(job.type)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(typeColor(for: job.type))
                    .cornerRadius(4)
                
                Spacer()
                
                if job.featured {
                    Text("FEATURED")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.orange)
                        .cornerRadius(4)
                }
                
                Text("\(job.postedDaysAgo)d ago")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(job.title)
                .font(.headline)
            
            Text(job.company)
                .font(.subheadline)
                .foregroundColor(.blue)
            
            HStack {
                Image(systemName: "mappin")
                Text(job.location)
            }
            .font(.caption)
            .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: "dollarsign.circle")
                Text(job.pay)
            }
            .font(.caption)
            .foregroundColor(.green)
            
            Text(job.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack(spacing: 12) {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "paperplane")
                        Text("Apply")
                    }
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .buttonStyle(.plain)
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "bookmark")
                        Text("Save")
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
                .buttonStyle(.plain)
                
                Spacer()
                
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
    
    func typeColor(for type: String) -> Color {
        switch type {
        case "Full-time": return .green
        case "Part-time": return .blue
        case "Contract": return .purple
        case "Gig": return .orange
        case "Internship": return .cyan
        default: return .gray
        }
    }
}

struct NewJobView: View {
    @Environment(\.dismiss) var dismiss
    @State private var jobTitle = ""
    @State private var companyName = ""
    @State private var location = ""
    @State private var selectedType = "Full-time"
    @State private var pay = ""
    @State private var description = ""
    
    let jobTypes = ["Full-time", "Part-time", "Contract", "Gig", "Internship"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Job Details") {
                    TextField("Job Title", text: $jobTitle)
                    TextField("Company Name", text: $companyName)
                    TextField("Location", text: $location)
                    Picker("Type", selection: $selectedType) {
                        ForEach(jobTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    TextField("Pay (e.g. $15-20/hour)", text: $pay)
                }
                
                Section("Description") {
                    TextEditor(text: $description)
                        .frame(minHeight: 100)
                }
                
                Section {
                    Text("This will be posted for 30 days")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Post a Job")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Post") {
                        // Post job functionality
                        dismiss()
                    }
                    .disabled(jobTitle.isEmpty || companyName.isEmpty)
                }
            }
        }
    }
}

#Preview {
    JobsBoardView()
}
