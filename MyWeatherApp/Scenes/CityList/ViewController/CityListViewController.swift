//
//  CityListViewController.swift
//  MyWeatherApp
//
//  Created by Ajimi Fares on 27/6/2023.
//

import UIKit

class CityListViewController: BaseViewController {

    @IBOutlet weak var cityList: UITableView!
    
    let viewModel = CityListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Weather"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        cityList.register(UINib.init(nibName: "CityTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        cityList.bindTo(viewModel.cities)
        viewModel.getMyLocationWeather()
        
    }


    @objc func addTapped(){
        
        let addCityVC = AddCityViewController(nibName: "AddCityView", bundle: nil)
        self.navigationController?.pushViewController(addCityVC, animated: true)

    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension CityListViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
          return viewModel.cities.value.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CityTableViewCell
        let weather = viewModel.cities.value[indexPath.row]
        cell.cityNameLbl.text = weather.name
        cell.tempLbl.text = String(format: "%.0f °C", toCelsius(kelvin: (weather.main?.temp)!))
        cell.descLbl.text = weather.weather![0].description
        cell.minMaxLbl.text = String(format: "Min.%.0f°C Max.%.0f°C", toCelsius(kelvin: (weather.main?.tempMin)!),
                                     toCelsius(kelvin: (weather.main?.tempMax)!))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cityWeatherVc = CityWeatherDetailViewController(nibName: "CityWeatherDetailView", bundle: nil)
        cityWeatherVc.viewModel.weather = viewModel.cities.value[indexPath.row]
        self.navigationController?.modalPresentationStyle = .currentContext
        self.navigationController?.present(cityWeatherVc, animated: true)
    }
    
}
