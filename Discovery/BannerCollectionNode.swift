//
//  BannerCollectionNode.swift
//  Discovery
//
//  Created by Alok Jha on 26/02/18.
//  Copyright © 2018 Alok Jha. All rights reserved.
//

import AsyncDisplayKit
import SafariServices
import RxSwift

class BannerCollectionNode : ASCellNode {
    
    fileprivate let client = APIClient()
    
    let pageControl = UIPageControl()
    let collectionNode : ASCollectionNode
    let disposeBag : DisposeBag = DisposeBag()
    let elementSize : CGSize
    var banners : [Banner] = []
    
    init(elementSize : CGSize) {
        
        self.elementSize = elementSize
    
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = elementSize
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets.zero
        
        collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        collectionNode.view.isPagingEnabled = true
      
        super.init()
        
        addSubnode(collectionNode)
        
        collectionNode.dataSource = self
        collectionNode.delegate  = self
        
        pageControl.currentPageIndicatorTintColor = UIColor.red
        pageControl.pageIndicatorTintColor = UIColor.lightGray.withAlphaComponent(0.8)
        pageControl.frame = CGRect(x: 0.0, y: elementSize.height-30, width: elementSize.width, height: 30.0)
        
        self.view.addSubview(pageControl)
        
        fetchBanners()
    }
    
    override func layout() {
        super.layout()
        collectionNode.contentInset = UIEdgeInsets.zero
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        collectionNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: elementSize.height)
        let spec = ASAbsoluteLayoutSpec(sizing: .default, children: [collectionNode])
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
                         self.banners.append(contentsOf: banners)
                         self.collectionNode.reloadData()
                         self.pageControl.numberOfPages = self.banners.count
                         self.pageControl.currentPage = 0
                    }, onError: { (error) in
                         print("error : \(error)")
                    }).disposed(by: disposeBag)

        
    }
    
}

extension BannerCollectionNode : ASCollectionDataSource,ASCollectionDelegate {
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return banners.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let banner = banners[indexPath.item]
        let node = BannerNode(banner: banner)
        return node
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        collectionNode.deselectItem(at: indexPath, animated: true)
        let banner = banners[indexPath.item]
        let safariVC = SFSafariViewController(url: URL.init(string: banner.urlLink)!)
        self.viewController()?.present(safariVC, animated: true, completion: nil)
    }
    
    
    func collectionNode(_ collectionNode: ASCollectionNode, willDisplayItemWith node: ASCellNode) {
        if let index = collectionNode.indexPath(for: node) {
            pageControl.currentPage = index.item
        }
    }
    
}
