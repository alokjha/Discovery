//
//  CardCellNode.swift
//  Discovery
//
//  Created by Alok Jha on 25/02/18.
//  Copyright © 2018 Alok Jha. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import RxSwift

fileprivate let kOuterPadding : CGFloat = 5.0
fileprivate let kInnerPadding : CGFloat = 10.0

enum CardType : String {
    
    case featured
    case latest
    case openHouse
    case under
    case houseRent
    case roomRent
    
}

class HorizontalCollectionNode : ASCellNode {
    
    fileprivate let client = APIClient()
    fileprivate let disposeBag = DisposeBag()
    let collectionNode : ASCollectionNode
    let divider : ASDisplayNode
    let elementSize : CGSize
    let cardType : CardType
    
    var cards : [Card] = []
    
    init(elementSize : CGSize, cardType : CardType ) {
        
        self.elementSize = elementSize
        self.cardType = cardType
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = elementSize
        flowLayout.minimumInteritemSpacing = kInnerPadding
        
        collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        collectionNode.contentInset = UIEdgeInsetsMake(5, 5, 5, 5 )
        divider = ASDisplayNode()
        divider.backgroundColor = UIColor.lightGray
        
        super.init()
        
        self.addSubnode(collectionNode)
        self.addSubnode(divider)
        
        collectionNode.dataSource = self
        collectionNode.delegate = self
        
        fetchCards()
    }
    
    override func layout() {
        super.layout()
        
        collectionNode.contentInset = UIEdgeInsetsMake(0, kOuterPadding, 0, kOuterPadding)
        
        let pixelHeight = 1.0/UIScreen.main.scale
        
        divider.frame = CGRect(x: 0, y: 0, width: self.calculatedSize.width, height: pixelHeight)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let collectionNodeSize = CGSize(width: constrainedSize.max.width, height: elementSize.height)
        collectionNode.style.preferredSize = collectionNodeSize
        
        let insetSpec = ASInsetLayoutSpec()
        insetSpec.insets = UIEdgeInsetsMake(0, kOuterPadding, 0, kOuterPadding)
        insetSpec.child = collectionNode
        
        return insetSpec
    }
    
    func fetchCards() {
        
        let cardReuest = CardRequest(name: cardType.rawValue)
        
        client.send(apiRequest: cardReuest)
            .debug("my request")
            .observeOn(MainScheduler.instance)
            .map { (response : CardListResponse)  in
                response.data.cards
            }
            .subscribe(onNext: { (cards : [Card]) in
                print("cards : \n \(cards)")
                self.cards.append(contentsOf: cards)
                self.collectionNode.reloadData()
            }, onError: { (error) in
                print("error : \(error)")
            }).disposed(by: disposeBag)
        
    }
}

extension HorizontalCollectionNode : ASCollectionDataSource,ASCollectionDelegate {
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        
        let card = cards[indexPath.item]
        
        return {
            let node = CardCellNode(card: card)
            return node
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> ASCellNodeBlock {
        
        return {
            let node = ASCellNode()
            node.style.preferredSize = CGSize(width: 20, height: 20)
            node.backgroundColor = UIColor.green
            return node
        }
    }
}
