//
//  WeatherVC.swift
//  LocationWeather
//
//  Created by 강조은 on 2022/08/04.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import RxAlamofire


class WeatherVC: UIViewController, MTMapViewDelegate {
    
    @IBOutlet var nowPositionMapView: UIView!
    @IBOutlet weak var announcementDay: UILabel!
    @IBOutlet weak var announcementTime: UILabel!
    @IBOutlet weak var forecastX: UILabel!
    @IBOutlet weak var forecastY: UILabel!
    @IBOutlet weak var otherLocationTableView: UITableView!
    let disposeBag = DisposeBag()
    let model = WeatherViewModel.weatherViewModel
    


    var mapView: MTMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        model.settingParameter()
        requestWeatherData()

        otherLocationTableView.delegate = self
        otherLocationTableView.dataSource = self
        
        loadKakaoMap()
    }
    func loadKakaoMap() {
        mapView = MTMapView(frame: self.nowPositionMapView.frame)
        mapView?.delegate = self
        mapView?.baseMapType = .standard
        mapView.currentLocationTrackingMode = .onWithoutHeading
        mapView.showCurrentLocationMarker = true
        mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude:  Double(WeatherViewModel.weatherViewModel.nowForecastX), longitude: Double(WeatherViewModel.weatherViewModel.nowForecastY))), zoomLevel: 5, animated: true)
        self.view.addSubview(mapView)
    }
    
    @IBAction func goDetail(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailWeatherVC {
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .popover
            
            self.present(vc, animated: true, completion: nil)
        }
    }

    func requestWeatherData() {
        model.apiRequest().subscribe(
            onNext: { [weak self] response in
                self?.model.weatherData = response
                self?.announcementDay.text = response.response.body.items.item[0].baseDate
                self?.announcementTime.text = response.response.body.items.item[0].baseTime
                self?.forecastX.text = String(response.response.body.items.item[0].nx)
                self?.forecastY.text = String(response.response.body.items.item[0].ny)
                print("next")
                
            }, onError: { [weak self] error in
                print("error")
            }, onCompleted: {
                print("completed")
            }
        ).disposed(by: disposeBag)
    }
    

}

extension WeatherVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.otherLocationName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = otherLocationTableView.dequeueReusableCell(withIdentifier: "OtherLocationCell", for: indexPath) as! OtherLocationTableViewCell
        switch model.otherLocationName[indexPath.row] {
            case .incheon:
                cell.locationName.text = "인천"
            case .daejeon:
                cell.locationName.text = "대전"
            case .daegu:
                cell.locationName.text = "대구"
            case .busan:
                cell.locationName.text = "부산"
            case .ulsan:
                cell.locationName.text = "울산"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherLocationVC") as? OtherLocationVC {
            switch indexPath.row {
                case 0:
                    vc.selectLocation = "인천광역시"
                case 1:
                    vc.selectLocation = "대전광역시"
                case 2:
                    vc.selectLocation = "대구광역시"
                case 3:
                    vc.selectLocation = "부산광역시"
                case 4:
                    vc.selectLocation = "울산광역시"
                default: break
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .popover
            
            self.present(vc, animated: true, completion: nil)
        }
    }

}

