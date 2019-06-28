//
//  AnimationVC.swift
//  KKProject
//
//  Created by youplus on 2019/5/13.
//  Copyright © 2019 zhangke. All rights reserved.
//

import UIKit

class AnimationVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.view.addGestureRecognizer(tap)
        
        
        let path = UIBezierPath(arcCenter: self.view.center, radius: 100, startAngle: .pi * 3/2, endAngle: .pi * 2, clockwise: true)
        path.addArc(withCenter: self.view.center, radius: 100, startAngle: 0, endAngle: .pi * 3/2, clockwise: true)
        
        for i in 1...5 {
            
            let point = self.calcCircleCoordinate(self.view.center, .pi * (1.0/2 + Float(i) * 4.0/5), CGFloat(100))
            path.addLine(to: point)
        }
        
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.black.cgColor
        self.view.layer.addSublayer(layer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 2
        layer.add(animation, forKey: "")
        
    }
    
    
    func calcCircleCoordinate(_ center: CGPoint, _ angle: Float, _ radius: CGFloat) -> CGPoint {
        let x2 = radius * CGFloat(cosf(angle))
        let y2 = radius * CGFloat(sinf(angle))
        return CGPoint(x: center.x+x2, y: center.y-y2)
    }
    
    
    @objc func tapAction(_ tapGesture: UITapGestureRecognizer) {
        
        let point = tapGesture.location(in: self.view)
        let image =  UIImage(named: "like")
        let imageView = UIImageView(image:image)
        imageView.frame = CGRect(x: point.x - (image?.size.width)! / 2, y: point.y - (image?.size.height)!, width: (image?.size.width)!, height: (image?.size.height)!)
        self.view.addSubview(imageView)
        
        let angles = [.pi/8, 0.0, .pi * 15/8]
        let i = Int(arc4random() % 3)
        
        imageView.transform = CGAffineTransform(rotationAngle: CGFloat(angles[i])).concatenating(CGAffineTransform(scaleX: 1, y: 1))
        
        UIView.animate(withDuration: 0.5, animations: {
            
            imageView.transform = CGAffineTransform(rotationAngle: CGFloat(angles[i])).concatenating(CGAffineTransform(scaleX: 5, y: 5))
            imageView.alpha = 0
            
        }) { (true) in
            imageView.removeFromSuperview()
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
