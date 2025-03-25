import SwiftUI
import Combine

enum LoadingState {
    case idle
    case loading
    case loaded
    case error(String)
}

final class HeroListViewModel: ObservableObject {
    @Published private(set) var heroes: [HeroListModel] = []
    @Published private(set) var filteredHeroes: [HeroListModel] = []
    @Published private(set) var loadingState: LoadingState = .idle
    @Published var searchText: String = ""
    
    private let service: HeroService
    private let router: HeroRouter
    private var cancellables = Set<AnyCancellable>()

    init(service: HeroService, router: HeroRouter) {
        self.service = service
        self.router = router
        
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .map { [weak self] searchText in
                guard let self = self else { return }
                self.filterHeroes(searchText: searchText)
            }
            .sink { _ in }
            .store(in: &cancellables)
    }
    
    func fetchHeroes() async {
        await MainActor.run {
            loadingState = .loading
        }
        
        do {
            let heroesResponse = try await service.fetchHeroes()

            await MainActor.run {
                heroes = heroesResponse.map { hero in
                    HeroListModel(
                        id: hero.id,
                        name: hero.name,
                        fullName: hero.biography.fullName,
                        race: hero.appearance.race ?? "Unknown",
                        publisher: hero.biography.publisher,
                        alignment: hero.biography.alignment,
                        imageUrl: hero.heroImageUrl,
                        intelligence: hero.powerstats.intelligence,
                        strength: hero.powerstats.strength,
                        speed: hero.powerstats.speed
                    )
                }
                
                filteredHeroes = heroes
                loadingState = .loaded
            }
        } catch let error as HeroError {
            await MainActor.run {
                loadingState = .error(error.errorMessage)
            }
        } catch {
            await MainActor.run {
                loadingState = .error("Unknown error occurred")
            }
        }
    }
    
    private func filterHeroes(searchText: String) {
        if searchText.isEmpty {
            filteredHeroes = heroes
        } else {
            filteredHeroes = heroes.filter { hero in
                hero.name.localizedCaseInsensitiveContains(searchText) ||
                hero.fullName.localizedCaseInsensitiveContains(searchText) ||
                hero.publisher?.localizedCaseInsensitiveContains(searchText) == true
            }
        }
    }

    func routeToDetail(by id: Int) {
        router.showDetails(for: id)
    }
}
