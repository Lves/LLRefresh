//
//  LLRefreshAutoNormalFooter.swift
//  LLRefreshDemo
//
//  Created by lixingle on 2017/1/22.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit

class LLRefreshAutoNormalFooter: LLRefreshAutoStateFooter {
    var activityIndicatorViewStyle: UIActivityIndicatorViewStyle = .gray{
        didSet{
            setNeedsLayout()
        }
    }
    fileprivate lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(activityIndicatorStyle: self.activityIndicatorViewStyle)
        loadingView.hidesWhenStopped = true
        self.addSubview(loadingView)
        return loadingView
    }()
    override func placeSubViews() {
        super.placeSubViews()
        
        guard loadingView.constraints.count == 0 else {
            return
        }
        var centerX = ll_w * 0.5
        if !refreshingTitleHidden {
            centerX -= (stateLabel.ll_textWidth * 0.5 + labelLeftInset)
        }
        let centerY = ll_h * 0.5
        loadingView.center = CGPoint(x: centerX, y: centerY)
        
        loadingView.tintColor = stateLabel.textColor
    }
    override func setState(_ state: LLRefreshState) {
        super.setState(state)
       
        if state == .noMoreData || state == .normal {
            loadingView.stopAnimating()
        }else if state == .refreshing {
            loadingView.startAnimating()
        }
    }
    
}
