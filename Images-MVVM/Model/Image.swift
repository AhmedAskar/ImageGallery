//
//	Image.swift
//  Images-MVVM
//
//	Create by Ahmed Askar on 1/10/2018
//	Copyright © 2018 Crossworkers. All rights reserved.

import Foundation
import UIKit

//MARK: - Image
struct Image: Codable {
    
    let id : String?
    let type: String?
    let description : String?
    let link : String?
    let title : String?
    let images : [Image]?
    let is_album: Bool?
    let width: CGFloat?
    let height: CGFloat?
}
