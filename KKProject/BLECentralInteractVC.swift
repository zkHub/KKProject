//
//  BLECentralInteractVC.swift
//  KKProject
//
//  Created by youplus on 2019/5/7.
//  Copyright © 2019 zhangke. All rights reserved.
//

import UIKit
import CoreBluetooth



class BLECentralInteractVC: BaseViewController {

    @IBOutlet weak var writeTV: UITextView!
    @IBOutlet weak var writeBtn: UIButton!
    @IBOutlet weak var readTV: UITextView!
    @IBOutlet weak var readBtn: UIButton!
    
    @IBOutlet weak var notifySwitch: UISwitch!
    
    
    var peripheral: CBPeripheral?
    var characteristic: CBCharacteristic?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.peripheral?.delegate = self
        self.setBorder(textView: self.writeTV)
        self.setBorder(textView: self.readTV)
        
        // Do any additional setup after loading the view.
    }

    func setBorder(textView: UITextView) {
        textView.layer.cornerRadius = 5.0
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.masksToBounds = true
    }
    
    
    @IBAction func writeAction(_ sender: Any) {
        
        if self.isConnected() {
            if self.characteristic!.properties.contains(.write) {
                let data = self.writeTV.text.data(using: .utf8)
                self.peripheral?.writeValue(data!, for: self.characteristic!, type: .withResponse)
            } else if self.characteristic!.properties.contains(.writeWithoutResponse) {
                let data = self.writeTV.text.data(using: .utf8)
                self.peripheral?.writeValue(data!, for: self.characteristic!, type: .withoutResponse)
            } else {
                self.showAlert(title: nil, message: "不支持写入", preferredStyle: .alert)
            }
        }
        
    }
    
    
    @IBAction func readAction(_ sender: Any) {
        if self.isConnected() {
            if self.characteristic!.properties.contains(.read) {
                // 读取特征里的数据
                self.peripheral?.readValue(for: self.characteristic!)
            } else {
                self.showAlert(title: nil, message: "不支持读取", preferredStyle: .alert)
            }
        }
       
    }
    

    
    
    @IBAction func switchAction(_ sender: UISwitch) {

        if self.isConnected() {
            if self.characteristic!.properties.contains(.notify) {
                // 订阅
                self.peripheral?.setNotifyValue(!self.characteristic!.isNotifying, for: self.characteristic!)
            } else {
                self.notifySwitch.setOn(false, animated: true)
                self.showAlert(title: nil, message: "不支持订阅", preferredStyle: .alert)
            }
        }
        
        
    }
    
    func isConnected() -> Bool {
        if self.peripheral?.state == .connected {
            return true
        } else {
            self.showAlert(title: nil, message: "设备未连接", preferredStyle: .alert)
            return false
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


extension BLECentralInteractVC: CBPeripheralDelegate {
    /** 订阅状态 */
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        var str = ""
        if let error = error {
            str = "订阅失败: \(error)"
            self.notifySwitch.setOn(false, animated: true)
        } else {
            if characteristic.isNotifying {
                str = "订阅成功"
                self.notifySwitch.setOn(true, animated: true)
            } else {
                str = "取消订阅"
                self.notifySwitch.setOn(false, animated: true)
            }
        }
        self.showAlert(title: nil, message: str, preferredStyle: .alert)

    }
    
    /** 接收到数据 */
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let data = characteristic.value {
            let str = String.init(data: data, encoding: .utf8)
            self.readTV.text = str ?? error.debugDescription
        } else {
            self.readTV.text = "readError-\(String(describing: error))"
        }
        
    }
    
    /** 写入数据 */
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        var str = ""
        if error == nil {
            str = "写入数据成功"
        } else {
            str = "writeError-\(String(describing: error))"
        }
        self.showAlert(title: nil, message: str, preferredStyle: .alert)
    }
}
