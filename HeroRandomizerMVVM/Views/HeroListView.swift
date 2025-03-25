import SwiftUI

struct HeroListView: View {
    @StateObject var viewModel: HeroListViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            headerView()
            searchBar()
            
            Divider()
                .padding(.bottom, 8)
            
            contentView()
        }
        .navigationTitle("Heroes")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchHeroes()
        }
    }
    
    @ViewBuilder
    private func headerView() -> some View {
        VStack {
            Text("Super Heroes")
                .font(.system(size: 28, weight: .bold))
                .padding(.top, 16)
                .padding(.bottom, 8)
            
            Text("Discover heroes and their abilities")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 16)
        }
    }
    
    @ViewBuilder
    private func searchBar() -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search heroes", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if !viewModel.searchText.isEmpty {
                Button(action: {
                    viewModel.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    @ViewBuilder
    private func contentView() -> some View {
        switch viewModel.loadingState {
        case .idle, .loading:
            loadingView()
        case .loaded:
            if viewModel.filteredHeroes.isEmpty && !viewModel.searchText.isEmpty {
                noResultsView()
            } else {
                listOfHeroes()
            }
        case .error(let message):
            errorView(message: message)
        }
    }
    
    @ViewBuilder
    private func loadingView() -> some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.5)
                .padding()
            Text("Loading heroes...")
                .font(.headline)
                .foregroundColor(.secondary)
            Spacer()
        }
    }
    
    @ViewBuilder
    private func noResultsView() -> some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("No heroes found")
                .font(.title2)
                .fontWeight(.medium)
            
            Text("Try a different search term")
                .font(.body)
                .foregroundColor(.secondary)
            Spacer()
        }
    }
    
    @ViewBuilder
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("Oops! Something went wrong")
                .font(.title2)
                .fontWeight(.medium)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button(action: {
                Task {
                    await viewModel.fetchHeroes()
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
    }
    
    @ViewBuilder
    private func listOfHeroes() -> some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.filteredHeroes) { hero in
                    heroCard(hero: hero)
                        .padding(.horizontal, 16)
                        .transition(.opacity)
                }
            }
            .padding(.vertical, 8)
        }
        .animation(.default, value: viewModel.filteredHeroes)
    }
    
    @ViewBuilder
    private func heroCard(hero: HeroListModel) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 16) {
                AsyncImage(url: hero.imageUrl) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    case .failure:
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .frame(width: 100, height: 120)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    case .empty:
                        ProgressView()
                            .frame(width: 100, height: 120)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    @unknown default:
                        EmptyView()
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(hero.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    if !hero.fullName.isEmpty {
                        Text(hero.fullName)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text(hero.race)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                        
                        if let publisher = hero.publisher, !publisher.isEmpty {
                            Text(publisher)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8)
                        }
                        
                        Text(hero.alignment.capitalized)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(hero.alignment == "good" ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                            .cornerRadius(8)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        powerStatView(value: hero.intelligence, name: "INT")
                        powerStatView(value: hero.strength, name: "STR")
                        powerStatView(value: hero.speed, name: "SPD")
                    }
                }
                
                Spacer()
            }
            .padding(16)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.routeToDetail(by: hero.id)
        }
    }
    
    @ViewBuilder
    private func powerStatView(value: Int, name: String) -> some View {
        VStack(spacing: 2) {
            Text("\(value)")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.primary)
            
            Text(name)
                .font(.system(size: 10))
                .foregroundColor(.secondary)
        }
        .frame(minWidth: 32)
    }
}
