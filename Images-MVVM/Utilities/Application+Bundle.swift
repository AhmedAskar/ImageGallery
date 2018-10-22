//
//  Application+Bundle.swift
//  Images-MVVM
//
//  Created by Ahmed Askar on 10/18/18.
//  Copyright © 2018 Ahmed Askar. All rights reserved.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
