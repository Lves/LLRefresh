//
//  LLRefreshBGImageHeader.swift
//  LLRefreshDemo
//
//  Created by 李兴乐 on 2016/12/9.
//  Copyright © 2016年 com.lvesli. All rights reserved.
//  带有背景图片的刷新header

import UIKit
import LXLRefresh

class LLRefreshBGImageHeader: LLRefreshNormalHeader {

    fileprivate lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView(image: UIImage(named:"refresh_bg"))
        self.insertSubview(bgImageView, at: 0)
        return bgImageView
    }()
    
    
    //MARK: -  集成父类方法
    override func placeSubViews() {
        super.placeSubViews()
        bgImageView.ll_x = 0
        bgImageView.ll_y =  -(bgImageView.ll_h - ll_h)
        bgImageView.ll_w = ll_w
    }

}
