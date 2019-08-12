//
//  ScrollViewVC.swift
//  KKProject
//
//  Created by 张柯 on 2019/7/11.
//  Copyright © 2019 zhangke. All rights reserved.
//

import UIKit

class ScrollViewVC: BaseViewController {

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 64, width: self.view.bounds.size.width, height: self.view.bounds.size.height-64))
        scrollView.contentSize = CGSize.init(width: self.view.bounds.size.width, height: self.view.bounds.size.height*3)
        scrollView.delegate = self
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height*3))
        view.backgroundColor = .red
        scrollView.addSubview(view)
//        scrollView.bounces = false
//        scrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 200, right: 200)
        return scrollView
    }()
    var aTimer: Timer?
    var bTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.scrollView)
        
        var count = 0
        var num = 0
        if #available(iOS 10.0, *) {
            aTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { (aTimer) in
                num += 1
                print("num=\(num)")
            }
            
            bTimer = Timer.init(timeInterval: 1, repeats: true) { (bTimer) in
                count += 1
                print("count=\(count)")
            }
            RunLoop.current.add(bTimer!, forMode: .common)
            
        } else {
            // Fallback on earlier versions
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        bTimer!.invalidate()
    }
    
    deinit {
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

extension ScrollViewVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.printOffset(str: "scrollViewDidScroll")
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.printOffset(str: "scrollViewDidZoom")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.printOffset(str: "scrollViewWillBeginDragging")
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.printOffset(str: "scrollViewWillBeginDecelerating")
    }
    
    func printOffset(str:String) {
        print(str + "--\(self.scrollView.contentOffset)")
    }
    
    
}
