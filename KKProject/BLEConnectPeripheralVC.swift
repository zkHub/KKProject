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
    
    var centralManager: CBCentralManager?
    var peripheral: CBPeripheral?
//    private var characteristic: CBCharacteristic?
    
    var serviceCount = 0
    
    private let cellReuseIdentifier = "cellReuseIdentifier"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.peripheral?.name ?? "Peripheral"
        
        self.peripheral?.delegate = self
        self.peripheral?.discoverServices(nil)

        // Do any additional setup after loading the view.
    }

    deinit {
        if self.peripheral != nil {
            self.centralManager?.cancelPeripheralConnection(self.peripheral!)
        }
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
        str.append("\nProperty:")
        if character!.properties.contains(.read) {
            str.append("read ")
        }
        if character!.properties.contains(.write) {
            str.append("write ")
        }
        if character!.properties.contains(.notify) {
            str.append("notify ")
        }
        cell?.detailTextLabel?.text = str
        cell?.detailTextLabel?.numberOfLines = 0
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
        if self.peripheral?.state == .connected {
            let service = self.peripheral?.services?[indexPath.section]
            let character = service?.characteristics?[indexPath.row]
            
            let interactVC = BLECentralInteractVC.init()
            interactVC.peripheral = self.peripheral
            interactVC.characteristic = character
            self.navigationController?.pushViewController(interactVC, animated: true)
        } else {
            self.showAlert(title: nil, message: "设备未连接", preferredStyle: .alert)
        }
        
        
    }
    
}
