//
//  CardCell.swift
//  ShopifyChallenge
//
//  Created by Ziad Hamdieh on 2019-09-22.
//  Copyright © 2019 Ziad Hamdieh. All rights reserved.
//

import UIKit
import SDWebImage

class CardCell: UICollectionViewCell {
    
    // MARK: Properties
    
    fileprivate let cardBack: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "cardBack3")
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    fileprivate let cardFront: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    fileprivate var card: Card?
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCardUI()
    }
    
    // MARK: Helper Methods
    
    fileprivate func setupCardUI() {
        backgroundView = UIView()
        addSubview(backgroundView!)
        backgroundView?.fillSuperview()
        backgroundView?.backgroundColor = .white
        backgroundView?.layer.cornerRadius = 10

        backgroundView?.layer.shadowOpacity = 0.25
        backgroundView?.layer.shadowRadius = 10
        backgroundView?.layer.shadowOffset = .init(width: 0, height: 10)
        // performance improvement for older devices
        backgroundView?.layer.shouldRasterize = true

        addSubview(cardBack)
        cardBack.centerInSuperview(size: .init(width: frame.size.width * 0.75, height: frame.size.height * 0.75))
        
        addSubview(cardFront)
        cardFront.centerInSuperview(size: .init(width: frame.size.width * 0.75, height: frame.size.height * 0.75))
        cardFront.isHidden = true
    }
    
    func setCard(_ card: Card) {
        self.card = card
        
        if card.hasBeenMatched {
            cardBack.alpha = 0.0
            cardFront.alpha = 0.0
        } else {
            cardBack.alpha = 1.0
            cardFront.alpha = 1.0
        }
        
        cardFront.sd_setImage(with: URL(string: card.imageURLString))
        
        // Keep state of cells that have been dequeued in the collection view
        if card.isUncovered {
            UIView.transition(from: cardBack, to: cardFront, duration: 0, options: [.transitionFlipFromRight, .showHideTransitionViews])
        } else {
            UIView.transition(from: cardFront, to: cardBack, duration: 0, options: [.transitionFlipFromRight, .showHideTransitionViews])
        }
    }
    
    @objc func uncover() {
        isUserInteractionEnabled = false

        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        UIView.transition(from: cardBack, to: cardFront, duration: 0.1, options: transitionOptions)
    }
    
    @objc func cover() {
        isUserInteractionEnabled = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.shake()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
            UIView.transition(from: self.cardFront, to: self.cardBack, duration: 0.1, options: transitionOptions)
        }
    }
    
    func disappear() {
        let iv = UIImageView(image: #imageLiteral(resourceName: "checkmark"))
        addSubview(iv)
        iv.centerInSuperview(size: .init(width: frame.width / 2, height: frame.height / 2))
        
        UIView.animate(withDuration: 5.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
            self.cardBack.alpha = 0.0
            self.cardFront.alpha = 0.0
        })
    }
    
    fileprivate func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 10, y: center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + 10, y: center.y))
        
        layer.add(animation, forKey: "position")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
