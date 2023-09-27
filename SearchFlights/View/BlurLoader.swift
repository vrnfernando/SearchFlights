//
//  BlurLoader.swift
//  SearchFlights
//
//  Created by Vishwa Fernando on 2023-08-20.
//

import Foundation
import UIKit

class BlurLoader: UIView {

    var blurEffectView: UIVisualEffectView?

    override init(frame: CGRect) {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView()
        
        blurEffectView.frame = frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.006528253425)
        self.blurEffectView = blurEffectView
        
        super.init(frame: frame)
        addSubview(blurEffectView)
        addLoader()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addLoader() {
        guard let blurEffectView = blurEffectView else { return }
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        blurEffectView.contentView.addSubview(activityIndicator)
        activityIndicator.center = blurEffectView.contentView.center
        activityIndicator.startAnimating()
    }
}
