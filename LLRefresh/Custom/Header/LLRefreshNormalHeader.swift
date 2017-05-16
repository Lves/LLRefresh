//
//  LLRefreshNormalHeader.swift
//  LLRefreshDemo
//
//  Created by 李兴乐 on 2016/12/7.
//  Copyright © 2016年 com.lvesli. All rights reserved.
//  带有箭头的默认刷新header

import UIKit
open class LLRefreshNormalHeader: LLRefreshStateHeader {
    var activityIndicatorViewStyle: UIActivityIndicatorViewStyle = .gray{
        didSet{
            setNeedsLayout()
        }
    }
    fileprivate lazy var arrowView: UIImageView = {
        let image = Bundle.main.ll_arrowImage
        let arrowView = UIImageView(image: image)
        self.addSubview(arrowView)
        return arrowView
    }()
    fileprivate lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(activityIndicatorStyle: self.activityIndicatorViewStyle)
        loadingView.hidesWhenStopped = true
        self.addSubview(loadingView)
        return loadingView
    }()
    //MARK: -  集成父类方法
    override open func placeSubViews() {
        super.placeSubViews()
       //箭头位置
        var arrowCentereX = ll_w*0.5
        if !stateLabel.isHidden {  //提示问题没有隐藏
            let stateWidth = stateLabel.ll_textWidth
            var timeWidth:CGFloat = 0
            if !lastUpdatedTimeLabel.isHidden {
                timeWidth = lastUpdatedTimeLabel.ll_textWidth
            }
            let textWidth = max(stateWidth, timeWidth)
            arrowCentereX -= textWidth/2 + labelLeftInset
        }
        let arrowCenterY = ll_h * 0.5
        let arrowCenter = CGPoint(x: arrowCentereX, y: arrowCenterY)
        if arrowView.constraints.count == 0 {
            arrowView.ll_size = arrowView.image?.size ?? CGSize.zero
            arrowView.center = arrowCenter
        }
        // 圈圈
        if (loadingView.constraints.count == 0) {
            loadingView.center = arrowCenter
        }

        arrowView.tintColor = stateLabel.textColor
    }
    override open func setState(_ state: LLRefreshState) {
        let old = refreshState
        super.setState(state)
        if state == .normal {
            
            if old == .refreshing {
                arrowView.transform = CGAffineTransform.identity
                
                UIView.animate(withDuration: LLConstant.AnimationDuration, animations: {
                    self.loadingView.alpha = 0
                }, completion: { (finished) in
                    guard self.refreshState == .normal else {
                        return
                    }
//                    self.loadingView.alpha = 1
                    self.arrowView.isHidden = false
                })
            }else {
                loadingView.stopAnimating()
                arrowView.isHidden = false
                UIView.animate(withDuration: LLConstant.AnimationDuration, animations: {
                    self.arrowView.transform = CGAffineTransform.identity
                })
            }
        }else if state == .pulling {
            loadingView.stopAnimating()
            arrowView.isHidden = false
            UIView.animate(withDuration: LLConstant.AnimationDuration, animations: {
                self.arrowView.transform = CGAffineTransform(rotationAngle: 0.000001-CGFloat(M_PI))
            })
        }else if state == .refreshing {
            loadingView.alpha = 1
            loadingView.startAnimating()
            arrowView.isHidden = true
        }
    }
}
