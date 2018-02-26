//
//  ASDisplayNode+Extension.swift
//  Discovery
//
//  Created by Alok Jha on 26/02/18.
//  Copyright © 2018 Alok Jha. All rights reserved.
//


import AsyncDisplayKit

extension ASDisplayNode {
    
    func viewController() -> UIViewController? {
        
        var nextResponder: UIResponder? = self.view
        
        repeat {
            nextResponder = nextResponder?.next
            
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            
        } while nextResponder != nil
        
        return nil
    }
}
