//
//  GalleryDetailsViewController.swift
//  Images-MVVM
//
//  Created by Ahmed Askar on 10/18/18.
//  Copyright © 2018 Ahmed Askar. All rights reserved.
//

import UIKit
import SDWebImage

class ASGalleryDetailsViewController: UIViewController {

    @IBOutlet weak var imageDescription: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: Properities
    var viewModel: ASImageDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.clipsToBounds = true
        viewModel?.imageLoadCompletion = { [weak self] in
            DispatchQueue.main.async {
                self?.imageDescription.text = self?.viewModel?.image?.description
                if let imgUrl = self?.viewModel?.image?.link {
                    self?.imageView.sd_setImage(with: URL(string:imgUrl), completed: nil)
                }
            }
        }
        
        viewModel?.loadImage()
    }
}
