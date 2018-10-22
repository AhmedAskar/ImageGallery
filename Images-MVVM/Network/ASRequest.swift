//
//  ASRequest.swift
//  Images-MVVM
//
//  Created by Ahmed Askar on 10/11/18.
//  Copyright © 2018 Vodaphone. All rights reserved.
//

import Foundation

/**
 Request parameters encoding.
 
 - json: Encoding using JSON.
 - url: Encoding by URL.
 */
enum RequestParametersEncoding: Int {
    case json
    case url
}

/**
 Response type of the request.
 
 - json: Response is JSON.
 - data: Response is Raw Data.
 */
enum RequestResponseType: Int {
    case json
    case data
    case string
}

/**
 Request is the parent protocol for any request, provides the basic objects for any request such as url, headers, httpMethod ...etc
 */
protocol ASRequest {
    
    // The request url
    var url: URL? {set get}
    
    // The environment
    var environment: ASUrlEnvironment {get}

    // The API path
    var path: ASAPIPath {get}
    
    // The request parameters
    var parameters: [String : Any]? {set get}
    
    // The query parameters
    var queryParameters: [String : String]? {set get}
    
    // The request headers
    var headers: [String : String] {set get}
    
    // The request httpMethod
    var httpMethod: RequestHTTPMethod {set get}
    
    // The request parameters encoding
    var parametersEncoding: RequestParametersEncoding {set get}
    
    // The response type
    var responseType: RequestResponseType {set get}
}

extension Dictionary {
    mutating func append(_ other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}










