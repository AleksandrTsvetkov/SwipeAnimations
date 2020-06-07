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
    private var dragFromTop = false
    private let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.backgroundColor = .white
        button.setTitle("Reset", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 10, height: 10)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 1
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLogic()
    }
    
    private func setupLogic() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(cardViewDragged))
        cardView.addGestureRecognizer(panGestureRecognizer)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.backgroundColor = .cyan
        view.addSubview(cardView)
        view.addSubview(resetButton)
        
        cardView.imageView.image = UIImage(named: "pig")
        cardView.translatesAutoresizingMaskIntoConstraints = false
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
            cardView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9),
            
            resetButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.widthAnchor.constraint(equalToConstant: 200),
            resetButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func resetButtonTapped() {
            self.cardView.center = self.view.center
            self.cardView.transform = .identity
    }
    
    @objc private func cardViewDragged() {
        var translationX: CGFloat = 0
        var directionKoef: CGFloat = 0
        if panGestureRecognizer.translation(in: cardView).x < 0 {
            directionKoef = -(dragFromTop ? 1.0 : -1.0)
            translationX = -panGestureRecognizer.translation(in: cardView).x
        } else {
            directionKoef = dragFromTop ? 1.0 : -1.0
            translationX = panGestureRecognizer.translation(in: cardView).x
        }
        let rotationPoint = 0.3 / view.frame.width * translationX
        switch panGestureRecognizer.state {
        case .began:
            dragFromTop = panGestureRecognizer.location(in: cardView).y < cardView.frame.height / 2
        case .changed:
            cardView.transform = CGAffineTransform(
                rotationAngle: rotationPoint * CGFloat(directionKoef))
            cardView.center.x = panGestureRecognizer.translation(in: cardView).x + view.center.x
            cardView.center.y = panGestureRecognizer.translation(in: cardView).y + view.center.y
        case .ended:
            if panGestureRecognizer.translation(in: cardView).y < -cardView.frame.height * 0.35 {
                UIView.animate(withDuration: 0.4) {
                    self.cardView.transform = CGAffineTransform(translationX: 0, y: -self.cardView.frame.height * 1.5)
                }
                break
            }
            if translationX > cardView.frame.width / 2 {
                UIView.animate(withDuration: 0.4) {
                    if self.panGestureRecognizer.translation(in: self.cardView).x < 0 {
                        self.cardView.center.x = -self.view.frame.width
                    } else {
                        self.cardView.center.x = self.view.frame.width
                    }
                    self.cardView.transform = CGAffineTransform(rotationAngle: 0.3 * directionKoef)
                }
            } else {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, animations: {
                    self.cardView.center = self.view.center
                    self.cardView.transform = .identity
                })
            }
        default:
            break
        }
    }
}
