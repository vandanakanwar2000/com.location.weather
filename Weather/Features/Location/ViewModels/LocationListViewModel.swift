//
//  LocationListViewModel.swift
//  Weather
//
//  Created by Vandana Kanwar on 22/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import UIKit

protocol LocationListViewModelDelegate: NSObject {
    func viewLoaded()
}

struct LocationListViewModel {
    let locations: [Location]
    let weatherService = WeatherService()
    var selectedLocation: Location?
    let storageManager = Storage()

    init(locations: [Location]) {
        self.locations = locations
    }

    func weatherListCellModel(model: CurrentWeather?, cityName: String?) -> WeatherListViewModel {
        guard let model = model
        else { return WeatherListViewModel(temperatureLabelText: LocalizedString.initialValue.description,
                                           cityNameLabelText: cityName ?? LocalizedString.initialValue.description,
                                           timeLabelText: LocalizedString.initialValue.description,
                                           errorText: LocalizedString.errorText.description) }

        return WeatherListViewModel(temperatureLabelText: LocalizedString.temperatureString(Int(model.main.temp)).description,
                                    cityNameLabelText: cityName ?? model.name ?? "",
                                    timeLabelText: model.date.timeOfTheDay,
                                    errorText: nil)
    }

    func loadWeatherInfo(location: Location, completion: @escaping (WeatherListViewModel, String?) -> Void) {
        guard let locationCoordinate = location.location else { return }
        weatherService.getCurrentWeather(at: locationCoordinate.coordinate,
                                         requestType: .weather,
                                         result: CurrentWeather.self) { result in
            switch result {
            case let .success(response):
                completion(self.weatherListCellModel(model: response,
                                                     cityName: location.name),
                           location.name)
            case .failure:
                completion(self.weatherListCellModel(model: nil,
                                                     cityName: location.name),
                           location.name)
            }
        }
    }

    func getFooterModel() -> FooterViewModel {
        return FooterViewModel()
    }

    func save(location: Location,
              completion: ([Location]) -> Void) {
        storageManager.save(location)
        completion(storageManager.fetch())
    }
}
