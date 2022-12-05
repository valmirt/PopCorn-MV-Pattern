//
//  NetworkError.swift
//  TestMV
//
//  Created by Valmir Torres on 03/12/22.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case unauthorized
    case conflict
    case invalidData
    case defaultError
    case serverError
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badURL:
            return "Error! URL invalid..."
        case .invalidData:
            return "Failed to decode data, the communication is wrong..."
        case .defaultError:
            return "Something is wrong, please try again later..."
        case .unauthorized:
            return "Error! Unauthorized communication with the server..."
        case .conflict:
            return "Conflict with the server..."
        case .serverError:
            return "The server is offline, something is wrong. Please try again later..."
        }
    }
}
