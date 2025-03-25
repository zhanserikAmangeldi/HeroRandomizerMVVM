import SwiftUI
import Combine

final class HeroDetailViewModel: ObservableObject {
    @Published private(set) var hero: HeroDetailModel?
    @Published private(set) var loadingState: LoadingState = .idle
    
    private let service: HeroService
    private let heroId: Int
    
    init(service: HeroService, heroId: Int) {
        self.service = service
        self.heroId = heroId
    }
    
    func fetchHeroDetails() async {
        await MainActor.run {
            loadingState = .loading
        }
        
        do {
            let heroResponse = try await service.fetchHeroById(id: heroId)
            
            await MainActor.run {
                hero = HeroDetailModel(
                    id: heroResponse.id,
                    name: heroResponse.name,
                    slug: heroResponse.slug,
                    fullName: heroResponse.biography.fullName,
                    alterEgos: heroResponse.biography.alterEgos,
                    aliases: heroResponse.biography.aliases,
                    placeOfBirth: heroResponse.biography.placeOfBirth,
                    firstAppearance: heroResponse.biography.firstAppearance,
                    publisher: heroResponse.biography.publisher,
                    alignment: heroResponse.biography.alignment,
                    intelligence: heroResponse.powerstats.intelligence,
                    strength: heroResponse.powerstats.strength,
                    speed: heroResponse.powerstats.speed,
                    durability: heroResponse.powerstats.durability,
                    power: heroResponse.powerstats.power,
                    combat: heroResponse.powerstats.combat,
                    gender: heroResponse.appearance.gender,
                    race: heroResponse.appearance.race ?? "Unknown",
                    height: heroResponse.appearance.height,
                    weight: heroResponse.appearance.weight,
                    eyeColor: heroResponse.appearance.eyeColor,
                    hairColor: heroResponse.appearance.hairColor,
                    occupation: heroResponse.work.occupation,
                    base: heroResponse.work.base,
                    groupAffiliation: heroResponse.connections.groupAffiliation,
                    relatives: heroResponse.connections.relatives,
                    imageUrl: heroResponse.heroImageUrl,
                    largeImageUrl: heroResponse.mediumImageUrl
                )
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
}
