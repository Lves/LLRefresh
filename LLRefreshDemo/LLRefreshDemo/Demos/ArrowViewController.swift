//
//  ArrowViewController.swift
//  LLRefreshDemo
//
//  Created by 李兴乐 on 2016/12/5.
//  Copyright © 2016年 com.lvesli. All rights reserved.
//

import UIKit

class ArrowViewController: UIViewController{
    var array:[Int] = []

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.tableFooterView = UIView()
        //1.0 Init
        tableView.ll_header = LLRefreshNormalHeader(refreshingBlock: { _ in
            sleep(2)
            let count = self.array.count
            for index in count..<count+5 {
                self.array.append(index)
            }
            
            //3.0 End refreshing
            self.tableView.ll_header?.endRefreshing()
            self.tableView.reloadData()
        })
        //2.0 Stop refreshing
        tableView.ll_header?.beginRefreshing()
        
        self.view.addSubview(tableView)
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell =  tableView.dequeueReusableCellWithIdentifier("Cell")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        }
        
        cell?.textLabel?.text = "\(indexPath.row)"
        return cell!
    }
    




}
