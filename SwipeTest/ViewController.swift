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
    private let superlikeView = SuperlikeView()
    private let yesView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "yes"))
        view.alpha = 0
        view.frame = CGRect(x: 0, y: 0, width: 160, height: 80)
        return view
    }()
    private let noView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "no"))
        view.alpha = 0
        view.frame = CGRect(x: 0, y: 0, width: 160, height: 80)
        return view
    }()
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
        cardView.addSubview(superlikeView)
        cardView.addSubview(noView)
        cardView.addSubview(yesView)
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        superlikeView.translatesAutoresizingMaskIntoConstraints = false
        yesView.translatesAutoresizingMaskIntoConstraints = false
        noView.translatesAutoresizingMaskIntoConstraints = false
        
        superlikeView.alpha = 0
        yesView.transform = CGAffineTransform(rotationAngle: -0.6)
        noView.transform = CGAffineTransform(rotationAngle: 0.6)
        
        NSLayoutConstraint.activate([
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
            cardView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9),
            
            resetButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.widthAnchor.constraint(equalToConstant: 200),
            resetButton.heightAnchor.constraint(equalToConstant: 40),
            
            yesView.heightAnchor.constraint(equalToConstant: 80),
            yesView.widthAnchor.constraint(equalToConstant: 160),
            yesView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 60),
            yesView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            
            noView.heightAnchor.constraint(equalToConstant: 80),
            noView.widthAnchor.constraint(equalToConstant: 160),
            noView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 60),
            noView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            
            superlikeView.heightAnchor.constraint(equalToConstant: 80),
            superlikeView.widthAnchor.constraint(equalToConstant: 160),
            superlikeView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -100),
            superlikeView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor)
        ])
    }
    
    @objc private func resetButtonTapped() {
        self.cardView.center = self.view.center
        self.cardView.transform = .identity
    }
    
    @objc private func cardViewDragged() {
        var absTranslationX: CGFloat = 0
        var directionKoef: CGFloat = 0
        
        if panGestureRecognizer.translation(in: cardView).x < 0 {
            directionKoef = -(dragFromTop ? 1.0 : -1.0)
            absTranslationX = -panGestureRecognizer.translation(in: cardView).x
        } else {
            directionKoef = dragFromTop ? 1.0 : -1.0
            absTranslationX = panGestureRecognizer.translation(in: cardView).x
        }
        let rotationPerPoint = 0.3 / view.frame.width * absTranslationX
        
        switch panGestureRecognizer.state {
        case .began:
            dragFromTop = panGestureRecognizer.location(in: cardView).y < cardView.frame.height / 2
        case .changed:
            cardView.transform = CGAffineTransform(
                rotationAngle: rotationPerPoint * CGFloat(directionKoef))
            cardView.center.x = panGestureRecognizer.translation(in: cardView).x + view.center.x
            cardView.center.y = panGestureRecognizer.translation(in: cardView).y + view.center.y
            changeAlpha(panGestureRecognizer.translation(in: cardView).x, panGestureRecognizer.translation(in: cardView).y)
        case .ended:
            // If should move vertically from screen
            if panGestureRecognizer.translation(in: cardView).y < -cardView.frame.height * 0.35 {
                UIView.animate(withDuration: 0.4) {
                    self.cardView.transform = CGAffineTransform(translationX: 0, y: -self.cardView.frame.height * 1.5)
                }
                break
            } //-------
            // If should move vertically
            if absTranslationX > cardView.frame.width / 2 {
                UIView.animate(withDuration: 0.4) {
                    if self.panGestureRecognizer.translation(in: self.cardView).x < 0 {
                        self.cardView.center.x = -self.view.frame.width
                    } else {
                        self.cardView.center.x = self.view.frame.width
                    }
                    self.cardView.transform = CGAffineTransform(rotationAngle: 0.3 * directionKoef)
                } //------
                // Otherwise return to center
            } else {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, animations: {
                    self.cardView.center = self.view.center
                    self.cardView.transform = .identity
                    self.superlikeView.alpha = 0
                    self.yesView.alpha = 0
                    self.noView.alpha = 0
                })
        } //------
        default:
            break
        } // End switch
    }// CardViewDragged
    
    private func changeAlpha(_ translationX: CGFloat, _ translationY: CGFloat) {
        let verticalAlphaPerPoint = 1 / (cardView.frame.height / 2)
        let horizontalAlphaPerPoint = 1 / (cardView.frame.width / 2)
        if translationX > 0 {
            yesView.alpha = horizontalAlphaPerPoint * translationX
        }
        if translationX <= 0 {
            noView.alpha = horizontalAlphaPerPoint * -translationX
        }
        if translationY < 0 {
            superlikeView.alpha = verticalAlphaPerPoint * -translationY
        }
    }
    
}// View controller

