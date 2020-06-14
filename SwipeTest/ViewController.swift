//
//  ViewController.swift
//  SwipeTest
//
//  Created by Александр Цветков on 02.06.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let firstCardView = CardView()
    private let secondCardView = CardView()
    private let superlikeView = SuperlikeView()
    private let shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 1
        return view
    }()
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
    private let cardImages = [
        UIImage(named: "pig")!,
        UIImage(named: "rabbit")!,
        UIImage(named: "giraffe")!
    ]
    private var nextImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLogic()
    }
    
    private func setupLogic() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(cardViewDragged))
        firstCardView.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemTeal
        view.insertSubview(shadowView, at: 0)
        view.insertSubview(secondCardView, at: 1)
        view.insertSubview(firstCardView, at: 2)
        firstCardView.imageView.image = cardImages.randomElement()
        nextImage = cardImages.randomElement()
        secondCardView.imageView.image = nextImage
        firstCardView.addSubview(superlikeView)
        firstCardView.addSubview(noView)
        firstCardView.addSubview(yesView)
        
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        firstCardView.translatesAutoresizingMaskIntoConstraints = false
        secondCardView.translatesAutoresizingMaskIntoConstraints = false
        superlikeView.translatesAutoresizingMaskIntoConstraints = false
        yesView.translatesAutoresizingMaskIntoConstraints = false
        noView.translatesAutoresizingMaskIntoConstraints = false
        
        superlikeView.alpha = 0
        yesView.transform = CGAffineTransform(rotationAngle: -0.6)
        noView.transform = CGAffineTransform(rotationAngle: 0.6)
        
        NSLayoutConstraint.activate([
            firstCardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            firstCardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstCardView.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
            firstCardView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9),
            
            secondCardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            secondCardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondCardView.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
            secondCardView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9),
            
            shadowView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            shadowView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shadowView.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
            shadowView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9),
            
            yesView.heightAnchor.constraint(equalToConstant: 80),
            yesView.widthAnchor.constraint(equalToConstant: 160),
            yesView.topAnchor.constraint(equalTo: firstCardView.topAnchor, constant: 60),
            yesView.leadingAnchor.constraint(equalTo: firstCardView.leadingAnchor, constant: 10),
            
            noView.heightAnchor.constraint(equalToConstant: 80),
            noView.widthAnchor.constraint(equalToConstant: 160),
            noView.topAnchor.constraint(equalTo: firstCardView.topAnchor, constant: 60),
            noView.trailingAnchor.constraint(equalTo: firstCardView.trailingAnchor, constant: -10),
            
            superlikeView.heightAnchor.constraint(equalToConstant: 80),
            superlikeView.widthAnchor.constraint(equalToConstant: 160),
            superlikeView.bottomAnchor.constraint(equalTo: firstCardView.bottomAnchor, constant: -100),
            superlikeView.centerXAnchor.constraint(equalTo: firstCardView.centerXAnchor)
        ])
    }
    
    @objc private func resetButtonTapped() {
        self.firstCardView.center = self.view.center
        self.firstCardView.transform = .identity
    }
    
    @objc private func cardViewDragged() {
        var absTranslationX: CGFloat = 0
        var directionKoef: CGFloat = 0
        
        if panGestureRecognizer.translation(in: firstCardView).x < 0 {
            directionKoef = -(dragFromTop ? 1.0 : -1.0)
            absTranslationX = -panGestureRecognizer.translation(in: firstCardView).x
        } else {
            directionKoef = dragFromTop ? 1.0 : -1.0
            absTranslationX = panGestureRecognizer.translation(in: firstCardView).x
        }
        let rotationPerPoint = 0.3 / view.frame.width * absTranslationX
        
        switch panGestureRecognizer.state {
        case .began:
            dragFromTop = panGestureRecognizer.location(in: firstCardView).y < firstCardView.frame.height / 2
        case .changed:
            firstCardView.transform = CGAffineTransform(
                rotationAngle: rotationPerPoint * CGFloat(directionKoef))
            firstCardView.center.x = panGestureRecognizer.translation(in: firstCardView).x + view.center.x
            firstCardView.center.y = panGestureRecognizer.translation(in: firstCardView).y + view.center.y
            changeAlpha(panGestureRecognizer.translation(in: firstCardView).x, panGestureRecognizer.translation(in: firstCardView).y)
        case .ended:
            // If should move vertically from screen
            if panGestureRecognizer.translation(in: firstCardView).y < -firstCardView.frame.height * 0.35 {
                UIView.animate(withDuration: 0.4, animations: {
                    self.firstCardView.transform = CGAffineTransform(translationX: 0, y: -self.firstCardView.frame.height * 1.5)
                }) { _ in
                    self.yesView.alpha = 0
                    self.noView.alpha = 0
                    self.superlikeView.alpha = 0
                    self.firstCardView.center = self.view.center
                    self.firstCardView.transform = .identity
                    self.firstCardView.imageView.image = self.nextImage
                    self.nextImage = self.cardImages.randomElement()
                    self.secondCardView.imageView.image = self.nextImage
                }
                break
            } //-------
            // If should move horizontally from screen
            if absTranslationX > firstCardView.frame.width / 2 {
                UIView.animate(withDuration: 0.4, animations:  {
                    if self.panGestureRecognizer.translation(in: self.firstCardView).x < 0 {
                        self.firstCardView.center.x = -self.view.frame.width
                    } else {
                        self.firstCardView.center.x = self.view.frame.width * 2
                    }
                    self.firstCardView.transform = CGAffineTransform(rotationAngle: 0.3 * directionKoef)
                }) { _ in
                    self.yesView.alpha = 0
                    self.noView.alpha = 0
                    self.superlikeView.alpha = 0
                    self.firstCardView.imageView.image = UIImage(named: "rabbit")
                    self.firstCardView.center = self.view.center
                    self.firstCardView.transform = .identity
                    self.firstCardView.imageView.image = self.nextImage
                    self.nextImage = self.cardImages.randomElement()
                    self.secondCardView.imageView.image = self.nextImage
                } //------
                // Otherwise return to center
            } else {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, animations: {
                    self.firstCardView.center = self.view.center
                    self.firstCardView.transform = .identity
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
        let verticalAlphaPerPoint = 1 / (firstCardView.frame.height / 2)
        let horizontalAlphaPerPoint = 1 / (firstCardView.frame.width / 2)
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

