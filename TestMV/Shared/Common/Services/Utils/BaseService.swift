//
//  BaseService.swift
//  TestMV
//
//  Created by Valmir Torres on 03/12/22.
//

import Foundation
import Alamofire

class BaseService {
    private(set) lazy var session: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.allowsCellularAccess = true // Signal 3G/4G
        configuration.timeoutIntervalForRequest = 20
        configuration.httpMaximumConnectionsPerHost = 6
        
        return Session(configuration: configuration)
    }()
    
    func createURL(baseURL: String, path: String, queries: [URLQueryItem]? = nil) -> URL? {
        var component = URLComponents(string: baseURL)
        component?.path = path
        if let queries = queries {
            component?.queryItems = queries
        }
        return component?.url
    }

    func fetch<T: Decodable>(_ response: DataResponse<T, AFError>) throws -> T {
        let statusCode = response.response?.statusCode ?? 0
        if (response.error != nil) || (statusCode < 200 || statusCode > 299) {
            debugPrint(response.error?.localizedDescription ?? "")
            if statusCode == 401 {
                throw NetworkError.unauthorized
            }
            if statusCode == 409 {
                throw NetworkError.conflict
            }
            if statusCode >= 500 {
                throw NetworkError.serverError
            }
            throw NetworkError.defaultError
        }
        
        guard let data = response.data else {
            if let response = ResponseEmpty() as? T {
                return response
            }
            throw NetworkError.invalidData
        }
        
        if let jsonResponse = String(data: data, encoding: .utf8) {
            debugPrint("API RESPONSE - \(jsonResponse)")
        }
        
        guard let result = try? JSONDecoder().decode(T.self, from: data) else {
            if data.isEmpty {
                if let response = ResponseEmpty() as? T {
                    return response
                }
                throw NetworkError.invalidData
            }
            if let stringResult = String(data: data, encoding: .utf8),
               let safeData = stringResult as? T {
                return safeData
            }
            throw NetworkError.invalidData
        }
    
        return result
    }
}
