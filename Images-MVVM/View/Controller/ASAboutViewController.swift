//
//  AboutViewController.swift
//  Images-MVVM
//
//  Created by Ahmed Askar on 10/11/18.
//  Copyright © 2018 Ahmed Askar. All rights reserved.
//

import UIKit

class ASAboutViewController: UIViewController {

    @IBOutlet weak var versionNoLbl: UILabel!
    @IBOutlet weak var buildNoLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        versionNoLbl.text = Bundle.main.releaseVersionNumber
        buildNoLbl.text = Bundle.main.buildVersionNumber
    }
}
