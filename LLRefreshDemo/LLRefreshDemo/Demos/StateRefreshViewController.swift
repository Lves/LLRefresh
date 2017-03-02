//
//  StateRefreshViewController.swift
//  LLRefreshDemo
//
//  Created by 李兴乐 on 2016/12/3.
//  Copyright © 2016年 com.lvesli. All rights reserved.
//

import UIKit

class StateRefreshViewController: UIViewController {
     @IBOutlet weak var tableView: UITableView!
    var dataArray:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
//        //1.0 Init
//        tableView.ll_header = LLRefreshBGImageHeader(refreshingBlock: {[weak self] _ in
//            sleep(2)
//            //3.0 End refreshing
//            self?.tableView.ll_header?.endRefreshing()
//        })
        tableView.ll_header = LLRefreshBGImageHeader(target: self, action: #selector(loadData))

        //2.0 Stop refreshing
        tableView.ll_header?.beginRefreshing()
        
        
        
        
    }
    func loadData()  {
        
        sleep(2)
        //3.0 End refreshing
        tableView.ll_header?.endRefreshing()
    }



    // MARK: - Table view data source

    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 5
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
