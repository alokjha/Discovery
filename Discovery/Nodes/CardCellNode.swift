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
    fileprivate let favButtonNode : ASButtonNode = ASButtonNode()
    
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
        addSubnode(favButtonNode)
        
        let normalImage = UIImage(named: "shortlist")
        let selectedImage = UIImage(named: "shortlist-selected")
        favButtonNode.setImage(normalImage, for: .normal)
        favButtonNode.setImage(selectedImage, for: .selected)
        favButtonNode.addTarget(self, action: #selector(toggleFavorite(_:)), forControlEvents: .touchUpInside)
        
        imageNode.backgroundColor = UIColor.brown
        
        updateValues()
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
    
    override func didLoad() {
        super.didLoad()
        favButtonNode.isSelected = FavoriteManager.shared.isFavorite(card)
    }
    
    @objc func toggleFavorite(_ sender : ASButtonNode) {
        sender.isSelected = !sender.isSelected
        
        if FavoriteManager.shared.isFavorite(card){
            FavoriteManager.shared.removeFromFavorite(card)
        }
        else {
            FavoriteManager.shared.addToFavorite(card)
        }
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        imageNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: constrainedSize.max.height*0.75)
        
        let insets = UIEdgeInsets(top: 50, left: CGFloat.infinity, bottom: CGFloat.infinity, right: 20)
        let favImageSpec = ASInsetLayoutSpec(insets: insets, child: favButtonNode)
        
        let overlaySpec = ASOverlayLayoutSpec(child: imageNode, overlay: favImageSpec)
        
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
        textAreaSpec.style.flexGrow = 1.0
        textAreaSpec.children = [priceAddressSpec,bedBathAreaSpec]
        
        textAreaSpec.style.preferredSize = CGSize(width: constrainedSize.max.width, height: constrainedSize.max.height*0.25)
        
        let finalSpec = ASStackLayoutSpec()
        finalSpec.direction = .vertical
        finalSpec.spacing = 5.0
        finalSpec.style.flexGrow = 1.0
        finalSpec.children = [overlaySpec,textAreaSpec]
        
        return finalSpec
    }
}
