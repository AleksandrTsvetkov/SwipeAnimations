//
//  UIButton + Extension.swift
//  SwipeTest
//
//  Created by Александр Цветков on 16.06.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

extension UIButton {
    
    convenience init(title: String) {
        self.init()
        backgroundColor = .gray
        layer.cornerRadius = 10
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowRadius = 10
        layer.shadowOpacity = 1
        frame = CGRect(x: 0, y: 0, width: 150, height: 80)
        setTitle(title, for: .normal)
    }
}
