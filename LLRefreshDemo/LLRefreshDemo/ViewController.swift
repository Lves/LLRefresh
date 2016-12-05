//
//  ViewController.swift
//  LLRefreshDemo
//
//  Created by 李兴乐 on 2016/12/3.
//  Copyright © 2016年 com.lvesli. All rights reserved.
//

import UIKit

extension String {
    var length: Int {
        return self.characters.count
    }
}

extension UIViewController{
    class func instanceViewControllerInStoryboardWithName(name: String, storyboardName: String? = "Main") -> UIViewController? {
        if let storyboardName = storyboardName where storyboardName.length > 0 {
            let story =  UIStoryboard(name: storyboardName, bundle: nil)
            if story.valueForKey("identifierToNibNameMap")?.objectForKey(name) != nil {
                return story.instantiateViewControllerWithIdentifier(name)
            }
        }
        return nil
    }
}


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var dataArray:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        

//        tableView.contentInset = UIEdgeInsetsMake(80, 0, 0, 0)
//        tableView?.setContentOffset(CGPointMake(0, -80), animated: false)
        
        dataArray = ["StateRefreshViewController","ArrowViewController"]

    }


    //MARK: delegate&datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray?.count ?? 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell =  tableView.dequeueReusableCellWithIdentifier("RootCell")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "RootCell")
        }
        
        cell?.textLabel?.text = dataArray?[indexPath.row]
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)

        
        var vc = UIViewController.instanceViewControllerInStoryboardWithName(dataArray?[indexPath.row] ?? "")
        if indexPath.row == 1 {
            vc = ArrowViewController()
        }
        navigationController?.pushViewController(vc!, animated: true)
    }


}

