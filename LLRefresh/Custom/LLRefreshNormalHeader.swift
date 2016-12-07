//
//  LLRefreshNormalHeader.swift
//  LLRefreshDemo
//
//  Created by 李兴乐 on 2016/12/7.
//  Copyright © 2016年 com.lvesli. All rights reserved.
//

import UIKit


class LLRefreshNormalHeader: LLRefreshStateHeader {
    var activityIndicatorViewStyle: UIActivityIndicatorViewStyle = .Gray{
        didSet{
            setNeedsLayout()
        }
    }
    
    private lazy var arrowView: UIImageView = {
        let arrowView = UIImageView(image: UIImage(named: "arrow"))
        self.addSubview(arrowView)
        return arrowView
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(activityIndicatorStyle: self.activityIndicatorViewStyle)
        loadingView.hidesWhenStopped = true
        self.addSubview(loadingView)
        return loadingView
    }()
    

    //MARK: -  集成父类方法
    override func placeSubViews() {
        super.placeSubViews()
        
       //箭头位置
        var arrowCentereX = ll_w*0.5
        if !stateLabel.hidden {  //提示问题没有隐藏
            let stateWidth = stateLabel.ll_textWidth
            var timeWidth:CGFloat = 0
            if !lastUpdatedTimeLabel.hidden {
                timeWidth = lastUpdatedTimeLabel.ll_textWidth
            }
            let textWidth = max(stateWidth, timeWidth)
            arrowCentereX -= textWidth/2 + labelLeftInset
        }
        let arrowCenterY = ll_h * 0.5
        let arrowCenter = CGPointMake(arrowCentereX, arrowCenterY)
        if arrowView.constraints.count == 0 {
            arrowView.ll_size = arrowView.image?.size ?? CGSizeZero
            arrowView.center = arrowCenter
        }
        // 圈圈
        if (loadingView.constraints.count == 0) {
            loadingView.center = arrowCenter
        }

        arrowView.tintColor = stateLabel.textColor
    }
    override func setState(state: LLRefreshState) {
        let old = refreshState
        super.setState(state)
        if state == .Normal {
            
            if old == .Refreshing {
                arrowView.transform = CGAffineTransformIdentity
                
                UIView.animateWithDuration(LLConstant.AnimationDuration, animations: {
                    self.loadingView.alpha = 0
                }, completion: { (finished) in
                    guard self.refreshState == .Normal else {
                        return
                    }
                    self.loadingView.alpha = 1
                    self.arrowView.hidden = false
                })
            }else {
                loadingView.stopAnimating()
                arrowView.hidden = false
                UIView.animateWithDuration(LLConstant.AnimationDuration, animations: {
                    self.arrowView.transform = CGAffineTransformIdentity
                })
            
            }
        }else if state == .Pulling {
            loadingView.stopAnimating()
            arrowView.hidden = false
            UIView.animateWithDuration(LLConstant.AnimationDuration, animations: {
                self.arrowView.transform = CGAffineTransformMakeRotation(0.000001-CGFloat(M_PI))
            })
        }else if state == .Refreshing {
            loadingView.alpha = 1
            loadingView.startAnimating()
            arrowView.hidden = true
        }

    }

}
