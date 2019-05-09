//
//  BaseViewController.swift
//  KKProject
//
//  Created by youplus on 2019/4/3.
//  Copyright © 2019 zhangke. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
    }
    
    func showAlert(title: String?, message: String?, preferredStyle: UIAlertController.Style) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: preferredStyle)
        let action = UIAlertAction.init(title: "确定", style: .default) { (a) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    deinit {
        print("\(self)-deinit")
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
