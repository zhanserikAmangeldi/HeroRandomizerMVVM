import Foundation

protocol HeroService {
    func fetchHeroes() async throws -> [HeroEntity]
    func fetchHeroById(id: Int) async throws -> HeroEntity
}

struct HeroServiceImpl: HeroService {
    func fetchHeroes() async throws -> [HeroEntity] {
        let urlString = Constants.baseUrl + "all.json"
        guard let url = URL(string: urlString) else {
            throw HeroError.wrongUrl
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw HeroError.invalidResponse
            }

            let heroes = try JSONDecoder().decode([HeroEntity].self, from: data)
            return heroes
        } catch let decodingError as DecodingError {
            print("Decoding error: \(decodingError)")
            throw HeroError.decodingError(decodingError.localizedDescription)
        } catch {
            print("Network error: \(error)")
            throw HeroError.networkError(error.localizedDescription)
        }
    }
    
    func fetchHeroById(id: Int) async throws -> HeroEntity {
        let urlString = Constants.baseUrl + "id/\(id).json"
        guard let url = URL(string: urlString) else {
            throw HeroError.wrongUrl
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw HeroError.invalidResponse
            }
            
            let hero = try JSONDecoder().decode(HeroEntity.self, from: data)
            return hero
        } catch let decodingError as DecodingError {
            print("Decoding error: \(decodingError)")
            throw HeroError.decodingError(decodingError.localizedDescription)
        } catch {
            print("Network error: \(error)")
            throw HeroError.networkError(error.localizedDescription)
        }
    }
}

enum HeroError: Error {
    case wrongUrl
    case invalidResponse
    case decodingError(String)
    case networkError(String)
    case somethingWentWrong
    
    var errorMessage: String {
        switch self {
        case .wrongUrl:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid server response"
        case .decodingError(let message):
            return "Failed to decode data: \(message)"
        case .networkError(let message):
            return "Network error: \(message)"
        case .somethingWentWrong:
            return "Something went wrong"
        }
    }
}

private enum Constants {
    static let baseUrl: String = "https://cdn.jsdelivr.net/gh/akabab/superhero-api@0.3.0/api/"
}
