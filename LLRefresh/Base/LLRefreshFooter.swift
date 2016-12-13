//
//  LLRefreshFooter.swift
//  LLRefreshDemo
//
//  Created by 李兴乐 on 2016/12/12.
//  Copyright © 2016年 com.lvesli. All rights reserved.
//

import UIKit

class LLRefreshFooter: LLBaseRefreshHeader {
    //是否自动根据数据隐藏
    var automaticallyHidden:Bool = false
    
    

    init(refreshingBlock:(()->())?) {
        super.init(frame: CGRectZero)
        self.refreshingBlock = refreshingBlock
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        ll_h = LLConstant.FooterHeight
    }

    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        if newSuperview != nil {
            if _scrollView is UITableView || _scrollView is UICollectionView {
                
                _scrollView?.ll_reloadDataBlock = {[weak self] count in
                    if self?.automaticallyHidden == true {
                        self?.hidden = count == 0
                    }
                }
            }
 
        }
    }
    
    //MARK: Public 
    func resetNoMoreData()  {
        setState(.Normal)
    }
    
    func endRefreshingWithNoMoreData() {
        setState(.NoMoreData)
    }
    
    
    
}
