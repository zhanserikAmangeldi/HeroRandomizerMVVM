import Foundation
import Combine

class APIService: NetworkService {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchAllHeroes() -> AnyPublisher<[Hero], any Error> {
        guard let url = APIEndpoint.allHeroes.url else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        return fetchData(from: url)
            .decode(type: [Hero].self, decoder: JSONDecoder())
            .mapError { error in
                if let decodingError = error as? DecodingError {
                    return NetworkError.decodingError(decodingError)
                }
                
                return error
            }
            .eraseToAnyPublisher()
        }
    }
    
    func fetchHeroById(id: Int) {
        guard let url = APIEndpoint.heroById(id: id).url else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        return fetchData(from: url)
            .decode(type: Hero.self, decoder: JSONDecoder())
            .mapError { error in
                if let decodingError = error as? DecodingError {
                    return NetworkError.decodingError(decodingError)
                }
                
                return error
            }
            .eraseToAnyPublisher()
    }

    private func fetchData(from url: URL) -> AnyPublisher<Data, Error> {
        return session.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.responseError
                }
                
                if (200...299).contains(httpResponse.statusCode) {
                    return data
                } else {
                    throw NetworkError.serverError(httpResponse.statusCode)
                }
            }
            .eraseToAnyPublisher()
    }
}
