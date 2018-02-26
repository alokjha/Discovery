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

fileprivate let kOuterPadding : CGFloat = 10.0
fileprivate let kInnerPadding : CGFloat = 15.0

class HorizontalCollectionNode : ASCellNode {
    
    fileprivate let client = APIClient()
    fileprivate let disposeBag = DisposeBag()
    fileprivate let collectionNode : ASCollectionNode
    fileprivate let headerNode : HeaderNode
    fileprivate let elementSize : CGSize
    fileprivate let cardType : CardType
    fileprivate var cards : [Card] = []
    
    init(elementSize : CGSize, cardType : CardType ) {
        
        self.elementSize = elementSize
        self.cardType = cardType
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = elementSize
        flowLayout.minimumInteritemSpacing = kInnerPadding
        
        collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        
        headerNode = HeaderNode(forCardType: cardType)
        
        super.init()
        
        self.selectionStyle = .none
        
        addSubnode(headerNode)
        addSubnode(collectionNode)
        
        collectionNode.dataSource = self
        collectionNode.delegate = self
        
        fetchCards()
    }
    
    override func layout() {
        super.layout()
        
        collectionNode.view.showsHorizontalScrollIndicator = false
        collectionNode.contentInset = UIEdgeInsetsMake(0, kOuterPadding, 0, kOuterPadding)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let headerNodeSize = CGSize(width: constrainedSize.max.width, height: 50)
        headerNode.style.preferredSize = headerNodeSize
        
        let collectionNodeSize = CGSize(width: constrainedSize.max.width, height: elementSize.height - 50 - (2 * kOuterPadding))
        collectionNode.style.preferredSize = collectionNodeSize
        
        let insetSpec = ASInsetLayoutSpec()
        insetSpec.insets = UIEdgeInsetsMake(0, kOuterPadding, 0, kOuterPadding)
        insetSpec.child = collectionNode
        
        let spec = ASStackLayoutSpec()
        spec.direction = .vertical
        spec.children = [headerNode,insetSpec]
        
        return spec
    }
    
    func fetchCards() {
        
        let cardReuest = CardRequest(name: cardType.rawValue)
        
        client.send(apiRequest: cardReuest)
            .observeOn(MainScheduler.instance)
            .map { (response : CardListResponse)  in
                response.data.cards
            }
            .subscribe(onNext: { (cards : [Card]) in
                self.cards.append(contentsOf: cards)
                self.collectionNode.reloadData()
            }, onError: { (error) in
                print("error : \(error)")
            }).disposed(by: disposeBag)
        
    }
    
    
}

extension HorizontalCollectionNode : ASCollectionDataSource,ASCollectionDelegate {
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        
        if CardType.staticCardTypes.contains(cardType) {
            return cards.count + 1
        }
        else {
            return cards.count
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        
        if CardType.staticCardTypes.contains(cardType)  {
            
            if indexPath.item == 0 {
                
                switch cardType {
                    
                case .latest : return {
                    let node = PostPropertyNode()
                    return node
                    }
                    
                case .openHouse : return {
                    let node = SearchListingsNode()
                    return node
                    }
                    
                case .under : return {
                    let node = LoanCalculatorNode()
                    return node
                    }
                    
                default : return {
                    let node = ASCellNode()
                    return node
                    }
                    
                }
                
            }
            else {
                
                let card = cards[indexPath.item - 1]
                
                return {
                    let node = CardCellNode(card: card)
                    return node
                }
                
            }
            
        }
        else {
            
            let card = cards[indexPath.item]
            
            return {
                let node = CardCellNode(card: card)
                return node
            }
        }
        
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        
        collectionNode.deselectItem(at: indexPath, animated: true)
        
        var color = UIColor.blue
        
        if CardType.staticCardTypes.contains(cardType) && indexPath.item == 0 {
            
            switch cardType {
                
            case .latest : color = UIColor.orange
            case .openHouse : color = UIColor.gray
            case .under : color = UIColor.yellow
            default :  break
            }
            
        }
        
        let colorVC = ColorViewController(withColor: color)
        colorVC.hidesBottomBarWhenPushed = true
        self.viewController()?.navigationController?.pushViewController(colorVC, animated: true)
    }
}
