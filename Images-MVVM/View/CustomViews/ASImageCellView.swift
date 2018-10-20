//
//  AnnotatedPhotoCell.swift
//  Images-MVVM
//
//  Created by Ahmed Askar on 10/14/18.
//  Copyright © 2018 Ahmed Askar. All rights reserved.
//

import UIKit

class ASImageCellView: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
    }
}
