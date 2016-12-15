//
//  LLRefreshAutoStateFooter.swift
//  LLRefreshDemo
//
//  Created by 李兴乐 on 2016/12/15.
//  Copyright © 2016年 com.lvesli. All rights reserved.
//

import UIKit

class LLRefreshAutoStateFooter: LLRefreshAutoFooter {

    var labelLeftInset:CGFloat = LLConstant.RefreshLabelLeftInset
    lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(14)
        label.autoresizingMask = .FlexibleWidth
        label.backgroundColor = UIColor.clearColor()
        self.addSubview(label)
        return label
    }()
    var refreshingTitleHidden:Bool = false
    
    private var stateTitles:[Int:String] = [:]
    
    override func prepare() {
        super.prepare()
        
        setTitle("下拉可以刷新", state: .Normal)
        setTitle("松开立即刷新", state: .Pulling)
        setTitle("正在刷新数据中", state: .Refreshing)
        
        
    }
    
    
    //MARK:- private
    func stateLabelClick()  {
        if refreshState == .Normal {
            beginRefreshing()
        }
    }
    
    
    //MARK: - Public
    func setTitle(title:String?, state:LLRefreshState)  {
        if let title = title {
            stateTitles[state.rawValue] = title
            stateLabel.text = stateTitles[refreshState.rawValue]
        }
    }
}
