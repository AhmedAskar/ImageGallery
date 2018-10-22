//
//  ASBaseRequest.swift
//  Images-MVVM
//
//  Created by Ahmed Askar on 10/11/18.
//  Copyright © 2018 Vodaphone. All rights reserved.
//

import Foundation

class ASBaseRequest: ASRequest {
    
    lazy var url: URL? = {
        guard let urlString = "\(environment.getBaseUrl())\(path.absolutePath)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        var urlComponents = URLComponents(string: urlString)
        if urlComponents?.queryItems == nil {
            urlComponents?.queryItems = []
        }
        queryParameters?.forEach { element in
            let queryItem = URLQueryItem(name: element.key, value: element.value)
            urlComponents?.queryItems?.append(queryItem)
        }
        return urlComponents?.url
    }()
    
    var environment: ASUrlEnvironment {
        return .environment
    }
    
    var path: ASAPIPath
    
    var parameters: [String : Any]?
    
    var queryParameters: [String : String]?
    
    var headers: [String : String]
    
    var httpMethod: RequestHTTPMethod
    
    var parametersEncoding: RequestParametersEncoding
    
    var responseType: RequestResponseType
    
    /**
     Initializing a new ASBaseRequest.
     */
    init(path: ASAPIPath,
         parameters: [String : Any]? = nil,
         queryParameters: [String : String]? = nil,
         headers: [String : String] = [:],
         httpMethod: RequestHTTPMethod = .get,
         parametersEncoding: RequestParametersEncoding = .json,
         responseType: RequestResponseType = .json) {
        
        self.path = path
        self.parameters = parameters
        self.queryParameters = queryParameters
        self.headers = [:]
        self.httpMethod = httpMethod
        self.parametersEncoding = parametersEncoding
        self.responseType = responseType
        self.headers = getGenericHeaders()
        self.headers.append(headers)
    }
    
    /**
     Define generic headers
     */
    func getGenericHeaders() -> [String: String]{
        var headers: [String: String] = [:]
        headers["Authorization"] = Constants.clientID
        return headers
    }
    
}
