//
//  TMDBService.swift
//  TestMV
//
//  Created by Valmir Torres on 03/12/22.
//

import Foundation

final class TMDBService: BaseService {
    static let shared = TMDBService()

    private let baseUrl: String
    private let apiKey = "01471a148b9cca6a938122fb4b3bdf45"
    private let apiVersion = "3"
    
    let baseImageUrl: String
    let imageW45 = "/t/p/w45"
    let imageW185 = "/t/p/w185"
    let imageW300 = "/t/p/w300"
    let imageW342 = "/t/p/w342"
    let imageW500 = "/t/p/w500"
    let imageW780 = "/t/p/w780"
    
    
    private override init() {
        // change base url depending on the environment
        baseUrl = "https://api.themoviedb.org"
        baseImageUrl = "https://image.tmdb.org"
    }

    // MARK: - Methods
    func request<T: Decodable>(
        path: String,
        method: MyHTTPMethod,
        queries: [URLQueryItem]? = nil,
        parameter: [String: Any]? = nil,
        of returnType: T.Type
    ) async throws -> T {
        let updatedPath = "/\(apiVersion)\(path)"
        var required = [URLQueryItem(name: "api_key", value: apiKey)]
        if let queries {
            required += queries
        }
        guard let url = createURL(
            baseURL: baseUrl,
            path: updatedPath,
            queries: required
        ) else { throw NetworkError.badURL }
        debugPrint(url.absoluteString)
        
        let dataTask = session.request(
            url,
            method: method.httpMethod,
            parameters: parameter
        ).validate().serializingDecodable(returnType)
        
        let response = await dataTask.response
        
        return try fetch(response)
    }
}
