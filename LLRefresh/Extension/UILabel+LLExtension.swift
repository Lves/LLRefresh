//
//  UILabel+LLExtension.swift
//  LLRefreshDemo
//
//  Created by 李兴乐 on 2016/12/7.
//  Copyright © 2016年 com.lvesli. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


extension String {
    public var ll_length: Int {
        return self.characters.count
    }
}

extension UILabel{
    
    public var ll_textWidth:CGFloat {
        get{
            var width:CGFloat? = 0
            if self.text?.ll_length > 0 {
                let size = CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))
                width = self.text?.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:self.font], context: nil).size.width
            }
            return width ?? 0
        }
    }

}


