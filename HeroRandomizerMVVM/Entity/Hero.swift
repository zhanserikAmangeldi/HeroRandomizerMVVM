import Foundation

struct Hero: Identifiable, Codable {
    let id: Int
    let name: String
    let slug: String
    let powerstats: PowerStats
    let appearance: Appearance
    let biography: Biography
    let work: Work
    let connections: Connections
    let images: Images
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug, powerstats, appearance, biography, work, connections, images
    }
}
