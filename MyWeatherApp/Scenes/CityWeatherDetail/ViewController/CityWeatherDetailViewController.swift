//
//  CityWeatherDetailViewController.swift
//  MyWeatherApp
//
//  Created by Ajimi Fares on 27/6/2023.
//

import UIKit

class CityWeatherDetailViewController: BaseViewController {
    
    @IBOutlet weak var cityNameLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var pressureLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var windLbl: UILabel!
    @IBOutlet weak var backgroundUIImageView: UIImageView!
    
    let viewModel = CityWeatherDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUpView()
    }
    
    private func setUpView() {
        cityNameLbl.text = viewModel.weather?.name
        descLbl.text = viewModel.weather?.weather?[0].description!.uppercased()
        tempLbl.text = String(format: "%.0f °C", toCelsius(kelvin: (viewModel.weather?.main?.temp)!))
        windLbl.text = String(format: "%.0f mph",  (viewModel.weather?.wind?.speed)!)
        pressureLbl.text = String(format: "%.0f inHg",  (viewModel.weather?.main?.pressure)!)
        humidityLbl.text = String(format: "%d%%",(viewModel.weather?.main?.humidity)!)
        
        if descLbl.text!.uppercased().contains("RAIN") {
            backgroundUIImageView.image = UIImage(named: "rain_background")
        } else if descLbl.text!.uppercased().contains("SNOW") {
            backgroundUIImageView.image = UIImage(named: "snow_background")
        } else {
            backgroundUIImageView.image = UIImage(named: "clear_background")
            // eventually we can add more weather types before falling down to the clear background
        }
    }
}
