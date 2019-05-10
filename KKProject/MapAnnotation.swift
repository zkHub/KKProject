//
//  MapAnnotation.swift
//  KKProject
//
//  Created by youplus on 2019/5/10.
//  Copyright © 2019 zhangke. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit



class MapAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D.init()
    var title: String?
    var subTitle: String?
    
    
    
}
