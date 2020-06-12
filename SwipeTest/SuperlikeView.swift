//
//  SuperlikeView.swift
//  SwipeTest
//
//  Created by Александр Цветков on 07.06.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

class SuperlikeView: UIView {
    
    private let rect: UIView = {
        let view = UIView()
        view.layer.borderWidth = 8
        view.layer.cornerRadius = 12
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.blue.cgColor
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Superlike"
        label.font = .systemFont(ofSize: 40, weight: .medium)
        label.textColor = .blue
        return label
    }()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        addSubview(rect)
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        rect.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            rect.heightAnchor.constraint(equalToConstant: 100),
            rect.widthAnchor.constraint(equalToConstant: 200),
            rect.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            rect.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
