import SwiftUI

struct HeroDetailView: View {
    @StateObject var viewModel: HeroDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                switch viewModel.loadingState {
                case .idle, .loading:
                    loadingView()
                case .loaded:
                    if let hero = viewModel.hero {
                        heroDetailContent(hero: hero)
                    }
                case .error(let message):
                    errorView(message: message)
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .background(Color(.systemGroupedBackground))
        .task {
            await viewModel.fetchHeroDetails()
        }
    }
    
    @ViewBuilder
    private func loadingView() -> some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.5)
                .padding()
            Text("Loading hero details...")
                .font(.headline)
                .foregroundColor(.secondary)
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 300)
        .padding()
    }
    
    @ViewBuilder
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("Failed to load hero")
                .font(.title2)
                .fontWeight(.medium)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button(action: {
                Task {
                    await viewModel.fetchHeroDetails()
                }
            }) {
                Text("Try Again")
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.top, 8)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 300)
        .padding()
    }
    
    @ViewBuilder
    private func heroDetailContent(hero: HeroDetailModel) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            heroHeader(hero: hero)
            sectionTitle("Power Stats")
            powerStatsView(hero: hero)
            sectionTitle("Biography")
            biographySection(hero: hero)
            sectionTitle("Appearance")
            appearanceSection(hero: hero)
            sectionTitle("Work")
            workSection(hero: hero)
            sectionTitle("Connections")
            connectionsSection(hero: hero)
            Color.clear.frame(height: 24)
        }
    }
    
    @ViewBuilder
    private func heroHeader(hero: HeroDetailModel) -> some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: hero.largeImageUrl) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 250)
                        .clipped()
                case .failure:
                    Color.gray.opacity(0.3)
                        .frame(height: 250)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                        )
                case .empty:
                    Color.gray.opacity(0.1)
                        .frame(height: 250)
                        .overlay(
                            ProgressView()
                        )
                @unknown default:
                    EmptyView()
                }
            }
            
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 150)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(hero.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                if !hero.fullName.isEmpty && hero.fullName != hero.name {
                    Text(hero.fullName)
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.9))
                }
                
                HStack {
                    alignmentBadge(hero.alignment)
                    
                    if !hero.race.isEmpty && hero.race != "Unknown" {
                        Text(hero.race)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    if let publisher = hero.publisher, !publisher.isEmpty {
                        Text(publisher)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }
    
    @ViewBuilder
    private func alignmentBadge(_ alignment: String) -> some View {
        Text(alignment.capitalized)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                alignment == "good" ? Color.green.opacity(0.3) :
                alignment == "bad" ? Color.red.opacity(0.3) :
                Color.orange.opacity(0.3)
            )
            .foregroundColor(.white)
            .cornerRadius(8)
    }
    
    @ViewBuilder
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom, 8)
    }
    
    @ViewBuilder
    private func powerStatsView(hero: HeroDetailModel) -> some View {
        VStack(spacing: 16) {
            Group {
                powerStatBar(label: "Intelligence", value: hero.intelligence)
                powerStatBar(label: "Strength", value: hero.strength)
                powerStatBar(label: "Speed", value: hero.speed)
                powerStatBar(label: "Durability", value: hero.durability)
                powerStatBar(label: "Power", value: hero.power)
                powerStatBar(label: "Combat", value: hero.combat)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private func powerStatBar(label: String, value: Int) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .frame(width: 100, alignment: .leading)
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 8)
                    .foregroundColor(Color.gray.opacity(0.3))
                    .cornerRadius(4)
                
                Rectangle()
                    .frame(width: CGFloat(value) / 100 * 200, height: 8)
                    .foregroundColor(powerStatColor(value))
                    .cornerRadius(4)
            }
            .frame(width: 200)
            
            Text("\(value)")
                .font(.subheadline)
                .fontWeight(.bold)
                .frame(width: 40, alignment: .trailing)
        }
    }
    
    private func powerStatColor(_ value: Int) -> Color {
        switch value {
        case 0..<20: return .red
        case 20..<40: return .orange
        case 40..<60: return .yellow
        case 60..<80: return .green
        default: return .blue
        }
    }
    
    @ViewBuilder
    private func biographySection(hero: HeroDetailModel) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            detailRow(title: "Full Name", value: hero.fullName)
            detailRow(title: "Alter Egos", value: hero.alterEgos)
            
            if !hero.aliases.isEmpty {
                detailRow(title: "Aliases", value: hero.aliases.joined(separator: ", "))
            }
            
            detailRow(title: "Place of Birth", value: hero.placeOfBirth)
            detailRow(title: "First Appearance", value: hero.firstAppearance)
            
            if let publisher = hero.publisher {
                detailRow(title: "Publisher", value: publisher)
            }
            
            detailRow(title: "Alignment", value: hero.alignment.capitalized)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private func appearanceSection(hero: HeroDetailModel) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            detailRow(title: "Gender", value: hero.gender)
            detailRow(title: "Race", value: hero.race)
            
            if !hero.height.isEmpty {
                detailRow(title: "Height", value: hero.height.joined(separator: " / "))
            }
            
            if !hero.weight.isEmpty {
                detailRow(title: "Weight", value: hero.weight.joined(separator: " / "))
            }
            
            detailRow(title: "Eye Color", value: hero.eyeColor)
            detailRow(title: "Hair Color", value: hero.hairColor)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private func workSection(hero: HeroDetailModel) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            detailRow(title: "Occupation", value: hero.occupation)
            detailRow(title: "Base of Operations", value: hero.base)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private func connectionsSection(hero: HeroDetailModel) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            detailRow(title: "Group Affiliation", value: hero.groupAffiliation)
            detailRow(title: "Relatives", value: hero.relatives)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private func detailRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value.isEmpty ? "Unknown" : value)
                .font(.body)
        }
    }
}
