//
//  UILabel+LLExtension.swift
//  LLRefreshDemo
//
//  Created by 李兴乐 on 2016/12/7.
//  Copyright © 2016年 com.lvesli. All rights reserved.
//

import UIKit

extension String {
    var ll_length: Int {
        return self.characters.count
    }
}

extension UILabel{
    
    var ll_textWidth:CGFloat {
        get{
            var width:CGFloat? = 0
            if self.text?.ll_length > 0 {
                let size = CGSizeMake(CGFloat(MAXFLOAT), CGFloat(MAXFLOAT))
                width = self.text?.boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:self.font], context: nil).size.width
            }
            return width ?? 0
        }
    }

}


