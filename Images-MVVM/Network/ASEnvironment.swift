//
//  ASEnvironment.swift
//  Images-MVVM
//
//  Created by Ahmed Askar on 10/11/18.
//  Copyright © 2018 Vodaphone. All rights reserved.
//

import Foundation

/**
 Request supported http method.
 
 - get: Get Method.
 - post: Post Method.
 - delete: Delete Method.
 - put: Put Method.
 */
enum RequestHTTPMethod: Int {
    case get
    case post
    case delete
    case put
}

/**
 Url for different environment
 Note: simulate that you will have more than environment
 
 - production: Production Environment
 */
enum ASUrlEnvironment : String {
    case production

    static var environment: ASUrlEnvironment = {
        return .production
    }()
    
    func getBaseUrl() -> String {
        switch self {
        case .production:
            return "https://api.imgur.com"
        }
    }
}
