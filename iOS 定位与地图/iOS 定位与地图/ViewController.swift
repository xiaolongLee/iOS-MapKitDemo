//
//  ViewController.swift
//  iOS 定位与地图
//
//  Created by Mac-Qke on 2019/6/19.
//  Copyright © 2019 Mac-Qke. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
     //地图 很多属性都在SB中配置了
    @IBOutlet weak var map: MKMapView!
    lazy var manager:CLLocationManager  = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        showUserInfo()
    }
    
    // 如果想显示用户的位置 只需要下面三行代码
    func showUser() {
        manager.requestAlwaysAuthorization()
        map.userTrackingMode = MKUserTrackingMode.followWithHeading
        map.showsUserLocation = true
        
    }
    
    // 改变用户蓝点点击后的气泡信息
    
    func showUserInfo() {
        
        map.delegate = self
        showUser()
    }
    
    //点击地图的任一位置 都可以插入一个标注，标注的标题和副标题显示的是具体位置
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //点击屏幕产生的坐标如何与地图的经纬度进行转换？
        
        //1.获取点击的坐标
        var  touchPoint: CGPoint = CGPoint()
        if let touch = touches.first {
           touchPoint = touch.location(in: self.map)
        }
        
        //2.将点击的坐标转换成经纬度
        
        let coordinate : CLLocationCoordinate2D = map.convert(touchPoint , toCoordinateFrom: map)
        
        //3.添加标注
        
        let  annotation : MyAnnotation = MyAnnotation()
        
        annotation.coordinate = coordinate
        
        map.addAnnotation(annotation as! MKAnnotation)
        
    }
    
    
    

}


extension ViewController : MKMapViewDelegate {
    
    //通过代理改变userLocation的标题实现更改信息
    //如何通过定位到的位置 设置地图的“缩放级别”?
    //通过设置地图的MKCoordinateRegion达到
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        let location = userLocation.location
        
        let geocoder = CLGeocoder()
        
        if let location = location {
            geocoder.reverseGeocodeLocation(location) { (placeMarks, error) in
                
                let placeMark = placeMarks?.first
                userLocation.title = placeMark?.locality
                
                userLocation.subtitle = placeMark?.thoroughfare
            }
        }
        
        //设置地图显示的“区域”
        
         //跨度，通过这个精细控制显示的地图视角
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.003,longitudeDelta: 0.003)
        
        //区域
        let region : MKCoordinateRegion = MKCoordinateRegion(center: location!.coordinate,span: span)
        
        //让地图显示设置的区域
        map.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
         //判断是不是用户的数据模型 让用户位置的标注不一样
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
          //1.从重用池取
        var annotationView : MKPinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as! MKPinAnnotationView
        
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: identifier)
        }
        
        //设置标注的图片
        let i  = arc4random() % 11
        
        let  imgName = NSString.init(format: "icon_map_cateid_%d", i)
        
        annotationView.image = UIImage.init(named: imgName as String)
        
        //左边视图
        annotationView.leftCalloutAccessoryView = UIImageView.init(image: UIImage.init(named: "left"))
        
        //右边视图
         annotationView.leftCalloutAccessoryView = UIImageView.init(image: UIImage.init(named: "right"))
        
        annotationView.canShowCallout = true
        
        return annotationView
    }
    
    
   
    
    
    
}

