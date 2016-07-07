//
//  ViewController.swift
//  SwiftWeather
//
//  Created by wossoneri on 16/4/24.
//  Copyright © 2016年 wossoneri. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {

    // create CLLocationManger object
    let locationManager: CLLocationManager = CLLocationManager()
    
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loading: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.loadingIndicator.startAnimating()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest//init
        

        
        let background: UIImage = UIImage(named: "bg")!
        self.view.backgroundColor = UIColor(patternImage: background)
        
        
        
        if (ios8()) {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.startUpdatingLocation()
        
    }
    
    func ios8() -> Bool {
        switch UIDevice.currentDevice().systemVersion.compare("8.0.0", options: NSStringCompareOptions.NumericSearch) {
        case .OrderedSame, .OrderedDescending:
            print("iOS >= 8.0")
            return true
        case .OrderedAscending:
            print("iOS < 8.0")
            return false
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            
            updateWeatherInfo(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
        self.loading.text = "地理位置信息不可用"
    }
    
    
    
    func updateWeatherIcon(condition: Int, nightTime: Bool) -> Void {
        if condition < 300 {
            if nightTime {
                self.icon.image = UIImage(named: "tstorm1_night")
            }
            else {
                self.icon.image = UIImage(named: "tstorm1")
            }
        }
        
        else if condition < 500 {
            self.icon.image = UIImage(named: "light_rain")
        }
        else if condition < 600 {
            self.icon.image = UIImage(named: "shower3")
        }
        else if condition < 700 {
            self.icon.image = UIImage(named: "snow4")
        }
        else if condition < 771 {
            if nightTime {
                self.icon.image = UIImage(named: "fog_night")
            }
            else {
                self.icon.image = UIImage(named: "fog")
            }
        }
        else if condition < 800 {
            self.icon.image = UIImage(named: "tstorm3")
        }
        else if condition == 800 {
            if nightTime {
                self.icon.image = UIImage(named: "sunny_night")
            }
            else {
                self.icon.image = UIImage(named: "sunny")
            }
        }
        else if condition < 804 {
            if nightTime {
                self.icon.image = UIImage(named: "cloudy2_night")
            }
            else {
                self.icon.image = UIImage(named: "cloudy2")
            }
        }
        else if condition == 804 {
            self.icon.image = UIImage(named: "overcast")
        }
        else if (condition >= 900 && condition < 903) || (condition > 904 && condition < 1000) {
            self.icon.image = UIImage(named: "tstorm3")
        }
        else if condition == 903 {
            self.icon.image = UIImage(named: "snow5")
        }
        else if condition == 904 {
            self.icon.image = UIImage(named: "sunny")
        }
        else {
            self.icon.image = UIImage(named: "dunno")
        }
    }
    
    func updateWeatherInfo(latitude latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> Void {
        let manager = AFHTTPRequestOperationManager()
        let url = "http://api.openweathermap.org/data/2.5/weather"
        
        let params = ["lat": latitude, "lon": longitude, "cnt": 0, "appid": "4f4be8fe7031dddd5dec789e01c1b3ac"]
        
        manager.GET(url,
                    parameters: params,
                    success: {(operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in print("JSON: " + responseObject.description!)
                        
                        self.updateUISuccess(responseObject as! NSDictionary)
            },
                    failure: {(operation: AFHTTPRequestOperation!, error: NSError!) in print("Error: " + error.localizedDescription)})
        
        
    }
    
    func updateUISuccess(jsonResult: NSDictionary!) -> Void {
        self.loadingIndicator.hidden = true
        self.loadingIndicator.stopAnimating()
        self.loading.text = nil
        
        if let tempResult = (jsonResult["main"] as? NSDictionary )? ["temp"] as? Double {
            
            var temperature: Double
            if (jsonResult["sys"] as? NSDictionary)? ["country"] as? String == "US" {
                temperature = round(((tempResult - 273.15) * 1.8) + 32)
            } else {
                temperature = round(tempResult - 273.15)
            }
            
            self.temperature.text = "\(temperature)°"
            self.temperature.font = UIFont.boldSystemFontOfSize(65)
            
            let name: String = (jsonResult["name"] as? String)!
            self.location.font = UIFont.boldSystemFontOfSize(25)
            self.location.text = "\(name)"
            
            let condition = (jsonResult["weather"] as? NSArray)? [0]["id"] as? Int
            let sunrise = (jsonResult["sys"] as? NSDictionary)? ["sunrise"] as? Double
            let sunset = (jsonResult["sys"] as? NSDictionary)? ["sunset"] as? Double
            
            var nightTime = false
            let now = NSDate().timeIntervalSince1970
            
            if now < sunrise || now > sunset {
                nightTime = true
            }
            self.updateWeatherIcon(condition!, nightTime: nightTime)
            
        } else {
            self.loading.text = "Data unavaliable"
        }
    }
    
}

