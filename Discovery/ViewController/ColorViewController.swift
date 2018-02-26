//
//  ColorViewController.swift
//  Discovery
//
//  Created by Alok Jha on 26/02/18.
//  Copyright © 2018 Alok Jha. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ColorViewController : ASViewController <ASDisplayNode> {
    
    let nodeView : ASDisplayNode = ASDisplayNode()
    init(withColor color: UIColor){
        super.init(node: nodeView)
        nodeView.backgroundColor = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
