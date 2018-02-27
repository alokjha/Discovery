//
//  BannerCollectionNode.swift
//  Discovery
//
//  Created by Alok Jha on 26/02/18.
//  Copyright © 2018 Alok Jha. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import SafariServices
import RxSwift
import RxCocoa

class BannerCollectionNode : ASCellNode {
    
    fileprivate let pageControl = UIPageControl()
    fileprivate let collectionNode : ASCollectionNode
    fileprivate let disposeBag : DisposeBag = DisposeBag()
    fileprivate let elementSize : CGSize
    fileprivate var banners : [Banner] = []
    fileprivate let bannerModel = BannerViewModel()
    
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
        
        bannerModel.banners.bind { banners in
            self.banners.append(contentsOf: banners)
            self.collectionNode.reloadData()
            self.pageControl.numberOfPages = self.banners.count
            self.pageControl.currentPage = 0
            self.fetchBannerImages()
            }
            .disposed(by: disposeBag)
    }
    
    override func layout() {
        super.layout()
        collectionNode.view.showsHorizontalScrollIndicator = false
        collectionNode.contentInset = UIEdgeInsets.zero
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        collectionNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: elementSize.height)
        let spec = ASAbsoluteLayoutSpec(sizing: .default, children: [collectionNode])
        return spec
    }
    
    //starting timer only when all the images are fetched
    func fetchBannerImages() {
        
        let dispatchGroup = DispatchGroup()
        
        for i in 0..<banners.count {
            let banner = banners[i]
            dispatchGroup.enter()
            let model = BannerImageModel(imageName: banner.imageName)
            model.downloadedImage.subscribe(onNext: { image in
                let idxPath = IndexPath(item: i, section: 0)
                let bannerNode = self.collectionNode.nodeForItem(at: idxPath) as! BannerNode
                bannerNode.setImage(image)
            }, onError: { error in
                print("error \(error)")
            }, onCompleted: {
                dispatchGroup.leave()
            })
            .disposed(by: disposeBag)
        }
        
        dispatchGroup.notify(queue: .main) {
           self.startTimer()
        }
    }
    
    func startTimer() {
        let timer = Timer(timeInterval: 3.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
       RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
    }
    
    @objc func timerAction() {
        let cellSize = CGSize(width:collectionNode.frame.width, height:collectionNode.frame.height);
        let contentOffset = collectionNode.contentOffset
        
        if  collectionNode.view.contentSize.width <= collectionNode.contentOffset.x + cellSize.width
        {
            collectionNode.view.scrollRectToVisible(CGRect(x:0, y:contentOffset.y, width:cellSize.width, height:cellSize.height), animated: true);
            
        } else {
            collectionNode.view.scrollRectToVisible(CGRect(x:contentOffset.x + cellSize.width, y:contentOffset.y, width:cellSize.width, height:cellSize.height), animated: true);
        }
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
        self.view.viewController()?.present(safariVC, animated: true, completion: nil)
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, willDisplayItemWith node: ASCellNode) {
        if let index = collectionNode.indexPath(for: node) {
            pageControl.currentPage = index.item
        }
    }
    
}


