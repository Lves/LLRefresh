//
//  LLRefreshGifViewController.swift
//  LLRefreshDemo
//
//  Created by lixingle on 2017/1/22.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit

class LLRefreshGifViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var array:[Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.tableFooterView = UIView()
        //1.0 Init
        let header = LLEatHeader(refreshingBlock: { _ in
            sleep(2)
            let count = self.array.count
            for index in count..<count+5 {
                self.array.append(index)
            }
            
            //3.0 End refreshing
            self.tableView.ll_header?.endRefreshing()
            self.tableView.reloadData()
        })
        header.stateLabel.isHidden = true
        header.lastUpdatedTimeLabel.isHidden = true
        tableView.ll_header = header
        //2.0 Stop refreshing
        tableView.ll_header?.beginRefreshing()
        
        //footer
        let footer = LLEatFooter { 
            sleep(2)
            let count = self.array.count
            for index in count..<count+5 {
                self.array.append(index)
            }

            self.tableView.ll_footer?.endRefreshing()
            self.tableView.reloadData()
        }
        tableView.ll_footer = footer
        
        
        
        
        self.view.addSubview(tableView)
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        var cell =  tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        
        cell?.textLabel?.text = "\(indexPath.row)"
        return cell!
    }

    
}
