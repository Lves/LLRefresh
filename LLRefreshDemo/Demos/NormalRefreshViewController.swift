//
//  NormalRefreshViewController.swift
//  LLRefreshDemo
//
//  Created by lixingle on 2017/3/7.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit
import LLRefresh
class NormalRefreshViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataArray:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        //1.0 set header & footer by block
        setRefreshByBlock()
        //2.0 set header & footer by target
        //        setRefreshByTarget()
        tableView.ll_header?.beginRefreshing()
        
    }
    
    //MARK: Block实现方式
    func setRefreshByBlock(){
        //1.0
        tableView.ll_header = LLRefreshNormalHeader(refreshingBlock: {[weak self] _ in
            self?.loadNewData()
        })
        tableView.ll_footer = LLRefreshAutoNormalFooter(refreshingBlock: { [weak self] _ in
            self?.loadMoreDate()
        })
    }
    
    //MARK: Target实现方式
    func setRefreshByTarget(){
        tableView.ll_header = LLRefreshNormalHeader(target: self, action: #selector(loadNewData))
        tableView.ll_footer = LLRefreshAutoNormalFooter(target: self, action: #selector(loadMoreDate))
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
    func loadMoreDate()  {
        //update data
        let format = DateFormatter()
        format.dateFormat = "HH:mm:ss"
        for _ in 0...2 {
            dataArray.append(format.string(from: Date()))
        }
        sleep(2)
        //end refreshing
        tableView.ll_footer?.endRefreshing()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        var cell =  tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        
        cell?.textLabel?.text = dataArray[indexPath.row]
        return cell!
    }

}
