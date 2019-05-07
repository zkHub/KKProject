//
//  BLECentralViewController.swift
//  KKProject
//
//  Created by youplus on 2019/4/1.
//  Copyright © 2019 zhangke. All rights reserved.
//

import UIKit
import CoreBluetooth

class BLECentralViewController: BaseViewController {

    
    private let cellReuseIdentifier = "cellReuseIdentifier"

    lazy private var periArr = NSMutableArray.init()
    
    private var centralManager: CBCentralManager?
    private var peripheral: CBPeripheral?
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "BLE-Central"
        self.centralManager = CBCentralManager.init(delegate: self, queue: .main)
        self.tableView.frame = self.view.frame
        self.view.addSubview(self.tableView)
    }
   
}



extension BLECentralViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.periArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        if cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: cellReuseIdentifier)
        }
        let peri = self.periArr[indexPath.row] as! CBPeripheral
        cell?.textLabel?.text = peri.name ?? "BLE"
        cell?.detailTextLabel?.text = peri.identifier.uuidString
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let peri: CBPeripheral = self.periArr[indexPath.row] as! CBPeripheral
        self.centralManager?.connect(peri, options: nil)
    }
    
}


extension BLECentralViewController: CBCentralManagerDelegate {
    
    // MARK: -CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("unknown")
        case .resetting:
            print("resetting")
        case .unsupported:
            print("unsupported")
        case .unauthorized:
            print("unauthorized")
        case .poweredOff:
            print("poweredOff")
        case .poweredOn:
            print("poweredOn")
            central.scanForPeripherals(withServices: nil, options: nil)
        default:
            print("error")
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("发现外设：\(peripheral.identifier.uuidString)")
        if self.periArr.count > 0 {
            var isContains = false
            for peri in self.periArr {
                if peripheral.identifier == (peri as AnyObject).identifier {
                    isContains = true
                    break
                }
            }
            if !isContains {
                self.periArr.add(peripheral)
                self.tableView.reloadData()
            }
        } else {
            self.periArr.add(peripheral)
            self.tableView.reloadData()
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("连接成功")
        self.centralManager?.stopScan()
        
        self.peripheral = peripheral
        
        let connectPeriVC = BLEConnectPeripheralVC.init()
        connectPeriVC.centralManager = self.centralManager
        connectPeriVC.peripheral = peripheral
        self.navigationController?.pushViewController(connectPeriVC, animated: true)
       
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        self.showAlert(title: nil, message: "连接失败", preferredStyle: .alert)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        self.showAlert(title: nil, message: "断开连接", preferredStyle: .alert)
    }
    
    
    
    
    
}

