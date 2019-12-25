//
//  LocationSearchViewModel.swift
//  Weather
//
//  Created by Vandana Kanwar on 22/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import MapKit
import UIKit

protocol LocationSearchViewModelDelegate: AnyObject {
    func refreshView(locations: [Location], shouldShowHistory: Bool)
}

final class LocationSearchViewModel {
    var locations: [Location]

    let searchHistoryLabel = LocalizedString.searchHistoryText.description
    let storage = SearchHistoryManager()

    weak var delegate: LocationSearchViewModelDelegate?
    private var pendingRequestWorkItem: DispatchWorkItem?

    var geocoder = CLGeocoder()
    var localSearch: MKLocalSearch?

    init(locations: [Location]) {
        self.locations = locations
    }

    func fetchCachedLocations() -> [Location] {
        return storage.fetch()
    }

    func localMapSearch(searchString: String) {
        let searchTerm = searchString.trimmingCharacters(in: CharacterSet.whitespaces)
        if searchTerm.isEmpty {
            delegate?.refreshView(locations: storage.fetch(),
                                  shouldShowHistory: true)
            return
        }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchTerm
        localSearch?.cancel()
        localSearch = MKLocalSearch(request: request)
        localSearch!.start { response, _ in
            self.showItemsForSearchResult(response)
        }
    }

    func showItemsForSearchResult(_ searchResult: MKLocalSearch.Response?) {
        locations = searchResult?.mapItems.map { Location(name: $0.name, placemark: $0.placemark) } ?? []

        delegate?.refreshView(locations: locations,
                              shouldShowHistory: false)
    }

    func search(searchString: String) {
        pendingRequestWorkItem?.cancel()
        showItemsForSearchResult(nil)
        let requestWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.localMapSearch(searchString: searchString)
        }
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10),
                                      execute: requestWorkItem)
    }

    func save(_ location: Location) {
        storage.save(location)
    }

    func delete(location: Location) {
        storage.delete(location)
    }
}
