//
//  WindowWithStatusBar.swift
//  Catstagram-Starter
//
//  Created by Luke Parham on 2/9/17.
//  Copyright © 2017 Luke Parham. All rights reserved.
//

import UIKit

class WindowWithStatusBar: UIWindow {
    let statusBarUnderlayView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        statusBarUnderlayView.backgroundColor = UIColor.clear
        addSubview(statusBarUnderlayView)
    }
    
    override func layoutSubviews() {
        bringSubview(toFront: statusBarUnderlayView)
        statusBarUnderlayView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height:  UIApplication.shared.statusBarFrame.size.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
