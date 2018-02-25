//
//  DiscoveryViewController.swift
//  Discovery
//
//  Created by Alok Jha on 22/02/18.
//  Copyright © 2018 Alok Jha. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit
import RxSwift
import RxCocoa

class DiscoveryViewController: ASViewController<ASDisplayNode> {

    private let apiClient = APIClient()
    private let disposeBag = DisposeBag()
    private let tableNode : ASTableNode
    private let cardTypes : [CardType] = [.featured,.latest,.openHouse,.under,.houseRent,.roomRent]
    
    private let searchController: UISearchController = {
        let vc = UIViewController(nibName: nil, bundle: nil)
        vc.view.backgroundColor = UIColor.red
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search..."
        return searchController
    }()
    
    
    init() {
       
        tableNode = ASTableNode(style: .plain)
        
        super.init(node: tableNode)
        
        self.tableNode.delegate = self
        self.tableNode.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
            navigationItem.titleView = searchController.searchBar
        }
        searchController.searchBar.delegate = self
        navigationItem.title = "ohmyhome"
        
        tableNode.view.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension DiscoveryViewController : UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let colorVC = ColorViewController(withColor: UIColor.red)
        self.navigationController?.pushViewController(colorVC, animated: true)
        return false
    }
}


extension DiscoveryViewController : ASTableDataSource,ASTableDelegate {
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        
        var width : CGFloat  = UIScreen.main.bounds.size.width
        var height : CGFloat = 150.0
        
        if indexPath.row == 0 {
            return BannerPagerNode(elementSize: CGSize(width: width, height: height))
        }
        
        width -= 30.0
        height = 250.0
        
        let cardType = cardTypes[indexPath.row - 1]
        
        return HorizontalCollectionNode(elementSize: CGSize(width: width, height: height),cardType:cardType)
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 1 + cardTypes.count
    }
}

