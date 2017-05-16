//
//  CustomRefreshTableViewController.swift
//  LLRefreshDemo
//
//  Created by lixingle on 2017/5/16.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit
import LLRefresh
class CustomRefreshTableViewController: UITableViewController {

    var dataArray:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        let header = LLCustomHeader(refreshingBlock: {[weak self] _ in
            self?.loadNewData()
        })
        tableView.ll_header = header
        tableView.ll_header?.beginRefreshing()
        
    }
    func loadNewData()  {
        //update data
        let format = DateFormatter()
        format.dateFormat = "HH:mm:ss"
        for _ in 0...2 {
            dataArray.insert(format.string(from: Date()), at: 0)
        }
        sleep(2)
        //end refreshing
        tableView.ll_header?.endRefreshing()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell =  tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        cell?.textLabel?.text = dataArray[indexPath.row]
        return cell!
    }


}
