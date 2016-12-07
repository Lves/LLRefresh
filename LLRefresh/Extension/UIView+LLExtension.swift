//
//  UIView+LLExtension.swift
//  LLRefrsh
//
//  Created by 李兴乐 on 2016/12/2.
//  Copyright © 2016年 com.wildcat. All rights reserved.
//

import UIKit
extension UIView {
   
    public var ll_x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(value) {
            self.frame = CGRect(x: value, y: self.ll_y, width: self.ll_w, height: self.ll_h)
        }
    }

    public var ll_y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(value) {
            self.frame = CGRect(x: self.ll_x, y: value, width: self.ll_w, height: self.ll_h)
        }
    }
    
  
    public var ll_w: CGFloat {
        get {
            return self.frame.size.width
        }
        set(value) {
            self.frame = CGRect(x: self.ll_x, y: self.ll_y, width: value, height: self.ll_h)
        }
    }
    
    public var ll_h: CGFloat {
        get {
            return self.frame.size.height
        }
        set(value) {
            self.frame = CGRect(x: self.ll_x, y: self.ll_y, width: self.ll_w, height: value)
        }
    }
    public var ll_size: CGSize {
        get {
            return self.frame.size
        }
        set(value) {
            var frame = self.frame
            frame.size = value
            self.frame = frame
        }
    }
    
    
}
