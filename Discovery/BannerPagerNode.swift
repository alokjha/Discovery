//
//  BannerPagerNode.swift
//  Discovery
//
//  Created by Alok Jha on 26/02/18.
//  Copyright © 2018 Alok Jha. All rights reserved.
//

import AsyncDisplayKit
import SafariServices
import RxSwift

class BannerPagerNode : ASCellNode {
    
    fileprivate let client = APIClient()
    let pagerNode : ASPagerNode = ASPagerNode()
    let disposeBag : DisposeBag = DisposeBag()
    let elementSize : CGSize
    var banners : [Banner] = []
    
    //weak var viewController: UIViewController?
    
    init(elementSize : CGSize) {
        
        self.elementSize = elementSize
        super.init()
        
        pagerNode.setDataSource(self)
        pagerNode.setDelegate(self)
        addSubnode(pagerNode)
        fetchBanners()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        pagerNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: elementSize.height)
        let spec = ASAbsoluteLayoutSpec(sizing: .default, children: [pagerNode])
        return spec
    }
    
    func fetchBanners() {
        
        let bannerRequest = BannerRequest()
        
        client.send(apiRequest: bannerRequest)
                    .observeOn(MainScheduler.instance)
                    .map { (response : BannerListResponse)  in
                        response.data.banners
                    }
                    .subscribe(onNext: { (banners : [Banner]) in
                         print("banners : \n \(banners)")
                         self.banners.append(contentsOf: banners)
                         self.pagerNode.reloadData()
                    }, onError: { (error) in
                         print("error : \(error)")
                    }).disposed(by: disposeBag)

        
    }
}

extension BannerPagerNode : ASPagerDataSource,ASPagerDelegate {
    func numberOfPages(in pagerNode: ASPagerNode) -> Int {
        return banners.count
    }
    
    func pagerNode(_ pagerNode: ASPagerNode, nodeBlockAt index: Int) -> ASCellNodeBlock {
        let banner = banners[index]
        
        return {
            let node = BannerNode(banner: banner)
            return node
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        let banner = banners[indexPath.item]
        let safariVC = SFSafariViewController(url: URL.init(string: banner.urlLink)!)
        self.viewController?.present(safariVC, animated: true, completion: nil)
    }
}
