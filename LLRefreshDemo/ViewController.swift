//
//  ViewController.swift
//  LLRefreshDemo
//
//  Created by 李兴乐 on 2016/12/3.
//  Copyright © 2016年 com.lvesli. All rights reserved.
//

import UIKit



extension UIViewController{
    class func instanceViewControllerInStoryboardWithName(_ name: String, storyboardName: String? = "Main") -> UIViewController? {
        if let storyboardName = storyboardName, storyboardName.ll_length > 0 {
            let story =  UIStoryboard(name: storyboardName, bundle: nil)
            if (story.value(forKey: "identifierToNibNameMap") as AnyObject).object(forKey: name) != nil {
                return story.instantiateViewController(withIdentifier: name)
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

        dataArray = ["StateRefreshViewController",
                     "NormalRefreshViewController",
                     "GifRefreshViewController",
                     "BgImageRefreshViewController",
                     "ArrowRefreshViewController",
                     "CustomRefreshTableViewController"]
    }
    //MARK: delegate&datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell =  tableView.dequeueReusableCell(withIdentifier: "RootCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "RootCell")
        }
        
        cell?.textLabel?.text = dataArray?[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        let vc = UIViewController.instanceViewControllerInStoryboardWithName(dataArray?[indexPath.row] ?? "")
        navigationController?.pushViewController(vc!, animated: true)
    }


}

