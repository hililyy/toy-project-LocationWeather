//
//  WeatherModel.swift
//  LocationWeather
//
//  Created by 강조은 on 2022/08/04.
//

import Foundation
import RxSwift

class WeatherModel {
    static let weatherModel = WeatherModel()
    var repository = WeatherRepository()
    func apiRequest() -> Observable<WeatherEntity> {
        repository.apiRequest()
    }
}
