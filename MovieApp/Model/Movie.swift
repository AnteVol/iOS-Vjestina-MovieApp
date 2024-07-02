import Foundation


struct Movie: Decodable {
    let id: Int
    let imageUrl: String?
    let name: String
    let summary: String
    let year: Int
    let categories: [String]?
    let crewMembers: [CrewMember]?
    let duration: Int
    let rating: Double
    let releaseDate: String
}
