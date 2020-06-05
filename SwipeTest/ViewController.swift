//
//  ViewController.swift
//  SwipeTest
//
//  Created by Александр Цветков on 02.06.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let cardView = CardView()
    private let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(cardViewDragged))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .cyan
        view.addSubview(cardView)
        cardView.addGestureRecognizer(panGestureRecognizer)
        cardView.imageView.image = UIImage(named: "pig")
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
            cardView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.75)
        ])
    }
    
    @objc private func cardViewDragged() {
        
    }
    
}

