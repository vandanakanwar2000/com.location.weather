//
//  LocationViewModel.swift
//  Weather
//
//  Created by Vandana Kanwar on 22/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import CoreLocation
import UIKit

protocol LocationViewModelDelegate: NSObject {
    func updatedLocation(with coordinates: CLLocationCoordinate2D, cityName: String)
    func failedToUpdateLocation()
}

final class LocationViewModel: NSObject {
    private let history = SearchHistoryManager()

    private var locationManager: CLLocationManager!
    private var geocoder = CLGeocoder()

    weak var delegate: LocationViewModelDelegate?

    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        currentLocation()
    }

    private func geocode(location: CLLocation) {
        geocoder.cancelGeocode()
        geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { (placemarks, _) -> Void in
            if let placemark = placemarks?.first {
                self.history.save(Location(name: placemark.locality,
                                           location: location,
                                           placemark: placemark))
                self.delegate?.updatedLocation(with: location.coordinate,
                                               cityName: placemark.locality ?? placemark.name ?? "")
            } else {
                /// Load last selected location if failed to reverse geocoding
                let locations = self.history.fetch()
                if !locations.isEmpty,
                    let location = locations.first,
                    let locationCoordinate = location.location?.coordinate {
                    self.delegate?.updatedLocation(with: locationCoordinate,
                                                   cityName: location.name ?? "")
                }
            }
        }
    }
}

extension LocationViewModel: CLLocationManagerDelegate {
    func currentLocation() {
        let status = CLLocationManager.authorizationStatus()
        handleLocationAuthorizationStatus(status: status)
    }

    // Respond to the result of the location manager authorization status
    func handleLocationAuthorizationStatus(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }

    func locationManager(_: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationAuthorizationStatus(status: status)
    }

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude

        let location = CLLocation(latitude: latitude,
                                  longitude: longitude)
        geocode(location: location)
    }

    func locationManager(_: CLLocationManager, didFailWithError _: Error) {
        delegate?.failedToUpdateLocation()
    }
}
