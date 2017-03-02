//
//  LLRefreshAutoGifFooter.swift
//  LLRefreshDemo
//
//  Created by lixingle on 2017/3/2.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit

class LLRefreshAutoGifFooter: LLRefreshAutoStateFooter {
    lazy var gifView: UIImageView = {
        let gifView = UIImageView()
        self.addSubview(gifView)
        return gifView
    }()
    var stateImages: [LLRefreshState: [UIImage]] = [:]
    var stateDurations: [LLRefreshState: TimeInterval] = [:]
    
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
        if refreshingTitleHidden {
            gifView.contentMode = .center
        } else {
            gifView.contentMode = .bottomRight
            let stateW = stateLabel.ll_textWidth
            gifView.ll_w = ll_w * 0.5 - stateW * 0.5 - labelLeftInset
            
        }
    }
    
    override func setState(_ state: LLRefreshState) {
        super.setState(state)
        if state == .refreshing {
            let images = stateImages[state]
            guard let imgs = images , imgs.count > 0 else {
                return
            }
            gifView.stopAnimating()
            gifView.isHidden = false
            if imgs.count == 1 { //1张
                gifView.image = imgs.first
            }else { //多张
                gifView.animationImages = imgs
                gifView.animationDuration = stateDurations[state] ?? 0
                gifView.startAnimating()
            }
        }else if state == .noMoreData || state == .normal{
            gifView.stopAnimating()
            gifView.isHidden = true
        }
    }

    
}
