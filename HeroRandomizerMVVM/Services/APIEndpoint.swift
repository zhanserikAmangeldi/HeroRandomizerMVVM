import Foundation

enum APIEndpoint {
    case allHeroes
    case heroById(id: Int)
    
    private var BaseURL: String {
        return "https://akabab.github.io/superhero-api/api"
    }
    
    var url: URL? {
        switch self {
        case .allHeroes:
            return URL(string: "\(BaseURL)/all.json")
        case .heroById(let id):
            return URL(string: "\(BaseURL)/id/\(id).json")
        }
    }
}
