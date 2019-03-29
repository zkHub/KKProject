//
//  WKWebViewController.swift
//  KKProject
//
//  Created by youplus on 2019/3/29.
//  Copyright © 2019 zhangke. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewController: KKBaseViewController {
    
    @objc var urlStr: String = ""
    
    //MARK:-lazy
    lazy var webView: WKWebView = {
        let view = WKWebView.init(frame: self.view.frame)
        view.backgroundColor = UIColor.white
        view.navigationDelegate = self
        view.uiDelegate = self
        return view
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.webView)
        let webUrl = URL.init(fileURLWithPath: urlStr)
//        self.webView.load(URLRequest.init(url: webUrl))
        let accessURL = URL.init(fileURLWithPath: urlStr).deletingLastPathComponent()
        self.webView.loadFileURL(webUrl, allowingReadAccessTo: accessURL)
        
        // Do any additional setup after loading the view.
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

// MARK: -WKNavigationDelegate
extension WKWebViewController: WKNavigationDelegate {
    
}

// MARK: -WKUIDelegate
extension WKWebViewController: WKUIDelegate {
    
}
