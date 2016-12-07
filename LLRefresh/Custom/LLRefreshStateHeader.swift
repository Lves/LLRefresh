//
//  LLRefreshStateHeader.swift
//  LLRefrsh
//
//  Created by 李兴乐 on 2016/12/2.
//  Copyright © 2016年 com.wildcat. All rights reserved.
//

import UIKit

class LLRefreshStateHeader: LLRefreshHeader {
    
    lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(14)
        label.autoresizingMask = .FlexibleWidth
        label.backgroundColor = UIColor.clearColor()
        self.addSubview(label)
        return label
    }()
    lazy var lastUpdatedTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(14)
        label.autoresizingMask = .FlexibleWidth
        label.backgroundColor = UIColor.clearColor()
        self.addSubview(label)
        return label
    }()
    
    private var stateTitles:[Int:String] = [:]
    
    var lastUpdatedTimeText:((NSDate?)->())?
    var labelLeftInset:CGFloat = 0
    
    //MARK: -  集成父类方法
    override func placeSubViews() {
        super.placeSubViews()
        guard !stateLabel.hidden else {
            return
        }
        
        if lastUpdatedTimeLabel.hidden {
            stateLabel.frame = bounds
        }else {
            let stateLableH = ll_h*0.5
            if stateLabel.constraints.count == 0 {
                stateLabel.ll_x = 0
                stateLabel.ll_y = 0
                stateLabel.ll_w = ll_w
                stateLabel.ll_h = stateLableH
            }
           
            if lastUpdatedTimeLabel.constraints.count == 0  {
                lastUpdatedTimeLabel.ll_x = 0
                lastUpdatedTimeLabel.ll_y = stateLableH
                lastUpdatedTimeLabel.ll_w = ll_w
                lastUpdatedTimeLabel.ll_h = ll_h - lastUpdatedTimeLabel.ll_y
            }
        }
 
    }
    
    override func prepare() {
        super.prepare()
        // 初始化间距
        labelLeftInset = LLConstant.RefreshLabelLeftInset
        
        setTitle("下拉可以刷新", state: .Normal)
        setTitle("松开立即刷新", state: .Pulling)
        setTitle("正在刷新数据中", state: .Refreshing)
        
        setLastUpdateTimeLable()
    }
    override func setState(state: LLRefreshState) {
        super.setState(state)
        stateLabel.text = stateTitles[refreshState.rawValue]
        setLastUpdateTimeLable()
    }
    //MARK: - Private
    func setLastUpdateTimeLable() {
        guard !lastUpdatedTimeLabel.hidden else {
            return
        }
        //外部自定义
        if let lastUpdatedTimeText = lastUpdatedTimeText {
            lastUpdatedTimeText(lastUpdateTime)
            return
        }
        if let lastUpdateTime = lastUpdateTime {
            var calendar:NSCalendar?
            if NSCalendar.respondsToSelector(#selector(NSCalendar.init(identifier:))) {
                 calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
            }
            calendar = NSCalendar.currentCalendar()
//            let calendarUnit =
            
            let cmp1 = calendar?.components([NSCalendarUnit.Year, NSCalendarUnit.Month , NSCalendarUnit.Day ,NSCalendarUnit.Hour ,NSCalendarUnit.Minute], fromDate:lastUpdateTime)
            let cmp2 = calendar?.components([NSCalendarUnit.Year, NSCalendarUnit.Month , NSCalendarUnit.Day ,NSCalendarUnit.Hour ,NSCalendarUnit.Minute], fromDate: NSDate())
            
            
            //格式化
            let dateForamt = NSDateFormatter()
            var isToday = false
            if cmp1?.day == cmp2?.day {  //today
                dateForamt.dateFormat = " HH:mm"
                isToday = true
            }else if cmp1?.year == cmp2?.year {  //today
                dateForamt.dateFormat = "MM-dd HH:mm"
            }else if cmp1?.year == cmp2?.year {  //today
                dateForamt.dateFormat = "yyyy-MM-dd HH:mm"
            }
            let time = dateForamt.stringFromDate(lastUpdateTime)
            
            let str = isToday ? "今天" : ""
            
            lastUpdatedTimeLabel.text = "最后更新：\(str)\(time)"
            
            
        }else {     //第一次刷新
            lastUpdatedTimeLabel.text = "最后更新：无记录"
        }
        
        
    }
    
    //MARK: - Public 
    func setTitle(title:String?, state:LLRefreshState)  {
        if let title = title {
            stateTitles[state.rawValue] = title
            stateLabel.text = stateTitles[refreshState.rawValue]
        }
    }
    
   

}
