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
    
    init() {
        super.init(frame: CGRect.zero)
    }

    init(refreshingBlock:(()->())?) {
        super.init(frame: CGRect.zero)
        self.refreshingBlock = refreshingBlock
    }
    init(target:AnyObject , action: Selector){
        super.init(frame: CGRect.zero)
        self.setRefrshing(target: target, action: action)
        
    }
    class func footer(target:AnyObject , action: Selector) -> LLRefreshFooter{
        let footer = LLRefreshFooter()
        footer.setRefrshing(target: target, action: action)
        return footer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        ll_h = LLConstant.FooterHeight
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview != nil {
            if _scrollView is UITableView || _scrollView is UICollectionView {
                
                _scrollView?.ll_reloadDataBlock = {[weak self] count in
                    if self?.automaticallyHidden == true {
                        self?.isHidden = count == 0
                    }
                }
            }
 
        }
    }
    
    //MARK: Public 
    func resetNoMoreData()  {
        setState(.normal)
    }
    func endRefreshingWithNoMoreData() {
        setState(.noMoreData)
    }
    
    
    
}
