//
//  Utilities.swift
//  Discovery
//
//  Created by Alok Jha on 26/02/18.
//  Copyright © 2018 Alok Jha. All rights reserved.
//

import UIKit
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



extension String {
    
    static func formattedPrice( _ price : String) -> String {
        
        let numFormatter = NumberFormatter()
        numFormatter.currencySymbol = "$"
        numFormatter.locale = Locale(identifier: "en_SG")
        numFormatter.numberStyle = .currency
        numFormatter.maximumFractionDigits = 0
        
        let priceNum = NSNumber.init(value: Float(price)!)
        
        return numFormatter.string(from: priceNum)!
    }
    
}


extension NSAttributedString {
    
    static func bolAttributtedString(for string : String) -> NSAttributedString {
        
        let attributes = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 22.0, weight: .bold),NSAttributedStringKey.foregroundColor : UIColor.black]
        
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        
        return attributedString
    }
    
    static func regularAttributtedString(for string : String) -> NSAttributedString {
        
        let attributes = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18.0, weight: .light),NSAttributedStringKey.foregroundColor : UIColor.black]
        
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        
        return attributedString
    }
    
    
    static func smallAttributtedString(for string : String) -> NSAttributedString {
        
        let attributes = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14.0, weight: .light),NSAttributedStringKey.foregroundColor : UIColor.black]
        
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        
        return attributedString
    }
    
}

extension UIImage {
    static func from(color: UIColor,size : CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: 35)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

