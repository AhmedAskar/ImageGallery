//
//  Created by Ahmed Askar on 9/25/18.
//  Copyright © 2018 Vodaphone. All rights reserved.
//

import UIKit
import AVFoundation
import SDWebImage
import AVFoundation

enum Style: String {
    case list = "List"
    case grid = "Grid"
    case staggered = "Staggered"
}

enum GallerySelection: String {
    case hot = "hot"
    case top = "top"
}

class ASGalleryViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var spinnerView: ASSpinnerView!
    @IBOutlet weak var viralSwitch: UISwitch!

    var gallerySelection: String?
    
    lazy var viewModel: ASImageGalleryViewModel = {
        return ASImageGalleryViewModel()
    }()
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Gallery"
        collectionChangeDisplay(style: .staggered)
        collectionView?.contentInset = UIEdgeInsets(top: 23,
                                                    left: 10,
                                                    bottom: 10,
                                                    right: 10)
        initGalleryViewModel()
    }
    
    private func initGalleryViewModel() {
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.spinnerView.alpha = 1.0
                    self?.collectionView.alpha = 0.0
                }else {
                    self?.spinnerView.alpha = 0.0
                    self?.collectionView.alpha = 1.0
                }
            }
        }
        
        viewModel.showAlertClosure = { [weak self] in
            self?.showAlert(self?.viewModel.alertMessage ?? "")
        }
        viewModel.reloadTableViewClosure = { [weak self] in
            self?.collectionView?.reloadData()
        }
        
        viewModel.initFetch(page: 1, gallerySection: GallerySelection.hot.rawValue, showViral: viralSwitch.isOn)
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: Constants.alertMessage, message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: Constants.ok, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        viewDidLayoutSubviews()
        collectionView?.collectionViewLayout.invalidateLayout()
    }
}

extension ASGalleryViewController {
    
    @IBAction func changeStyle(_ sender: Any) {
        
        let alertController = UIAlertController(title: Constants.changeStyleTitle, message: nil, preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: Style.list.rawValue, style: .default) { [weak self] (action:UIAlertAction) in
            self?.collectionChangeDisplay(style: .list)
        }
        
        let action2 = UIAlertAction(title: Style.grid.rawValue, style: .default) { [weak self] (action:UIAlertAction) in
            self?.collectionChangeDisplay(style: .grid)
        }
        
        let action3 = UIAlertAction(title: Style.staggered.rawValue, style: .default) { [weak self] (action:UIAlertAction) in
            self?.collectionChangeDisplay(style: .staggered)
        }
        
        let action4 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        alertController.addAction(action4)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func collectionChangeDisplay(style: Style) {
        
        switch style {
        case .list:
            collectionView.collectionViewLayout = ASListLayout()
            collectionView.reloadData()
            viewDidLayoutSubviews()
            collectionView?.collectionViewLayout.invalidateLayout()
        case .grid:
            
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: 165, height: 200)
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 10
            collectionView.collectionViewLayout = layout
            collectionView.reloadData()
            viewDidLayoutSubviews()
            collectionView?.collectionViewLayout.invalidateLayout()

        case .staggered:
            collectionView.collectionViewLayout = ASStaggeredLayout()
            if let layout = collectionView?.collectionViewLayout as? ASStaggeredLayout {
                layout.delegate = self
            }
            collectionView.reloadData()
            viewDidLayoutSubviews()
            collectionView?.collectionViewLayout.invalidateLayout()
        }
    }
    
    @IBAction func filterGallerySelection(_ sender: Any) {
        
        let segmented = sender as! UISegmentedControl
        switch segmented.selectedSegmentIndex {
        case 0:
            gallerySelection = GallerySelection.hot.rawValue
        case 1:
            gallerySelection = GallerySelection.top.rawValue
        default:
            gallerySelection = GallerySelection.hot.rawValue
        }
        viewModel.initFetch(page: 1, gallerySection: gallerySelection ?? "hot", showViral: viralSwitch.isOn)
    }
    
    @IBAction func showViralImages(_ sender: Any) {
        viewModel.initFetch(page: 1, gallerySection: gallerySelection ?? "hot", showViral: viralSwitch.isOn)
    }
}

extension ASGalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ASImageCellView.self), for: indexPath) as? ASImageCellView else {
            fatalError("Cell not exists in storyboard")
        }
        
        let image = viewModel.getImage(indexPath: indexPath)
        imageCell.commentLabel.text = image.title
        if let imgUrl = image.link {
            imageCell.imageView.sd_setImage(with: URL(string:imgUrl), completed: nil)
        }
        
        return imageCell
    }
}

extension ASGalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = viewModel.getImage(indexPath: indexPath)
        let vc = storyboard?.instantiateViewController(withIdentifier: "GalleryDetailsViewController") as! ASGalleryDetailsViewController
            let imageDetailsViewModel = ASImageDetailsViewModel(image: image)
            vc.viewModel = imageDetailsViewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - PINTEREST LAYOUT DELEGATE
extension ASGalleryViewController : StaggeredLayoutDelegate {
    
    // 1. Returns the photo height
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        
        let image = viewModel.getImage(indexPath: indexPath)
        if let height = image.height, let width = image.width {
            let ratio = max(CGFloat(Constants.defaultCellWidth) / width, CGFloat(Constants.defaultCellHeightRatio) / height)
            let x = height * ratio
            if x > CGFloat(Constants.defaultCellHeight) {
                return x * ratio
            }
            return x
        }else{
            return CGFloat(Constants.defaultCellHeight)
        }
    }
}
