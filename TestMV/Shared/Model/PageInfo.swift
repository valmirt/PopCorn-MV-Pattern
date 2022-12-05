//
//  PageInfo.swift
//  TestMV
//
//  Created by Valmir Torres on 03/12/22.
//

import Foundation

struct PageInfo<T: Decodable>: Decodable {
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: [T]
}

// MARK: - Factory Methods
extension PageInfo {
    static func popularMovies(
        on page: Int
    ) async throws -> Self {
        let queries = [URLQueryItem(name: "page", value: "\(page)")]
        return try await TMDBService.shared.request(
            path: "/movie/popular",
            method: .get,
            queries: queries,
            of: Self.self
        )
    }

    static func topRatedMovies(
        on page: Int
    ) async throws -> Self {
        let queries = [URLQueryItem(name: "page", value: "\(page)")]
        return try await TMDBService.shared.request(
            path: "/movie/top_rated",
            method: .get,
            queries: queries,
            of: Self.self
        )
    }

    static func nowPlayingMovies(
        on page: Int
    ) async throws -> Self {
        let queries = [URLQueryItem(name: "page", value: "\(page)")]
        return try await TMDBService.shared.request(
            path: "/movie/now_playing",
            method: .get,
            queries: queries,
            of: Self.self
        )
    }

    static func upcomingMovies(
        on page: Int
    ) async throws -> Self {
        let queries = [URLQueryItem(name: "page", value: "\(page)")]
        return try await TMDBService.shared.request(
            path: "/movie/upcoming",
            method: .get,
            queries: queries,
            of: Self.self
        )
    }
}

extension PageInfo {
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}
