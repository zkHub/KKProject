//
//  CustomMapVC.swift
//  KKProject
//
//  Created by youplus on 2019/5/9.
//  Copyright © 2019 zhangke. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class CustomMapVC: BaseViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    lazy var clManager: CLLocationManager = {
        let manager = CLLocationManager.init()
        return manager
    }()
    
    private let markReuseIdentifier = "markReuseIdentifier"
    
    // 加载地图大概是 75M 内存
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "map"
        
        // 默认每当位置改变时LocationManager就调用一次代理。
        // 通过设置distanceFilter可以实现当位置改变超出一定范围时LocationManager才调用相应的代理方法。这样可以达到省电的目的。
        self.clManager.distanceFilter = 20
        //精度
        self.clManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // MARK: - 允许后台定位
        //第一种：能后台定位但是会在顶部出现大蓝条（打开后台定位的开关）
//        self.clManager.allowsBackgroundLocationUpdates = true
//        self.clManager.requestWhenInUseAuthorization()
        //第二种：能后台定位并且不会出现大蓝条
        self.clManager.requestAlwaysAuthorization()
        
        self.mapView.delegate = self
        self.mapView.userTrackingMode = .followWithHeading
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if touches.first?.view?.isKind(of: MKAnnotationView.self) ?? false {
            print("MKAnnotationView-Click")
            return
        }
        
        
        if let touchPoint = touches.first?.location(in: self.mapView) {
            
            let coordinate = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
            let annotation = MapAnnotation.init()
            annotation.coordinate = coordinate
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotation(annotation)
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

extension CustomMapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print("\(userLocation)")
        if let location = userLocation.location {
            
            // MARK: -改变userLocation的标题实现更改信息
            let geocoder = CLGeocoder.init()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if error != nil {
                    print(String(describing: error))
                } else {
                    let placemark: CLPlacemark = placemarks![0]
                    userLocation.title = placemark.name
                    userLocation.subtitle = String(describing: placemark.locality) + String(describing: placemark.subLocality)
                }
            }
            
            // MARK: -跨度，通过这个精细控制显示的地图视角
            let span = MKCoordinateSpan.init(latitudeDelta: 0.003, longitudeDelta: 0.003)
            let region = MKCoordinateRegion.init(center: location.coordinate, span: span)
            // MARK: -设置地图显示的 区域
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
        print(String(describing: error))
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        } else {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: markReuseIdentifier)
            if annotationView == nil {
                annotationView = MKAnnotationView.init(annotation: annotation, reuseIdentifier: markReuseIdentifier)
            }
            annotationView?.image = UIImage.init(named: "like")

            return annotationView
        }
    }
    

    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        UIView.animate(withDuration: 1, delay: 0, options: .repeat, animations: {
            view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { (b) in
            
        }
    }
    
    
}


extension CustomMapVC: CLLocationManagerDelegate {
    
}
