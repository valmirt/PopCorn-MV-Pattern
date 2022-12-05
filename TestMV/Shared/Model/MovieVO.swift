//
//  MovieVO.swift
//  TestMV
//
//  Created by Valmir Torres on 03/12/22.
//

import Foundation

struct MovieVO: Decodable {
    let id: Int
    let backdropPath: String?
    let popularity: Double
    let releaseDate: String
    let title: String
    let originalTitle: String
    let voteAverage: Double
    let posterPath: String?
}

extension MovieVO {
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id
        case popularity
        case releaseDate = "release_date"
        case title
        case originalTitle = "original_title"
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
    }
}
