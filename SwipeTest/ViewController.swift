//
//  ViewController.swift
//  SwipeTest
//
//  Created by Александр Цветков on 02.06.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: PROPERTIES
    private let firstCardView = CardView()
    private let secondCardView = CardView()
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
    private let cardImages = [
        UIImage(named: "pig")!,
        UIImage(named: "rabbit")!,
        UIImage(named: "giraffe")!
    ]
    private var nextImage: UIImage?
    private let leftButton = UIButton(title: "Left")
    private let rightButton = UIButton(title: "Right")
    private var cardViewIdentity: CGAffineTransform = .identity
    
    //MARK: VIEW LIFECYClE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLogic()
    }
    
    //MARK: SETUP
    private func setupLogic() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(cardViewDragged))
        firstCardView.addGestureRecognizer(panGestureRecognizer)
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemTeal
        view.addSubview(secondCardView)
        view.addSubview(firstCardView)
        firstCardView.imageView.image = cardImages.randomElement()
        nextImage = cardImages.randomElement()
        secondCardView.imageView.image = nextImage
        firstCardView.addSubview(superlikeView)
        firstCardView.addSubview(noView)
        firstCardView.addSubview(yesView)
        view.addSubview(leftButton)
        view.addSubview(rightButton)
        
        firstCardView.translatesAutoresizingMaskIntoConstraints = false
        secondCardView.translatesAutoresizingMaskIntoConstraints = false
        superlikeView.translatesAutoresizingMaskIntoConstraints = false
        yesView.translatesAutoresizingMaskIntoConstraints = false
        noView.translatesAutoresizingMaskIntoConstraints = false
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        
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
            superlikeView.centerXAnchor.constraint(equalTo: firstCardView.centerXAnchor),
            
            leftButton.topAnchor.constraint(equalTo: firstCardView.bottomAnchor, constant: 50),
            leftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            leftButton.widthAnchor.constraint(equalToConstant: 150),
            leftButton.heightAnchor.constraint(equalToConstant: 40),
            
            rightButton.topAnchor.constraint(equalTo: firstCardView.bottomAnchor, constant: 50),
            rightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            rightButton.widthAnchor.constraint(equalToConstant: 150),
            rightButton.heightAnchor.constraint(equalToConstant: 40),
        ])
        secondCardView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        let transform = secondCardView.transform3D
        secondCardView.transform3D = CATransform3DTranslate(transform, 0, 0, -1000)
        cardViewIdentity = firstCardView.transform
    }
    
    //MARK: EVENTS HANDLING
    @objc private func leftButtonTapped() {
        cardMoving(to: .left)
    }
    
    @objc private func rightButtonTapped() {
        cardMoving(to: .right)
    }
    
    @objc private func cardViewDragged() {
        var absTranslationX: CGFloat = 0
        var directionKoef: CGFloat = 0
        let absTranslationY = abs(panGestureRecognizer.translation(in: firstCardView).y)
        
        if panGestureRecognizer.translation(in: firstCardView).x < 0 {
            directionKoef = -(dragFromTop ? 1.0 : -1.0)
            absTranslationX = -panGestureRecognizer.translation(in: firstCardView).x
        } else {
            directionKoef = dragFromTop ? 1.0 : -1.0
            absTranslationX = panGestureRecognizer.translation(in: firstCardView).x
        }
        let rotationPerPoint = 0.3 / view.frame.width * absTranslationX
        let transformationPerHPoint = 0.1 / (firstCardView.frame.width / 2)
        let transformationPerVPoint = 0.1 / (firstCardView.frame.height * 0.7)
        
        switch panGestureRecognizer.state {
        case .began:
            dragFromTop = panGestureRecognizer.location(in: firstCardView).y < firstCardView.frame.height / 2
        case .changed:
            firstCardView.transform = CGAffineTransform(
                rotationAngle: rotationPerPoint * CGFloat(directionKoef))
            firstCardView.center.x = panGestureRecognizer.translation(in: firstCardView).x + view.center.x
            firstCardView.center.y = panGestureRecognizer.translation(in: firstCardView).y + view.center.y
            changeAlpha(panGestureRecognizer.translation(in: firstCardView).x, panGestureRecognizer.translation(in: firstCardView).y)
            if absTranslationX > absTranslationY {
                secondCardView.transform = CGAffineTransform(
                    scaleX: 0.9 + absTranslationX * transformationPerHPoint,
                    y: 0.9 + absTranslationX * transformationPerHPoint)
            } else {
                secondCardView.transform = CGAffineTransform(
                    scaleX: 0.9 + absTranslationY * transformationPerVPoint,
                    y: 0.9 + absTranslationY * transformationPerVPoint)
            }
        case .ended:
            // If should move vertically from screen
            if panGestureRecognizer.translation(in: firstCardView).y < -firstCardView.frame.height * 0.35 {
                UIView.animate(withDuration: 0.4, animations: {
                    self.firstCardView.transform = CGAffineTransform(translationX: 0, y: -self.firstCardView.frame.height * 1.5)
                    self.secondCardView.transform = CGAffineTransform(scaleX: 1, y: 1)
                }) { _ in
                    self.yesView.alpha = 0
                    self.noView.alpha = 0
                    self.superlikeView.alpha = 0
                    self.firstCardView.center = self.view.center
                    self.firstCardView.transform = self.cardViewIdentity
                    self.firstCardView.imageView.image = self.nextImage
                    self.nextImage = self.cardImages.randomElement()
                    self.secondCardView.imageView.image = self.nextImage
                    self.secondCardView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    let transform = self.secondCardView.transform3D
                    self.secondCardView.transform3D = CATransform3DTranslate(transform, 0, 0, -1000)
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
                    self.firstCardView.transform = CGAffineTransform(rotationAngle: 0)
                    self.secondCardView.transform = CGAffineTransform(scaleX: 1, y: 1)
                }) { _ in
                    self.yesView.alpha = 0
                    self.noView.alpha = 0
                    self.superlikeView.alpha = 0
                    self.firstCardView.imageView.image = UIImage(named: "rabbit")
                    self.firstCardView.center = self.view.center
                    self.firstCardView.transform = self.cardViewIdentity
                    self.firstCardView.imageView.image = self.nextImage
                    self.nextImage = self.cardImages.randomElement()
                    self.secondCardView.imageView.image = self.nextImage
                    self.secondCardView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    let transform = self.secondCardView.transform3D
                    self.secondCardView.transform3D = CATransform3DTranslate(transform, 0, 0, -1000)
                } //------
                // Otherwise return to center
            } else {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, animations: {
                    self.secondCardView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    let transform = self.secondCardView.transform3D
                    self.secondCardView.transform3D = CATransform3DTranslate(transform, 0, 0, -1000)
                    self.firstCardView.center = self.view.center
                    self.firstCardView.transform = self.cardViewIdentity
                    self.superlikeView.alpha = 0
                    self.yesView.alpha = 0
                    self.noView.alpha = 0
                })
        } //------
        default:
            break
        } // End switch
    }// CardViewDragged
    
    //MARK: FUNCTIONS
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
    
    private func cardMoving(to direction: Direction) {
        var angle: CGFloat = 0.0
        UIView.animate(withDuration: 0.4, animations: {
//            var perspective = CATransform3DIdentity
//            perspective.m34 = 1 / 1000
//            let transformLayer = CATransformLayer()
//            transformLayer.transform = perspective
//            transformLayer.addSublayer(self.firstCardView.layer)
//            self.view.layer.addSublayer(transformLayer)
            switch direction {
            case .left:
                angle = 0.6
            case .right:
                angle = -0.6
            }
            self.firstCardView.transform3D = CATransform3DMakeRotation(angle, 0, 1, 0)
        }) { _ in
            UIView.animate(withDuration: 0.4, animations: {
                self.firstCardView.transform3D = CATransform3DMakeRotation(0, 0, 1, 0)
            })
        }
    }
    //MARK: DIRECTION ENUM
    enum Direction {
        case left
        case right
    }
    
}// View controller

