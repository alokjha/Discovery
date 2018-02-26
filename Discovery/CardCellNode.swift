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

class CardCellNode : ASCellNode {
    
    fileprivate let card : Card
    fileprivate let client = APIClient()
    fileprivate let disposeBag = DisposeBag()
    fileprivate let imageNode: ASImageNode = ASImageNode()
    fileprivate let priceTextNode : ASTextNode = ASTextNode()
    fileprivate let addressTextNode : ASTextNode = ASTextNode()
    fileprivate let bedTextNode : ASTextNode = ASTextNode()
    fileprivate let bathTextNode : ASTextNode = ASTextNode()
    fileprivate let areaTextNode : ASTextNode = ASTextNode()
    
    init(card : Card) {
        self.card = card
        
        super.init()
        
        priceTextNode.placeholderEnabled = true
        priceTextNode.placeholderFadeDuration = 0.15
        priceTextNode.placeholderColor = UIColor(white: 0.777, alpha: 1.0)
        
        addressTextNode.truncationAttributedText = NSAttributedString(string: "...")
        addressTextNode.placeholderEnabled = true
        addressTextNode.placeholderFadeDuration = 0.15
        addressTextNode.placeholderColor = UIColor(white: 0.777, alpha: 1.0)
        
        imageNode.clipsToBounds = true
        imageNode.placeholderFadeDuration = 0.15
        imageNode.contentMode = .scaleAspectFill
        
        addSubnode(priceTextNode)
        addSubnode(addressTextNode)
        addSubnode(bedTextNode)
        addSubnode(bathTextNode)
        addSubnode(areaTextNode)
        addSubnode(imageNode)
        
        updateValues()
        
        imageNode.backgroundColor = UIColor.brown
        
    }
    
    private func updateValues() {
        
        priceTextNode.attributedText = NSAttributedString.bolAttributtedString(for: String.formattedPrice(card.price))
        addressTextNode.attributedText = NSAttributedString.regularAttributtedString(for: card.addressString)
        bedTextNode.attributedText = NSAttributedString.smallAttributtedString(for: "Beds:\(card.numBeds) ")
        bathTextNode.attributedText = NSAttributedString.smallAttributtedString(for: "Bath:\(card.numToilets) ")
        areaTextNode.attributedText = NSAttributedString.smallAttributtedString(for: "Area:\(card.sizeSQM) sqm")
        
        let imageRequest = ImageRequest(name: card.imageName)
        
        client.downloadImage(imageRequest: imageRequest)
                        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (image) in
                self.imageNode.image = image
            }, onError: { (error) in
                print("ImageRequest error : \(error)")
            })
           .disposed(by: disposeBag)
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let priceAddressSpec = ASStackLayoutSpec()
        priceAddressSpec.direction = .horizontal
        priceAddressSpec.spacing = 5.0
        priceAddressSpec.alignItems = .baselineFirst
        priceAddressSpec.children = [priceTextNode,addressTextNode]
        
        let bedBathAreaSpec = ASStackLayoutSpec()
        bedBathAreaSpec.direction = .horizontal
        bedBathAreaSpec.alignItems = .baselineFirst
        bedBathAreaSpec.children = [bedTextNode,bathTextNode,areaTextNode]
        
        let textAreaSpec = ASStackLayoutSpec()
        textAreaSpec.direction = .vertical
        textAreaSpec.spacing = 5.0
        textAreaSpec.children = [priceAddressSpec,bedBathAreaSpec]
        
        imageNode.style.flexBasis = ASDimensionMake("70%")
        textAreaSpec.style.flexBasis = ASDimensionMake("30%")
        
        let finalSpec = ASStackLayoutSpec()
        finalSpec.direction = .vertical
        finalSpec.spacing = 5.0
        finalSpec.children = [imageNode,textAreaSpec]
        
        return finalSpec
    }
}
