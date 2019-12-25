//
//  RootCoordinator.swift
//  Weather
//
//  Created by Vandana Kanwar on 24/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import UIKit

final class RootCoordinator {
    private weak var window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
        try? addReachabilityObserver()
    }

    func setRootView() {
        if let window = window {
            let weatherViewController = UIStoryboard.weatherViewController
            let navigationController = UINavigationController(rootViewController: weatherViewController)
            weatherViewController.setupDependencies(viewModel: WeatherViewModel(),
                                                    locationListActionHandler: { [weak self] locations in
                                                        self?.showLocationList(locations: locations,
                                                                               fromViewController: weatherViewController)

            })
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }

    func showLocationList(locations: [Location],
                          fromViewController: WeatherViewController) {
        let locationListViewController = UIStoryboard.locationList

        locationListViewController.setupDependencies(viewModel: LocationListViewModel(locations: locations),
                                                     locations: locations) { [weak self] locations in
            self?.showLocationSearch(locations: locations, fromViewController: locationListViewController)
        }

        locationListViewController.delegate = fromViewController
        fromViewController.navigationController?.pushViewController(locationListViewController, animated: true)
    }

    func showLocationSearch(locations: [Location],
                            fromViewController: LocationListViewController) {
        let locationSearchViewController = UIStoryboard.locationSearch
        let navigationController = UINavigationController(rootViewController: locationSearchViewController)

        locationSearchViewController.setupDependencies(viewModel: LocationSearchViewModel(locations: locations),
                                                       locations: locations) { _ in }
        navigationController.modalTransitionStyle = .crossDissolve
        locationSearchViewController.delegate = fromViewController
        fromViewController.present(navigationController,
                                   animated: true,
                                   completion: nil)
    }

    deinit {
        removeReachabilityObserver()
    }
}

extension RootCoordinator: ReachabilityObserverDelegate {
    func reachabilityChanged(_ isReachable: Bool) {
        if !isReachable {
            let alert = UIAlertController(title: LocalizedString.alertTitle.description,
                                          message: LocalizedString.alertSubtitle.description, preferredStyle: .alert)
            let action = UIAlertAction(title: LocalizedString.alertButtonText.description, style: .default, handler: nil)
            alert.addAction(action)
            window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
}
