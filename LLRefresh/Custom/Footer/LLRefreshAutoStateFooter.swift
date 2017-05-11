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
        setTitle(LLConstant.kFooterStateTitleNormal, state: .normal)
        setTitle(LLConstant.kFooterStateTitleRefreshing, state: .refreshing)
        setTitle(LLConstant.kFooterStateTitleNoMoreData, state: .noMoreData)
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
    @objc private func stateLabelClick()  {
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
