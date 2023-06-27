//
//  AddCityViewModel.swift
//  MyWeatherApp
//
//  Created by Ajimi Fares on 27/6/2023.
//

import Foundation
import MyWeatherLib

class AddCityViewModel{
    
    let weatherApi = MyWeatherLib(apiKey:API_KEY)
    let cities: Dynamic<[WeatherModel]> = Dynamic([])
    let isLoading: Dynamic<Bool> = Dynamic(false)
    let buttonEnabled: Dynamic<Bool> = Dynamic(false)
    
    var searchText: String? = nil {
        didSet { buttonEnabled.value = getEnabledFlowStatus() }
    }
    
    func getCityWithName()  {
        
        weatherApi.getWeatherForCityName(name: searchText!){ result in
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

private extension AddCityViewModel {
    func getEnabledFlowStatus() -> Bool {
        guard let gSearchText = searchText else { return false }
        return gSearchText.count >= 3
    }
}
