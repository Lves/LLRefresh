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
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.autoresizingMask = .flexibleWidth
        label.backgroundColor = UIColor.clear
        self.addSubview(label)
        return label
    }()
    var refreshingTitleHidden:Bool = false
    
    fileprivate var stateTitles:[Int:String] = [:]
    
    override func prepare() {
        super.prepare()
        
        setTitle("下拉可以刷新", state: .normal)
        setTitle("松开立即刷新", state: .pulling)
        setTitle("正在刷新数据中", state: .refreshing)
        
        
    }
    
    
    //MARK:- private
    func stateLabelClick()  {
        if refreshState == .normal {
            beginRefreshing()
        }
    }
    
    
    //MARK: - Public
    func setTitle(_ title:String?, state:LLRefreshState)  {
        if let title = title {
            stateTitles[state.rawValue] = title
            stateLabel.text = stateTitles[refreshState.rawValue]
        }
    }
}
