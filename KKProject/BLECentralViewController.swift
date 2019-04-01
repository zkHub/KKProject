//
//  BLECentralViewController.swift
//  KKProject
//
//  Created by youplus on 2019/4/1.
//  Copyright © 2019 zhangke. All rights reserved.
//

import UIKit
import CoreBluetooth



private let Service_UUID = "CDD1"
private let Characteristic_UUID = "CDD2"



class BLECentralViewController: KKBaseViewController {

    private var characteristic: CBCharacteristic?
    
    lazy private var peripheralManager: CBPeripheralManager = {
        let pm = CBPeripheralManager.init(delegate: self, queue: .main)
        return pm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "BLE-Peripheral"
        
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



extension BLECentralViewController: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
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
            
        default:
            print("error")
        }
    }
    
    /** 创建服务和特征
     注意swift中枚举的按位运算 '|' 要用[.read, .write, .notify]这种形式
     */
    private func setupServiceAndCharacteristic() {
        let serviceID = CBUUID.init(string: Service_UUID)
        let service = CBMutableService.init(type: serviceID, primary: true)
        let characteristicID = CBUUID.init(string: Characteristic_UUID)
        let characteristic = CBMutableCharacteristic.init(type: characteristicID, properties: [.read, .write, .notify], value: nil, permissions: [.readable, .writeable])
        service.characteristics = [characteristic]
        self.peripheralManager.add(service)
        self.characteristic = characteristic
    }
    
    /** 中心设备读取数据的时候回调 */
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        let str = "respond"
        request.value = str.data(using: .utf8)
        peripheral.respond(to: request, withResult: .success)
    }
    
    /** 中心设备写入数据 */
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        let request = requests.last!
//        let str = String.init(data: request.value!, encoding: .utf8)
        print("\(String(describing: request.value))")
    }
    
    /** 订阅成功回调 */
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("\(#function) 订阅成功回调")
    }
    
    /** 取消订阅回调 */
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        print("\(#function) 取消订阅回调")
    }
    
}
