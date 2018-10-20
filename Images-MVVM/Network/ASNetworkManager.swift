//
//  ASNetworkManager.swift
//  Images-MVVM
//
//  Created by Ahmed Askar on 10/11/18.
//  Copyright © 2018 Vodaphone. All rights reserved.
//

import Foundation
import Alamofire

enum Result {
    case success(Any)
    case failure(Error)
}

protocol VFNetworkManagerProtocol {
    func getImagesGallery(page: Int, gallerySection: String, _ parameter: [String:String], completionHandlerForImages: @escaping(Result)->())
}

final class ASNetworkManager {
    
    func executeRequest(request: VFRequest, completionHandlerForExecuteRequest: @escaping(Result)->()) {
        
        //Detecting Request HTTP Method
        var httpMethod : HTTPMethod = .get
        switch request.httpMethod {
        case .get:
            httpMethod = .get
        case .post:
            httpMethod = .post
        case .delete:
            httpMethod = .delete
        case .put:
            httpMethod = .put
        }
        
        //Detecting Encoding Type
        var encoding : ParameterEncoding = JSONEncoding.default
        switch request.parametersEncoding {
        case .json:
            encoding = JSONEncoding.default
        case .url:
            encoding = URLEncoding.default
        }
        
        guard let url = request.url?.absoluteString else { return }
        
        let alamoFireRequest = Alamofire.request(url, method: httpMethod, parameters: request.parameters, encoding: encoding, headers: request.headers)
        
        alamoFireRequest
            .validate()
            .responseJSON { response in
                
                func sendError(_ error: String) {
                    print(error)
                    let userInfo = [NSLocalizedDescriptionKey : error]
                    completionHandlerForExecuteRequest(Result.failure(NSError(domain: "startRequst", code: 1, userInfo: userInfo)))
                }
                
                guard response.result.isSuccess else {
                    if let errorString = response.result.error?.localizedDescription {
                        sendError("Error while fetching request: \(errorString)")
                    }
                    return
                }
                
                completionHandlerForExecuteRequest(Result.success(response))
        }
    }
}

extension ASNetworkManager: VFNetworkManagerProtocol {
    
    func getImages(completionHandlerForDeviceAttributes: @escaping(Result)->()) {
        if let path = Bundle.main.path(forResource: "top", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let responseModel = try JSONDecoder().decode(Gallery.self, from: data)
                completionHandlerForDeviceAttributes(Result.success(responseModel))
            }catch{
                completionHandlerForDeviceAttributes(Result.failure(error))
            }
        }
    }
    
    func getImagesGallery(page: Int, gallerySection: String, _ parameter: [String:String], completionHandlerForImages: @escaping(Result)->()) {
        
        let request = VFBaseRequest(path: .imageGallery(page: page, gallerySection: gallerySection), queryParameters: parameter, httpMethod: .get, parametersEncoding: .json, responseType: .json)
        
        executeRequest(request: request) { (result) in
            switch result {
                
            case .success(let response):
                do{
                    let response = response as! DataResponse<Any>
                    if let data = response.data {
                        let responseModel = try! JSONDecoder().decode(Gallery.self, from: data)
                        completionHandlerForImages(Result.success(responseModel))
                    }
                }
            case .failure(let error):
                completionHandlerForImages(Result.failure(error))
            }
        }
    }
}
