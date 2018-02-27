//
//  BannerNode.swift
//  Discovery
//
//  Created by Alok Jha on 26/02/18.
//  Copyright © 2018 Alok Jha. All rights reserved.
//

import AsyncDisplayKit

class BannerNode : ASCellNode {
    
    fileprivate let imageNode : ASImageNode = ASImageNode()
    fileprivate let banner : Banner
    
    init(banner : Banner) {
        self.banner = banner
        super.init()
        
        imageNode.clipsToBounds = true
        imageNode.placeholderFadeDuration = 0.15
        imageNode.contentMode = .scaleAspectFill
        imageNode.backgroundColor = UIColor.brown
        
        addSubnode(imageNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        imageNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: constrainedSize.max.height-30)
        let spec = ASAbsoluteLayoutSpec(sizing: .default, children: [imageNode])
        return spec
    }

    func setImage(_ image : UIImage) {
        imageNode.image = image
    }
}
