//
//	Gallery.swift
//  Images-MVVM
//
//	Create by Ahmed Askar on 1/10/2018
//	Copyright © 2018 Ahmed Askar. All rights reserved.

import Foundation

struct Gallery: Codable {
    
	let data : [Image]?
	let status : Int?
	let success : Bool?
    
    // MARK: Computed properities
    
    //Return images without albums and videos
    var images: [Image]? {
        get{
            return data?.filter { return $0.is_album == false }
                .filter {  return $0.type != "video/mp4" }
        }
    }
    
    //Return all images flat if needed without albums
    var allImages: [Image]? {
        let images = self.data?
            .compactMap { return $0.images }
            .reduce([Image]()) { (result, list) in
            var result = result
            result.append(contentsOf: list)
            return result
        }.filter {  return $0.type != "video/mp4" }
        
        return images
    }
}
