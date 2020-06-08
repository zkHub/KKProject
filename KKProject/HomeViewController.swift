//
//  HomeViewController.swift
//  KKProject
//
//  Created by youplus on 2019/4/3.
//  Copyright © 2019 zhangke. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    
    private let cellReuseIdentifier = "cellReuseIdentifier"
    private var dataDict: NSDictionary?
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.estimatedRowHeight = 0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "HomePage"

        self.tableView.frame = self.view.frame
        self.view.addSubview(self.tableView)
        
        let plistPath = Bundle.main.path(forResource: "ControllerList", ofType: "plist")
        self.dataDict = NSDictionary.init(contentsOfFile: plistPath!)!
        self.tableView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("numberOfSections")
        return (self.dataDict?.allKeys.count)!;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataKey = self.dataDict?.allKeys[section]
        let tempArr = self.dataDict![dataKey!] as! NSArray
        print("numberOfRowsInSection" + "\(section)")
        return tempArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView .dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let str = self.getItem(indexPath)
        cell.textLabel?.text = "\(str)"
        print("cellForRowAt" + "\(indexPath)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        let str = self.self.getItem(indexPath)
        print("\(str)")
        
        let dataKey = self.dataDict?.allKeys[indexPath.section] as! String
        let selectClass: UIViewController.Type?
        if dataKey == "OC" {
            selectClass = NSClassFromString(str) as? UIViewController.Type
        } else {
            // swift由字符串转为类型的时候,如果类型是自定义的,需要在类型字符串前边加上你的项目的名字
            let productName = Bundle.main.infoDictionary!["CFBundleName"] as! String
            selectClass = NSClassFromString("\(productName)."+str) as? UIViewController.Type
        }
        if selectClass != nil {
            let vc = selectClass!.init()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.showAlert(title: "提示", message: "未发现相关控制器", preferredStyle: .alert)
        }
        
    }
    
    
    func getItem(_ indexPath: IndexPath) -> String {
        let dataKey = self.dataDict?.allKeys[indexPath.section]
        let tempArr = self.dataDict![dataKey!] as! NSArray
        let itemStr = tempArr[indexPath.row] as! String
        return itemStr
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dataKey = self.dataDict?.allKeys[section] as! String
        return dataKey
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("heightForRowAt" + "\(indexPath)")
        return 50
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for (num, cell) in self.tableView.visibleCells.enumerated() {
            if num == 0 {
                cell.backgroundColor = .red
            } else {
                cell.backgroundColor = .white
            }
        }
    }
    
}
