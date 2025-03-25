import Foundation

struct HeroEntity: Decodable {
    let id: Int
    let name: String
    let slug: String
    let powerstats: PowerStats
    let appearance: Appearance
    let biography: Biography
    let work: Work
    let connections: Connections
    let images: HeroImage
    
    var heroImageUrl: URL? {
        URL(string: images.sm)
    }
    
    var mediumImageUrl: URL? {
        URL(string: images.md)
    }

    struct PowerStats: Decodable {
        let intelligence: Int
        let strength: Int
        let speed: Int
        let durability: Int
        let power: Int
        let combat: Int
    }
    
    struct Appearance: Decodable {
        let gender: String
        let race: String?
        let height: [String]
        let weight: [String]
        let eyeColor: String
        let hairColor: String
    }
    
    struct Biography: Decodable {
        let fullName: String
        let alterEgos: String
        let aliases: [String]
        let placeOfBirth: String
        let firstAppearance: String
        let publisher: String?
        let alignment: String
    }
    
    struct Work: Decodable {
        let occupation: String
        let base: String
    }
    
    struct Connections: Decodable {
        let groupAffiliation: String
        let relatives: String
    }

    struct HeroImage: Decodable {
        let xs: String
        let sm: String
        let md: String
        let lg: String
    }
}
