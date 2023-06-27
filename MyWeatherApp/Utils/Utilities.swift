//
//  Utilities.swift
//  MyWeatherApp
//
//  Created by Ajimi Fares on 26/6/2023.
//

import Foundation

internal let FahrenheitKelvin = -459.67
internal let KelvinCelsius = 273.15


public func toCelsius(kelvin: Double) -> Double {
    return kelvin - KelvinCelsius
}

func toFahrenheit(celsius: Double) -> Double {
    return celsius * 9 / 5 + 32
}
