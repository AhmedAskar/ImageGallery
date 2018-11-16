//
//  Constant.swift
//  Images-MVVM
//
//  Created by Ahmed Askar on 10/10/18.
//  Copyright © 2018 Ahmed Askar. All rights reserved.
//

import Foundation

struct Constants {
    
    //static let clientID = "Client-ID b6c1834db7de4f8" // Of course we should encrypt this client ID
    static let defaultCellWidth = 185.0
    static let defaultCellHeight = 300.0
    static let defaultCellHeightRatio = 400.0
    static let alertMessage = "Alert"
    static let ok = "Ok"
    static let changeStyleTitle = "Change Display"
}

enum ObfuscatedConstants {
    static let clientID: [UInt8] = [2, 28, 25, 33, 11, 24, 72, 46, 37, 84, 7, 120, 48, 126, 90, 89, 81, 7, 22, 118, 20, 21, 112, 3, 84]
}
