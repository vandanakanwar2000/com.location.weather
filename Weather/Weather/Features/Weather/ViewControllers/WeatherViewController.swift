//
//  WeatherViewController.swift
//  Weather
//
//  Created by Vandana Kanwar on 21/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import MapKit
import UIKit

final class WeatherViewController: UIViewController {
    typealias LocationListActionHandler = ([Location]) -> Void

    @IBOutlet private var secondaryStackView: UIStackView!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var cityName: UILabel!
    @IBOutlet private var weatherType: UILabel!
    @IBOutlet private var temperature: UILabel!
    @IBOutlet private var tempMax: UILabel!
    @IBOutlet private var tempMin: UILabel!
    @IBOutlet private var currentDay: UILabel!
    @IBOutlet private var scrollingHeaderView: ScrollingHeaderView!
    @IBOutlet private var descriptionView: WeatherDescriptionView!

    var location: Location?
    private(set) var viewModel: WeatherViewModel!
    private var locationListActionHandler: LocationListActionHandler!

    func setupDependencies(
        viewModel: WeatherViewModel,
        locationListActionHandler: @escaping LocationListActionHandler
    ) {
        self.viewModel = viewModel
        self.locationListActionHandler = locationListActionHandler
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.location = location
        scrollView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    @IBAction func searchLocation(_: UIButton) {
        locationListActionHandler(SearchHistoryManager().fetch())
    }

    private func clearStackView() {
        secondaryStackView.arrangedSubviews.forEach {
            self.secondaryStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }

    private func dailyForcastList(detailViewViewModels: [ForecastViewModel]) -> UIStackView {
        let listStackView = UIStackView(frame: .zero)
        listStackView.spacing = 8
        listStackView.axis = .vertical

        guard !detailViewViewModels.isEmpty
        else { return listStackView }

        for model in detailViewViewModels {
            let view = ForecastView(frame: .zero)
            view.bind(viewModel: model)
            listStackView.addArrangedSubview(view)
        }
        return listStackView
    }

    private func detailList(detailViewViewModels: [DetailViewViewModel]) -> UIStackView {
        let listStackView = UIStackView(frame: .zero)
        listStackView.spacing = 16
        listStackView.axis = .vertical

        guard !detailViewViewModels.isEmpty
        else { return listStackView }

        for model in detailViewViewModels {
            let view = DetailView(frame: .zero)
            view.bind(viewModel: model)
            listStackView.addArrangedSubview(view)
        }
        return listStackView
    }
}

extension WeatherViewController: LocationListViewControllerDelegate {
    func didTapOnCell(location: Location) {
        self.location = location
        viewModel.location = location
        dismiss(animated: true, completion: nil)
        guard let locationCoordinate = location.location?.coordinate,
            let cityName = location.name
        else { return }

        viewModel.requestWeatherData(coordinates: locationCoordinate, cityName: cityName) {}
    }
}

extension WeatherViewController: WeatherViewModelDelegate {
    func refreshView() {
        guard let weatherModel = viewModel.getWeatherModel(),
            let descriptionModel = viewModel.getWeatherDescriptionViewModel()
        else { return }

        clearStackView()

        cityName.text = weatherModel.name
        temperature.text = LocalizedString.temperatureString(Int(weatherModel.main.temp)).description
        currentDay.text = LocalizedString.dayNameValue(weatherModel.date.dayOfTheWeek).description
        tempMax.text = LocalizedString.temperatureString(Int(weatherModel.main.tempMax)).description
        tempMin.text = LocalizedString.temperatureString(Int(weatherModel.main.tempMin)).description
        weatherType.text = weatherModel.weather[0].main

        if let models = viewModel.getScrollingHeaderViewModel(), !models.isEmpty {
            let dailyWeatherViewModel = viewModel.getForcastViewModels()
            scrollingHeaderView.bind(viewModels: models)

            let weatherDetailsView = WeatherDescriptionView()
            weatherDetailsView.bind(dataSource: descriptionModel)
            secondaryStackView.addArrangedSubview(weatherDetailsView)

            let forcastWeatherViews = dailyForcastList(detailViewViewModels: dailyWeatherViewModel)
            secondaryStackView.addArrangedSubview(forcastWeatherViews)

            let view = UIView()
            secondaryStackView.addArrangedSubview(view.separator(color: .white))

            let detailsView = detailList(detailViewViewModels: viewModel.getDetailViewModels() ?? [])
            secondaryStackView.addArrangedSubview(detailsView)
            view.layoutIfNeeded()
        }
    }
}

extension WeatherViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let alphaValue = (scrollView.contentOffset.y / (scrollView.bounds.size.height / 4))
        temperature.alpha = 1 - (alphaValue + 0.3)
        tempMax.alpha = 1 - (alphaValue + 0.4)
        tempMin.alpha = 1 - (alphaValue + 0.4)
        currentDay.alpha = 1 - (alphaValue + 0.4)
    }
}
