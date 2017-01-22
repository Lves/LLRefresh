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
        
        setTitle("点击或上拉加载更多", state: .normal)
        setTitle("正在加载更多的数据...", state: .refreshing)
        setTitle("已经全部加载完毕", state: .noMoreData)
        stateLabel.isUserInteractionEnabled = true
        stateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(stateLabelClick)))
        
    }
    override func setState(_ state: LLRefreshState) {
        super.setState(state)
        
        if refreshingTitleHidden && state == .refreshing{
            stateLabel.text = nil
        }
        stateLabel.text = stateTitles[refreshState.rawValue]
    }
    override func placeSubViews() {
        super.placeSubViews()
        guard stateLabel.constraints.count == 0 else{
            return
        }
        stateLabel.frame = self.bounds
        
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