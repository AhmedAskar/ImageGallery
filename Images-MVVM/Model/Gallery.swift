//
//	GalleryModel.swift
//
//	Create by Ahmed Askar on 1/10/2018
//	Copyright © 2018 Ahmed Askar. All rights reserved.

import Foundation

struct GalleryModel: Codable {
    
	let data : [Image]?
	let status : Int?
	let success : Bool?
    var images : [Image]? {
        get {
            return data.map { return $0 }
        }
    }

    //Return all images flat if needed
    var allImages: [Image]? {
        let images = self.data?.compactMap { return $0.images }
            .reduce([Image]()) { (result, list) in
            var result = result
            result.append(contentsOf: list)
            return result
        }
        return images
    }
}
