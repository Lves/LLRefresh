//
//  NSBundle+LLExtension.swift
//  LLRefreshDemo
//
//  Created by lixingle on 2017/5/15.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import Foundation


extension Bundle{
    var ll_bundle:Bundle?{
        if let path = Bundle(for: LLRefreshHeader.self).path(forResource: "LLRefresh", ofType: "bundle"){
            return Bundle(path: path)
        }
        return nil
    }
    var ll_arrowImage:UIImage?{
        if let path = ll_bundle?.path(forResource: "arrow@2x", ofType: "png"){
            return UIImage(contentsOfFile: path)!
        }
        return nil
    }
}
