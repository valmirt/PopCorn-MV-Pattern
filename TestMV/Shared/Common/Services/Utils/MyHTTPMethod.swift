//
//  MyHTTPMethod.swift
//  TestMV
//
//  Created by Valmir Torres on 03/12/22.
//

import Foundation
import Alamofire

enum MyHTTPMethod {
    case get
    case post
    case put
    case delete
    case patch
    
    var httpMethod: HTTPMethod {
        switch self {
        case .get: return .get
        case .post: return .post
        case .put: return .put
        case .delete: return .delete
        case .patch: return .patch
        }
    }
}
