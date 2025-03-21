import Foundation
import Combine

protocol NetworkService {
    func fetchAllHeroes() -> AnyPublisher<[Hero], Error>
    func fetchHeroById(id: Int) -> AnyPublisher<Hero, Error>
}

enum NetworkError: Error {
    switch self {
    case .invaildURL:
        return "Invalid URL request"
    case .responseError:
        return "Unexpected server response"
    case .decodingError:
        return "Error decoding JSON data"
    case .serverError(let code):
        return "Server error: \(code)"
    case .unknownError:
        return "An unknown error occurred"
    }
}
