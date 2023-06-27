//
//  CityListViewModel.swift
//  MyWeatherApp
//
//  Created by Ajimi Fares on 27/6/2023.
//

import Foundation
import CoreLocation
import MyWeatherLib

class CityListViewModel{
    
    let weatherApi = MyWeatherLib(apiKey:API_KEY)
    let cities: Dynamic<[WeatherModel]> = Dynamic([])
    let isLoading: Dynamic<Bool> = Dynamic(false)
    
    func getMyLocationWeather()  {
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways
        {
            weatherApi.getWeatherForLocation(location: locationManager.location!){ result in
                switch result {
                case .success(let weather):
                    self.isLoading.value = false
                    self.cities.value.append(contentsOf: [weather])
                case .error(_):
                    self.isLoading.value = false
                    break
                }
            }
        }
        
    }
}
