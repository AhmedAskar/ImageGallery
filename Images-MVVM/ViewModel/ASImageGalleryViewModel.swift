//
//  ASImageGalleryViewModel.swift
//  Images-MVVM
//
//  Created by Ahmed Askar on 10/9/18.
//  Copyright © 2018 Ahmed Askar. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class ASImageGalleryViewModel {
    
    // MARK: Properities
    
    private var networkService: VFNetworkManagerProtocol
    
    var selectedImage: Image?
    
    var loadingMessage: String? {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var images: [Image] = [Image]() {
        didSet{
            self.reloadTableViewClosure?()
        }
    }
    
    // MARK: Callbacks
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    // MARK: Initializer
    
    init(networkService: VFNetworkManagerProtocol = ASNetworkManager()) {
        self.networkService = networkService
    }
    
    func initFetch(page: Int, gallerySection: String, showViral: Bool) {
        
        self.isLoading = true
        let dict = ["showViral":String(showViral),"mature":"false","album_previews":"true"]
        networkService.getImagesGallery(page: page, gallerySection: gallerySection, dict) { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.isLoading = false
                let response = response as! Gallery
                if let images = response.images {
                    self?.images = images
                }
            case .failure(let error):
                self?.isLoading = false
                self?.alertMessage = error.localizedDescription
            }
        }
    }
    
    func getImage(indexPath: IndexPath) -> Image {
        return self.images[indexPath.row]
    }
}

extension ASImageGalleryViewModel {
    func userPressed(indexPath: IndexPath) {
        let image = self.images[indexPath.row]
        self.selectedImage = image
    }
}
