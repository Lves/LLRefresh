//
//  LLRefreshGifHeader.swift
//  LLRefreshDemo
//
//  Created by lixingle on 2017/1/22.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit

class LLRefreshGifHeader: LLRefreshStateHeader {
    lazy var gifView: UIImageView = {
        let gifView = UIImageView()
        self.addSubview(gifView)
        return gifView
    }()
    var stateImages: [LLRefreshState: [UIImage]] = [:]
    var stateDurations: [LLRefreshState: TimeInterval] = [:]
    
    override var _pullingPercent:CGFloat {
        didSet{
            guard !isRefreshing else {
                return
            }
            
            let images = self.stateImages[.normal]
            if refreshState != .normal || images?.count == 0 {
                return
            }
            self.gifView.stopAnimating()
            //设置当前图片
            var index = Int(CGFloat(images?.count ?? 0) * _pullingPercent)
            if index >= (images?.count)! {
                index = (images?.count)! - 1
            }
            print("_pullingPercent: \(_pullingPercent) - imageIndex: \(index)")
            self.gifView.image = images?[index]
        }
    }
    
    //MARK: - Public
    func setImages(images: [UIImage]?, state: LLRefreshState, duration: TimeInterval? = -1)  {
        
        guard let imgs = images , imgs.count > 0 else {
            return
        }
        self.stateImages[state] = imgs
        
        let time = Double(duration!) < 0.0 ? Double(imgs.count) * 0.1 : duration
        
        self.stateDurations[state] = time
        let firstImage = imgs.first
        if (firstImage?.size.height ?? 0) > self.ll_h {
            self.ll_h = firstImage?.size.height ?? 0
        }
    }
    
    //MARK: - Parents fucntion
    
    override func prepare() {
        super.prepare()
        labelLeftInset = 20
    }
    override func placeSubViews() {
        super.placeSubViews()
        guard gifView.constraints.count == 0 else {
            return
        }
        gifView.frame = self.bounds
        if stateLabel.isHidden && lastUpdatedTimeLabel.isHidden {
            gifView.contentMode = .center
        } else {
            gifView.contentMode = .bottomRight
            let stateW = stateLabel.ll_textWidth
            var timeW:CGFloat = 0
            if !lastUpdatedTimeLabel.isHidden {
                timeW = lastUpdatedTimeLabel.ll_textWidth
            }
            let textW = max(stateW, timeW)
            gifView.ll_w = ll_w * 0.5 - textW * 0.5 - labelLeftInset
        
        }
    }
   
    override func setState(_ state: LLRefreshState) {
        super.setState(state)
        if state == .pulling || state == .refreshing {
            let images = stateImages[state]
            guard let imgs = images , imgs.count > 0 else {
                return
            }
            gifView.stopAnimating()
            if imgs.count == 1 { //1张
                gifView.image = imgs.first
            }else { //多张
                gifView.animationImages = imgs
                gifView.animationDuration = stateDurations[state] ?? 0
                gifView.startAnimating()
            }
        }else {
            gifView.stopAnimating()
        }
    }

    

}
