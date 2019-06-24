//
//  GeoViewController.swift
//  iOS 定位与地图
//
//  Created by Mac-Qke on 2019/6/19.
//  Copyright © 2019 Mac-Qke. All rights reserved.
//

import UIKit
import CoreLocation
class GeoViewController: UIViewController {

    // //定位需要一个CLLocationManager
    lazy var locationManager:CLLocationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupManqger()
    }
    
    func setupManqger(){
        //默认情况是这样的,每当位置改变时LocationManager就调用一次代理。通过设置distanceFilter可以实现当位置改变超出一定范围时LocationManager才调用相应的代理方法。这样可以达到省电的目的。
        locationManager.distanceFilter = 300
        //精度 比如为10 就会尽量达到10米以内的精度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //代理
        locationManager.delegate = self 
        //第一种：能后台定位但是会在顶部出现大蓝条（打开后台定位的开关）
        //允许后台定位
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestWhenInUseAuthorization()
        //第二种：能后台定位并且不会出现大蓝条
        locationManager.requestAlwaysAuthorization()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //发起位置更新（定位）会一直轮询，耗电
        self.locationManager.startUpdatingLocation()
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


extension GeoViewController : CLLocationManagerDelegate {
    //定位成功
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        //地理编码的类
        let gecoder = CLGeocoder()
        if let location = location {
            //反地理编码 转换成 具体的地址
            gecoder.reverseGeocodeLocation(location) { (placeMarks, error) in
                //CLPlacemark －－ 国家 城市 街道
                let placeMark = placeMarks?.first
                if let placeMark = placeMark {
                    print("\(placeMark.country!) -- \(placeMark.name!) -- \(placeMark.locality!)")
                }
            }
        }
        
        self.locationManager.stopUpdatingLocation()
    }
    
    //定位失败
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
