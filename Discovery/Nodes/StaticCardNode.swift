//
//  StaticCardNode.swift
//  Discovery
//
//  Created by Alok Jha on 26/02/18.
//  Copyright © 2018 Alok Jha. All rights reserved.
//

import AsyncDisplayKit

class StaticCardNode : ASCellNode {
    
    private let titleNode = ASTextNode()
    private let subtitleNode = ASTextNode()
    private let buttonNode = ASButtonNode()
    
    var titleText : String {
        return ""
    }
    
    var subtitleText : String {
        return ""
    }
    
    var buttonText : String {
        return ""
    }
    
    override init() {
        super.init()
        
        let titleAttribute = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 30.0, weight: .bold),NSAttributedStringKey.foregroundColor : UIColor.white]
        
        titleNode.attributedText = NSAttributedString(string: titleText, attributes: titleAttribute)
        
        let subtitleAttribute = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20.0, weight: .regular),NSAttributedStringKey.foregroundColor : UIColor.white]
        
        subtitleNode.attributedText = NSAttributedString(string: subtitleText, attributes: subtitleAttribute)
        
        let buttonAttribute = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14.0, weight: .regular),NSAttributedStringKey.foregroundColor : UIColor.white]
        
        buttonNode.setAttributedTitle(NSAttributedString.init(string: buttonText, attributes: buttonAttribute), for: .normal)
        buttonNode.backgroundColor = UIColor.init(red: 222/255.0, green: 106/255.0, blue: 46/255.0, alpha: 1.0)
        
        backgroundColor = UIColor.lightGray
        
        self.selectionStyle = .none
        
        addSubnode(titleNode)
        addSubnode(subtitleNode)
        addSubnode(buttonNode)
        
    }
    
    override func didLoad() {
        super.didLoad()
        buttonNode.view.layer.cornerRadius = 5.0
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        buttonNode.style.preferredSize = CGSize(width: constrainedSize.max.width - 30, height: 40)
        
        let verticalSpec = ASStackLayoutSpec.vertical()
        verticalSpec.children = [titleNode,subtitleNode]
        verticalSpec.alignItems = .center
        verticalSpec.spacing = 5.0
        
        let textSpec = ASRelativeLayoutSpec(horizontalPosition: .center,
                                            verticalPosition: .start,
                                            sizingOption: [],
                                            child: verticalSpec)
        
        let buttonSpec = ASRelativeLayoutSpec(horizontalPosition: .center,
                                              verticalPosition: .end,
                                              sizingOption: [],
                                              child: buttonNode)
        
        let wrapperSpec = ASWrapperLayoutSpec(layoutElements: [textSpec,buttonSpec])
        
        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(50, 0, 50, 0), child: wrapperSpec)
    }
}


class PostPropertyNode : StaticCardNode {
    
    override var titleText: String {
        return "POST"
    }
    
    override var subtitleText: String {
        return "My Property"
    }
    
    override var buttonText: String {
        return "Post Now"
    }
}

class SearchListingsNode : StaticCardNode {
    
    override var titleText: String {
        return "SEARCH"
    }
    
    override var subtitleText: String {
        return "Listings"
    }
    
    override var buttonText: String {
        return "Open Map"
    }
}

class LoanCalculatorNode : StaticCardNode {
    
    override var titleText: String {
        return "LOAN"
    }
    
    override var subtitleText: String {
        return "Calculator"
    }
    
    override var buttonText: String {
        return "Calculate"
    }
}


