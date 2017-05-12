//
//  LLEatFooter.swift
//  LLRefreshDemo
//
//  Created by lixingle on 2017/3/2.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit
import LLRefresh
class LLEatFooter: LLRefreshAutoGifFooter {
    
    override func prepare() {
        super.prepare()
        
        var refreshingImage:[UIImage] = []
        for index in 1...3 {
            let image = UIImage(named: "dropdown_loading_0\(index)")
            refreshingImage.append(image!)
        }
        setImages(images: refreshingImage, state: .refreshing)
        
    }

}
