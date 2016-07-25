//
//  LLRefreshHeader.swift
//  LLRefrsh
//
//  Created by LiXingLe on 16/7/25.
//  Copyright © 2016年 com.wildcat. All rights reserved.
//

import UIKit

class LLRefreshHeader: BaseRefreshHeader {
    override var refreshState: LLRefreshState{
        get{
            return _refreshState
        }
        
        set{
            _refreshState = newValue
        }
    }

  
}
