//
//  BannerNode.swift
//  Discovery
//
//  Created by Alok Jha on 26/02/18.
//  Copyright © 2018 Alok Jha. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import SafariServices


class BannerNode : ASCellNode {
    
    fileprivate let client = APIClient()
    fileprivate let disposeBag = DisposeBag()
    let imageNode : ASImageNode = ASImageNode()
    let banner : Banner
    
    init(banner : Banner) {
        self.banner = banner
        super.init()
        
        imageNode.clipsToBounds = true
        imageNode.placeholderFadeDuration = 0.15
        imageNode.contentMode = .scaleAspectFill
        imageNode.backgroundColor = UIColor.brown
        
        addSubnode(imageNode)
        loadImage()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        imageNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: constrainedSize.max.height-30)
        let spec = ASAbsoluteLayoutSpec(sizing: .default, children: [imageNode])
        return spec
    }
    
    override func layout() {
        super.layout()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        //self.view.addGestureRecognizer(tapGesture)
    }
    
    func loadImage() {
        
        let imageRequest = ImageRequest(name: banner.imageName)
        
        client.downloadImage(imageRequest: imageRequest)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (image) in
                self.imageNode.image = image
            }, onError: { (error) in
                print("ImageRequest error : \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    @objc func tapped() {
        
        let safariVC = SFSafariViewController(url: URL.init(string: banner.urlLink)!)
        self.viewController()?.present(safariVC, animated: true, completion: nil)
    }
}
