//
//  ASAPIPath.swift
//  Images-MVVM
//
//  Created by Ahmed Askar on 10/11/18.
//  Copyright © 2018 Vodaphone. All rights reserved.
//

import Foundation

/**
 ASAPIPath names
 Contains APIs names
 */

enum ASAPIPath {
    case imageGallery(page: Int, gallerySection: String)
    
    var absolutePath: String {
        switch self {
        case .imageGallery(let page, let gallerySection):
            return "/3/gallery/\(gallerySection)/viral/day/\(page)"
        }
    }
}
