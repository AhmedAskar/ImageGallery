//
//  VFImageDetailsViewModel.swift
//  Images-MVVM
//
//  Created by Ahmed Askar on 10/18/18.
//  Copyright © 2018 Ahmed Askar. All rights reserved.
//

import Foundation

class ASImageDetailsViewModel {
    
    var image: Image? {
        didSet {
            imageLoadCompletion?()
        }
    }
    
    private let imageParameter: Image
    
    init(image: Image) {
        self.imageParameter = image
    }
    
    var imageLoadCompletion: (()->())?
    
    func loadImage() {
        self.image = self.imageParameter
    }
}
