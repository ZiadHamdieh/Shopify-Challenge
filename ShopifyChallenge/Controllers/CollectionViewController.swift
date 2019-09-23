//
//  ViewController.swift
//  ShopifyChallenge
//
//  Created by Ziad Hamdieh on 2019-09-22.
//  Copyright © 2019 Ziad Hamdieh. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    fileprivate let cellIdentifier = "cardCell"
    
    fileprivate var cards = [Card]()
    fileprivate var firstUncoveredCardIndexPath: IndexPath?
    
    fileprivate var matchesCounter = 0
    fileprivate var moveCounter = 0

    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        fetchProducts()
    }
    
    // MARK: Helper Methods
    
    /// Fetches the products from the Shopify API endpoint using the NetworkRequestManager object
    fileprivate func fetchProducts() {
        NetworkRequestManager().request(endpoint: .products, completion: { productTuples, response, error in
            if let error = error {
                print(error)
                return
            }
            
            if let response = response {
                print(response)
                return
            }
            
            guard let productTuples = productTuples else { return }
            
            productTuples.forEach { self.cards.append(Card(from: $0)) }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }
    
    /// Sets up the UI for the collectionView
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    /// Checks if the currently uncovered card's index path and _uncoveredCardIndexPath_ match, and either removes the cards f they match, or visual gives feedback to the user if they are different.
    /// - Parameter uncoveredCard: the indexPath of the card that the user has just clicked on
    fileprivate func checkForMatch(with uncoveredCardIndexPath: IndexPath) {
        moveCounter += 1
        
        guard let firstUncoveredCardIndexPath = firstUncoveredCardIndexPath else { return }
        let firstCardCell = collectionView.cellForItem(at: firstUncoveredCardIndexPath) as? CardCell
        let secondCardCell = collectionView.cellForItem(at: uncoveredCardIndexPath) as? CardCell
        
        let firstUncoveredCard = cards[firstUncoveredCardIndexPath.item]
        let secondUncoveredCard = cards[uncoveredCardIndexPath.item]
        
        if firstUncoveredCard.colour == secondUncoveredCard.colour {
            [firstCardCell, secondCardCell].forEach { $0?.disappear() }
            matchesCounter += 1
            checkWinCondition()
        } else {
            [firstCardCell, secondCardCell].forEach { $0?.cover() }
            [firstUncoveredCard, secondUncoveredCard].forEach { $0.isUncovered.toggle() }
        }
        
        // Full disclosure - I did not come up with this!
        if firstCardCell == nil {
            collectionView.reloadItems(at: [firstUncoveredCardIndexPath])
        }
        
        self.firstUncoveredCardIndexPath = nil
    }
    
    /// Checks if user has won the game
    fileprivate func checkWinCondition() {
        if matchesCounter < 10 {
            return
        } else {
            presentVictoryAlert()
        }
    }
    
    fileprivate func presentVictoryAlert() {
        let alert = UIAlertController(title: "Victory!", message: "Congratulations, you have won.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Shuffle & Replay", style: .default, handler: { action in
            self.cards.removeAll()
            self.fetchProducts()
        }))
        
        alert.addAction(UIAlertAction(title: "Quit", style: .destructive, handler: { _ in
            self.cards.removeAll()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
            UIView.animate(withDuration: 1.5) {
                self.collectionView.backgroundColor = .black
            }
        }))
        
        self.present(alert, animated: true)
    }
}

// MARK: Delegate/Datasource

extension CollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CardCell
        cell.setCard(cards[indexPath.item])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let card = cards[indexPath.item]
        let cardCell = collectionView.cellForItem(at: indexPath) as! CardCell
        
        if !card.isUncovered && !card.hasBeenMatched {
            cardCell.uncover()
            card.isUncovered.toggle()
            if firstUncoveredCardIndexPath == nil {
                firstUncoveredCardIndexPath = indexPath
            } else {
                checkForMatch(with: indexPath)
            }
        } else {
            cardCell.cover()
            card.isUncovered.toggle()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 60, height: 100)
    }
    
    // Min. spacing between each row
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    // Min. spacing between each col
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 15, left: 15, bottom: 15, right: 15)
    }
    
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
}
