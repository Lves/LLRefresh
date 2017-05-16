//
//  LLCustomHeader.swift
//  LLRefreshDemo
//
//  Created by lixingle on 2017/5/16.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit
import LLRefresh
class LLCustomHeader: LLRefreshHeader {
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("我是按钮", for: .normal)
        self.addSubview(button)
        return button
    }()
    override func placeSubViews() {
        super.placeSubViews()
        button.frame = CGRect(x: (ll_w-100)/2.0, y: 10, width: 100, height: 40)
    }
    override open func setState(_ state: LLRefreshState) {
        super.setState(state)
        if state == .normal {
            button.setTitleColor(UIColor.blue, for: .normal)
        }else if state == .refreshing {
            button.setTitleColor(UIColor.red, for: .normal)
        }else if state == .pulling {
            button.setTitleColor(UIColor.orange, for: .normal)
        }else if state == .willRefresh {
            button.setTitleColor(UIColor.yellow, for: .normal)
        }
    }
}
