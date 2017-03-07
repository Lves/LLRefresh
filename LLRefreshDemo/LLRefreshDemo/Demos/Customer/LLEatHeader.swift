//
//  LLEatHeader.swift
//  LLRefreshDemo
//
//  Created by lixingle on 2017/1/22.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit

class LLEatHeader: LLRefreshGifHeader {
    
    override func prepare() {
        super.prepare()
        //1.0 正常图片
        var normalImage:[UIImage] = []
        for index in 1...60 {
            let image = UIImage(named: "dropdown_anim__000\(index)")
            normalImage.append(image!)
        }
        setImages(images: normalImage, state: .normal)
        //2.0 即将刷新
        
        var refreshingImage:[UIImage] = []
        for index in 1...3 {
            let image = UIImage(named: "dropdown_loading_0\(index)")
            refreshingImage.append(image!)
        }
        setImages(images: refreshingImage, state: .pulling)
        //3.0 正在刷新
        setImages(images: refreshingImage, state: .refreshing)
        
    }

}


//class LLJdHeader: LLRefreshGifHeader {
//    
//    override func prepare() {
//        super.prepare()
//        //1.0 正常图片
//        var normalImage:[UIImage] = []
//        for index in 2...4 {
//            let image = UIImage(named: "jd_loading_\(index)")
//            normalImage.append(image!)
//        }
//        setImages(images: normalImage, state: .normal)
//        setImages(images: normalImage, state: .pulling)
//        setImages(images: normalImage, state: .refreshing)
//        
//    }
//    
//}
