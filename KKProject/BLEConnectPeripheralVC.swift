//
//  BLEConnectPeripheralVC.swift
//  KKProject
//
//  Created by youplus on 2019/4/29.
//  Copyright © 2019 zhangke. All rights reserved.
//

import UIKit
import CoreBluetooth
import SnapKit

class BLEConnectPeripheralVC: BaseViewController {
    
    @IBOutlet weak var infoTableView: UITableView!
    
    var peripheral: CBPeripheral?
    private var characteristic: CBCharacteristic?
    
    var serviceCount = 0
    
    private let cellReuseIdentifier = "cellReuseIdentifier"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Peripheral"
        
        self.peripheral?.delegate = self
        self.peripheral?.discoverServices(nil)

        // Do any additional setup after loading the view.
    }


    override func viewDidAppear(_ animated: Bool) {
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


extension BLEConnectPeripheralVC: CBPeripheralDelegate {
    
    // MARK: -CBPeripheralDelegate
    
    /** 发现服务 */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service: CBService in peripheral.services! {
            serviceCount += 1
            print("外设中的服务有：\(service)")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    /** 发现特征 */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic: CBCharacteristic in service.characteristics! {
            print("外设中的特征有：\(characteristic)")
        }
        serviceCount -= 1
        
        if serviceCount == 0 {
            self.infoTableView.reloadData()
        }
        

        
    }
    
    /** 订阅状态 */
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("订阅失败: \(error)")
            return
        }
        if characteristic.isNotifying {
            print("订阅成功")
        } else {
            print("取消订阅")
        }
    }
    
    /** 接收到数据 */
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let data = characteristic.value {
            let str = String.init(data: data, encoding: String.Encoding.utf8)
            print("value-\(str ?? error.debugDescription)")
        } else {
            print("error-\(error.debugDescription)")
        }

    }
    
    /** 写入数据 */
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if error == nil {
            print("写入数据成功")
        } else {
            print("error-\(String(describing: error))")
        }
    }
    
    
}


extension BLEConnectPeripheralVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.peripheral?.services?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let service = self.peripheral?.services![section]
        return service?.characteristics?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        if cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: cellReuseIdentifier)
        }
        
        let service = self.peripheral?.services![indexPath.section]
        let character = service?.characteristics![indexPath.row]
        cell?.textLabel?.text = "\t" + (character?.description ?? "")
        cell?.textLabel?.numberOfLines = 0
        
        var str = "null"
        if let data = character!.value {
            str = String.init(data: data, encoding: String.Encoding.utf8) ?? String(describing: data)
        }
        cell?.detailTextLabel?.text = str
        return cell!
    }
    
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let service = self.peripheral?.services![section]
//        return service?.description
//    }
//
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        let headerView = view as! UITableViewHeaderFooterView
//        headerView.textLabel?.numberOfLines = 0
//        let service = self.peripheral?.services![section]
//        headerView.textLabel?.text = service?.description
//
//    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init()
        
        let textLbl = UILabel.init()
        textLbl.numberOfLines = 0
        textLbl.font = UIFont.systemFont(ofSize: 15)
        let service = self.peripheral?.services![section]
        textLbl.text = service?.description
        
        headerView.addSubview(textLbl)
        textLbl.snp.makeConstraints { (make) in
            make.edges.equalTo(headerView).inset(UIEdgeInsets.init(top: 5, left: 15, bottom: 5, right: 15))
        }
        
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let service = self.peripheral?.services![indexPath.section]
        let character = service?.characteristics![indexPath.row]
        
        // 读取特征里的数据
        self.peripheral!.readValue(for: character!)
        // 订阅
        self.peripheral!.setNotifyValue(true, for: character!)
        
    }
    
}
