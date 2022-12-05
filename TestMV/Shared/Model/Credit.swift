//
//  Credit.swift
//  TestMV
//
//  Created by Valmir Torres on 05/12/22.
//

import Foundation

struct Credit: Decodable {
    let id: Int
    let cast: [CastOrCrew]
    let crew: [CastOrCrew]
    let guestStars: [CastOrCrew]?
}

extension Credit {
    static func movieCredit(by id: Int) async throws -> Self {
        return try await TMDBService
            .shared
            .request(path: "/movie/\(id)/credits", method: .get, of: Self.self)
    }
}

extension Credit {
    struct CastOrCrew: Decodable {
        let character: String?
        let job: String?
        let id: Int
        let name: String
        let profilePath: String?
        
        enum CodingKeys: String, CodingKey {
            case character
            case job
            case id
            case name
            case profilePath = "profile_path"
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case cast
        case crew
        case guestStars = "guest_starts"
    }
}
