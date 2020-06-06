//
//  ViewController.swift
//  SwipeTest
//
//  Created by Александр Цветков on 02.06.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var cardView = CardView()
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var dragToTop = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .cyan
        view.addSubview(cardView)
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(cardViewDragged))
        cardView.addGestureRecognizer(panGestureRecognizer)
        cardView.imageView.image = UIImage(named: "pig")
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
            cardView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9)
        ])
    }
    
    @objc private func cardViewDragged() {
        switch panGestureRecognizer.state {
        case .began:
            if panGestureRecognizer.location(in: cardView).y < cardView.frame.height / 2 {
                dragToTop = true
            } else {
                dragToTop = false
            }
        case .changed:
            let rotationPoint = 0.3 / view.frame.width * panGestureRecognizer.translation(in: cardView).x
            let rotationWithDirection = dragToTop ? rotationPoint : -rotationPoint
            print(rotationWithDirection)
            cardView.transform = CGAffineTransform(rotationAngle: rotationWithDirection)
            cardView.center.x = panGestureRecognizer.translation(in: cardView).x + view.center.x
            cardView.center.y = panGestureRecognizer.translation(in: cardView).y + view.center.y
        case .ended:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, animations: {
                self.cardView.center = self.view.center
                self.cardView.transform = .identity
            }) { _ in
                
            }
            
        default:
            break
        }
    }
}
