//
//  HeaderNode.swift
//  Discovery
//
//  Created by Alok Jha on 26/02/18.
//  Copyright © 2018 Alok Jha. All rights reserved.
//

import AsyncDisplayKit

class HeaderNode : ASCellNode {
    
    let titleTextNode : ASTextNode = ASTextNode()
    let buttonNode : ASButtonNode = ASButtonNode()
    
    init(forCardType type : CardType) {
        
        super.init()
        
        titleTextNode.placeholderEnabled = true
        titleTextNode.placeholderFadeDuration = 0.15
        titleTextNode.placeholderColor = UIColor(white: 0.777, alpha: 1.0)
        titleTextNode.attributedText = NSAttributedString(string: type.headerText(), attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16.0, weight: .bold),NSAttributedStringKey.foregroundColor : UIColor.black])
        
        let buttonTitle = "View More >"
        let attributedTitle = NSAttributedString(string: buttonTitle, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16.0, weight: .light),NSAttributedStringKey.foregroundColor : UIColor.init(red: 224/255.0, green: 127/255.0, blue: 71/255.0, alpha: 1.0)])
        buttonNode.setAttributedTitle(attributedTitle, for: .normal)
        buttonNode.setAttributedTitle(attributedTitle, for: .selected)
        buttonNode.addTarget(self, action: #selector(viewMoreTapped(_:)), forControlEvents: .touchUpInside)
        
        addSubnode(titleTextNode)
        addSubnode(buttonNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let insetSpec1 = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(0, 15, 0, 0), child: titleTextNode)
        
        let insetSpec2 = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(0, 0, 0, 15), child: buttonNode)
        
        let headerStackSpec1 = ASStackLayoutSpec(direction: .horizontal,
                                                spacing: 0,
                                                justifyContent: .start,
                                                alignItems: .center,
                                                children: [insetSpec1])
        
        let headerStackSpec2 = ASStackLayoutSpec(direction: .horizontal,
                                                spacing: 0,
                                                justifyContent: .end,
                                                alignItems: .center,
                                                children: [insetSpec2])
        
    
        return ASWrapperLayoutSpec(layoutElements: [headerStackSpec1,headerStackSpec2])
    }
    
    @objc func viewMoreTapped(_ sender : ASButtonNode) {
        let colorVC = ColorViewController(withColor: UIColor.green)
        self.viewController()?.navigationController?.pushViewController(colorVC, animated: true)
    }
}
