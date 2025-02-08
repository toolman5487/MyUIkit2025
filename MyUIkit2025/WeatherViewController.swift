//
//  WeatherViewController.swift
//  MyUIkit2025
//
//  Created by Willy Hsu on 2025/2/6.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var nowHighTempLabel: UILabel!
    @IBOutlet weak var nowLowTempLabel: UILabel!
    @IBOutlet weak var nowWeatherLabel: UILabel!
    @IBOutlet weak var nowTempLabel: UILabel!
    @IBOutlet weak var theTableView: UITableView!
    
    var items = [WeatherList]()
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()  //新增 Geocoder
    
    var nowLat: Double = 0.00
    var nowLon: Double = 00.00
    
    var dayUrlString: String {
        return API_URL(forecast: false, lat: nowLat, lon: nowLon).concatURL
    }
    
    var forecastUrlString: String {
        return API_URL(forecast: true, lat: nowLat, lon: nowLon).concatURL
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theTableView.dataSource = self
        theTableView.delegate = self
        
        //設定 locationManager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // 抓取預設位置的天氣
        fetchItems(forecast: true, urlString: forecastUrlString)
        fetchItems(forecast: false, urlString: dayUrlString)
    }
    
    @IBAction func locationButton(_ sender: UIButton) {
        checkLocationPermission()
    }
    
    // 檢查定位權限
    func checkLocationPermission() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            showLocationAlert()
        default:
            break
        }
    }
    
    //當獲取到定位時，更新經緯度並重新抓取天氣資料
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            nowLat = location.coordinate.latitude
            nowLon = location.coordinate.longitude
            locationManager.stopUpdatingLocation()
            
            // 更新區域標籤
            updateAreaLabel(with: location)
            
            print("目前位置：\(nowLat), \(nowLon)")
            
            // 重新抓取天氣資料
            fetchItems(forecast: true, urlString: forecastUrlString)
            fetchItems(forecast: false, urlString: dayUrlString)
        }
    }
    
    // 取得失敗時的錯誤處理
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("無法獲取位置：\(error.localizedDescription)")
    }
    
    // 顯示警告 (當權限被拒絕時)
    func showLocationAlert() {
        let alert = UIAlertController(title: "無法取得位置", message: "請到設定中允許定位權限", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default))
        present(alert, animated: true)
    }
    
    // 新增：透過經緯度取得國家名稱，並顯示在 `areaLabel`
    func updateAreaLabel(with location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                let country = placemark.country ?? "未知地區"
                let city = placemark.locality ?? ""
                
                DispatchQueue.main.async {
                    self.areaLabel.text = city.isEmpty ? country : "\(city), \(country)"
                }
            }
        }
    }
    
    func fetchItems(forecast: Bool, urlString: String) {
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                let decoder = JSONDecoder()
                
                if let data {
                    do {
                        // 判斷是抓現在天氣還是未來天氣
                        switch forecast {
                        case true:
                            let searchResponse = try decoder.decode(ForecastWeather.self, from: data)
                            self.items = searchResponse.list
                            DispatchQueue.main.async {
                                self.theTableView.reloadData()
                            }
                            
                        default:
                            let searchResponse = try decoder.decode(CurrentWeather.self, from: data)
                            DispatchQueue.main.async {
                                self.nowWeatherLabel.text = searchResponse.weather.first?.main.description
                                self.nowTempLabel.text = self.tempFormat(c: searchResponse.main.temp, highLow: "now")
                                self.nowLowTempLabel.text = self.tempFormat(c: searchResponse.main.temp, highLow: "L")
                                self.nowHighTempLabel.text = self.tempFormat(c: searchResponse.main.temp, highLow: "H")
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume() // 執行任務
        }
    }
    
    func tempFormat(c: Double, highLow: String) -> String {
        var tempString = lroundf(Float(c)).description
        
        // 最高溫、最低溫
        switch highLow {
        case "L": tempString = "\(tempString)°C"
        case "H": tempString = "\(tempString)°C"
        default: tempString = "\(tempString)°C"
        }
        
        return tempString
    }
}

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count  //顯示正確數量的資料
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastTableViewCell", for: indexPath) as! ForecastTableViewCell
        let item = items[indexPath.row]
        
        //時間字串分兩行顯示
        let nowTime = item.dt_txt.description
        let startIndex = nowTime.index(nowTime.startIndex, offsetBy: 0)
        let middleIndex = nowTime.index(nowTime.startIndex, offsetBy: 11)
        let endIndex = nowTime.index(nowTime.endIndex, offsetBy: 0)
        
        cell.timeLabel.text = "\(nowTime[startIndex..<middleIndex])\n\(nowTime[middleIndex..<endIndex])"
        cell.weatherLabel.text = item.weather.first?.main.description
        cell.lowTempLabel?.text = "最低溫度: \(tempFormat(c: item.main.temp_min, highLow: "L"))"
        cell.highTempLabel?.text = "最高溫度: \(tempFormat(c: item.main.temp_max, highLow: "H"))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.black // 設定背景為黑色

        let label = UILabel()
        label.text = "天氣預報"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.white
        label.textAlignment = .center  // 讓標題置中
        label.translatesAutoresizingMaskIntoConstraints = false  // 啟用 Auto Layout

        headerView.addSubview(label)

        // 使用 Auto Layout 讓 Label 置中
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16), // 靠左對齊
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor), // 垂直置中
        ])

        return headerView
    }

}
