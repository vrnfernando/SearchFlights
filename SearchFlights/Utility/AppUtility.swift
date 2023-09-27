//
//  AppUtility.swift
//  SearchFlights
//
//  Created by Vishwa Fernando on 2023-08-20.
//

import Foundation
import UIKit

struct AppUtility {
    
    // Lock Orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
}
