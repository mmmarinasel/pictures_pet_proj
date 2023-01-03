import Foundation

struct PicturesFiltered: Codable {
    var results: [PictureData]
}

struct PictureData: Codable {
    let id: String
    let date: String
    let description: String?
    let urls: PicUrls
    let likes: Int
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case id, urls, likes, user
        case date = "created_at"
        case description = "alt_description"
        
    }
}

struct PicUrls: Codable {
    let small: String
    let thumb: String
}

struct User: Codable {
    let name: String
    let location: String?
}
