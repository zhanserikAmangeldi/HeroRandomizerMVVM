import Foundation

struct HeroDetailModel: Identifiable {
    let id: Int
    let name: String
    let slug: String
    
    let fullName: String
    let alterEgos: String
    let aliases: [String]
    let placeOfBirth: String
    let firstAppearance: String
    let publisher: String?
    let alignment: String
    
    let intelligence: Int
    let strength: Int
    let speed: Int
    let durability: Int
    let power: Int
    let combat: Int
    
    let gender: String
    let race: String
    let height: [String]
    let weight: [String]
    let eyeColor: String
    let hairColor: String
    
    let occupation: String
    let base: String
    
    let groupAffiliation: String
    let relatives: String
    
    let imageUrl: URL?
    let largeImageUrl: URL?
}
