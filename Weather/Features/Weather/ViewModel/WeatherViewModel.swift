//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Vandana Kanwar on 21/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import CoreLocation
import UIKit

protocol WeatherViewModelDelegate: NSObject {
    func refreshView()
}

final class WeatherViewModel: NSObject {
    private var weatherModel: CurrentWeather?
    private var forecastModel: ForcastResponse?
    private var dailyForecastModel: DailyForcastResponse?
    weak var delegate: WeatherViewModelDelegate?

    private var cityName: String?
    var location: Location?
    var coordinates = CLLocationCoordinate2D()
    var locationViewModel: LocationViewModel?

    let weatherService = WeatherService()

    override init() {
        super.init()
        locationViewModel = LocationViewModel()
        locationViewModel?.delegate = self
    }

    private func setWeatherModel(weatherModel: CurrentWeather?) {
        self.weatherModel = weatherModel
    }

    func getWeatherModel() -> CurrentWeather? {
        return weatherModel
    }

    private func setForecastModel(forecastModel: ForcastResponse) {
        self.forecastModel = forecastModel
    }

    func getForecastModel() -> ForcastResponse? {
        return forecastModel
    }

    private func setDailyForecastModel(dailyForecastModel: DailyForcastResponse) {
        self.dailyForecastModel = dailyForecastModel
    }

    func getDailyForecastModel() -> DailyForcastResponse? {
        return dailyForecastModel
    }

    func requestWeatherData(coordinates: CLLocationCoordinate2D,
                            cityName: String,
                            completion: @escaping () -> Void) {
        self.cityName = cityName
        weatherService.getCurrentWeather(at: coordinates,
                                         requestType: .weather,
                                         result: CurrentWeather.self) { [weak self] result in
            switch result {
            case let .success(model):
                self?.setWeatherModel(weatherModel: model)
                guard self?.getForecastModel() != nil
                else { return }
                self?.delegate?.refreshView()
            case .failure: break
            }
        }

        weatherService.getCurrentWeather(at: coordinates,
                                         requestType: .forecast,
                                         result: ForcastResponse.self) { [weak self] result in
            switch result {
            case let .success(model):
                self?.setForecastModel(forecastModel: model)
                self?.delegate?.refreshView()
            case .failure: break
            }
        }

        weatherService.getCurrentWeather(city: cityName,
                                         requestType: .dailyForecast,
                                         result: DailyForcastResponse.self) { [weak self] result in
            switch result {
            case let .success(model):
                self?.setDailyForecastModel(dailyForecastModel: model)
                self?.delegate?.refreshView()
            case .failure: break
            }
            completion()
        }
    }

    func getScrollingHeaderViewModel() -> [HeaderViewModel]? {
        guard let weatherModel = getWeatherModel(),
            let forecastModel = getForecastModel()
        else { return nil }
        var headerViewModelArray: [HeaderViewModel] = []

        headerViewModelArray.append(
            HeaderViewModel(title: LocalizedString.nowString.description,
                            detail: LocalizedString.temperatureString(Int(weatherModel.main.temp)).description,
                            image: LocalizedString.imageUrlString(forecastModel.list[0].weather[0].icon).description))

        for list in forecastModel.list {
            headerViewModelArray.append(
                HeaderViewModel(title: list.date.hourOfTheDay,
                                detail: LocalizedString.temperatureString(Int(list.main.temp)).description,
                                image: LocalizedString.imageUrlString(list.weather[0].icon).description)
            )
        }

        return headerViewModelArray
    }

    func getWeatherDescriptionViewModel() -> WeatherDescriptionViewModel? {
        guard let weatherModel = getWeatherModel()
        else { return nil }
        return WeatherDescriptionViewModel(detail: LocalizedString.details(weatherModel.date.dayOfTheWeek,
                                                                           Int(weatherModel.main.temp),
                                                                           Int(weatherModel.main.tempMax)).description)
    }

    func getDetailViewModels() -> [DetailViewViewModel]? {
        guard let weatherModel = getWeatherModel()
        else { return nil }

        return [DetailViewViewModel(titlePrimary: LocalizedString.sunriseString.description,
                                    detailPrimary: Date(timeIntervalSince1970: TimeInterval(weatherModel.sys.sunrise ?? 0))
                                        .timeOfTheDay,
                                    titleSecondary: LocalizedString.sunsetString.description,
                                    detailSecondary: Date(timeIntervalSince1970: TimeInterval(weatherModel.sys.sunset ?? 0))
                                        .timeOfTheDay),
                DetailViewViewModel(titlePrimary: LocalizedString.chanceOfRainString.description,
                                    detailPrimary: LocalizedString.percentageValue(Int(weatherModel.rain?.threeHour ?? 0))
                                        .description,
                                    titleSecondary: LocalizedString.humidityString.description,
                                    detailSecondary: LocalizedString.percentageValue(weatherModel.main.humidity).description),
                DetailViewViewModel(titlePrimary: LocalizedString.windString.description,
                                    detailPrimary: LocalizedString.windUnitString(weatherModel.wind.deg ?? 0)
                                        .description,
                                    titleSecondary: LocalizedString.feelsLikeString.description,
                                    detailSecondary: LocalizedString.temperatureString(Int(weatherModel.main.tempMax))
                                        .description),
                DetailViewViewModel(titlePrimary: LocalizedString.precipitationString.description,
                                    detailPrimary: LocalizedString.cmUnitValue((weatherModel.rain?.threeHour ?? 0) / 10)
                                        .description,
                                    titleSecondary: LocalizedString.pressureString.description,
                                    detailSecondary: LocalizedString.pressureUnitValue(weatherModel.main.pressure)
                                        .description)]
    }

    func getForcastViewModels() -> [ForecastViewModel] {
        guard let dailyForcastModel = getDailyForecastModel(),
            let list = dailyForcastModel.list,
            list.count > 6
        else { return [] }
        var modelArr: [ForecastViewModel] = []

        list.forEach { model in
            let icon = model.weather?.first?.icon ?? ""
            let viewModel = ForecastViewModel(title: model.date.dayOfTheWeek,
                                              detail: LocalizedString.temperatureString(Int(model.temp?.max ?? 0.0)).description,
                                              image: LocalizedString.imageUrlString(icon).description,
                                              subTitle: LocalizedString.temperatureString(Int(model.temp?.min ?? 0.0)).description)

            modelArr.append(viewModel)
        }

        return modelArr
    }
}

extension WeatherViewModel: LocationViewModelDelegate {
    func updatedLocation(with coordinates: CLLocationCoordinate2D, cityName: String) {
        self.coordinates = coordinates
        self.cityName = cityName
        requestWeatherData(coordinates: coordinates, cityName: cityName) {}
    }

    func failedToUpdateLocation() {}
}
