//
//  BLEConnectPeripheralVC.swift
//  KKProject
//
//  Created by youplus on 2019/4/29.
//  Copyright © 2019 zhangke. All rights reserved.
//

import UIKit
import CoreBluetooth

class BLEConnectPeripheralVC: BaseViewController {
    
    @IBOutlet weak var periTextView: UITextView!
    
    var peripheral: CBPeripheral?
    private var characteristic: CBCharacteristic?
    
    var serviceCount = 0
    var peripheralInfo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.periTextView.text = self.peripheral?.description
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
            peripheralInfo = self.peripheral!.description
            for indexP in 0..<self.peripheral!.services!.count {
                peripheralInfo += "\n\r"
                let service = self.peripheral?.services?[indexP]
                peripheralInfo += service!.description
                
                for indexS in 0..<service!.characteristics!.count {
                    peripheralInfo += "\n\t"
                    let chara = service?.characteristics?[indexS]
                    peripheralInfo += chara!.description
                }
                
            }
            self.periTextView.text = peripheralInfo
        }
        
//        // 读取特征里的数据
//        peripheral.readValue(for: self.characteristic!)
//        // 订阅
//        peripheral.setNotifyValue(true, for: self.characteristic!)
        
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
        let data = characteristic.value
        let str = String.init(data: data!, encoding: String.Encoding.utf8)
        print("value-\(str ?? "error")")
        
        //        let string = "post"
        //        peripheral.writeValue(string.data(using: .utf8)!, for: characteristic, type: .withResponse)
        
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
