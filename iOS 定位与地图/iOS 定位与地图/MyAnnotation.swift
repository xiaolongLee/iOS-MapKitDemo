//
//  MyAnnotation.swift
//  iOS 定位与地图
//
//  Created by Mac-Qke on 2019/6/19.
//  Copyright © 2019 Mac-Qke. All rights reserved.
//

import UIKit

import MapKit


class MyAnnotation {
    /**
     *  大头针的位置
     */
    var _coordinate : CLLocationCoordinate2D?
    
    var coordinate :  CLLocationCoordinate2D? {
        set{
            _coordinate  =  newValue
        }

        get {
           return _coordinate
        }
    }
    /**
     *  主标题
     */
     var title : NSString?
    
    /**
     *  副标题
     */
    
     var subTitle : NSString?
    

}

extension  MKAnnotation {
    
    
}
