//
//  LLRefreshHeader.swift
//  LLRefrsh
//
//  Created by LiXingLe on 16/7/25.
//  Copyright © 2016年 com.wildcat. All rights reserved.
//

import UIKit

class LLRefreshHeader: BaseRefreshHeader {
    
    var arrowView:UIImageView?
    let lastUpdateTimeKey = "lastUpdateTimeKey"
    
  
    
    override func placeSubViews() {
        super.placeSubViews()
        
        
    }
    
    override func setState(refreshState: LLRefreshState) {
        let oldState = _refreshState
        if oldState == refreshState {
            return
        }else {
            super.setState(refreshState)
        }
        
        if refreshState == LLRefreshState.Nomal{
            if oldState != LLRefreshState.Refreshing {
                return
            }
            NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: lastUpdateTimeKey)
            NSUserDefaults.standardUserDefaults().synchronize()
            
            
        }else if refreshState == LLRefreshState.Refreshing {
        
            
        }
        
        
    }

  
}
