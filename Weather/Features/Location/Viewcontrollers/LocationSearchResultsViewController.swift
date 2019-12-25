//
//  LocationSearchResultsViewController.swift
//  Weather
//
//  Created by Vandana Kanwar on 20/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import MapKit
import UIKit

protocol SearchResultsDelegate: AnyObject {
    func refreshView(locations: [Location])
    func didSelectLocationSelected(location: Location)
}

final class LocationSearchResultsViewController: UITableViewController {
    private var locations: [Location] = []
    private var onSelectLocation: ((Location) -> Void)?
    private var isShowingHistory = false
    private var geocoder = CLGeocoder()
    private var localSearch: MKLocalSearch?

    private let cellID = "LocationCell"
    private let initialSearchString = " "
    private let searchController = UISearchController(searchResultsController: nil)

    weak var delegate: SearchResultsDelegate?

    var viewModel: LocationSearchViewModel!

    var location: Location? {
        didSet {
            if isViewLoaded {
                searchController.searchBar.text = location.flatMap { $0.name } ?? ""
            }
        }
    }

    func setupDependencies(
        viewModel: LocationSearchViewModel,
        locations: [Location],
        searchedLocationActionHandler: ((Location) -> Void)?
    ) {
        self.viewModel = viewModel
        self.locations = locations
        onSelectLocation = searchedLocationActionHandler
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true

        searchController.searchResultsUpdater = self

        searchController.obscuresBackgroundDuringPresentation = false

        searchController.searchBar.placeholder = LocalizedString.searchPlaceholder.description

        navigationItem.searchController = searchController

        searchController.definesPresentationContext = true

        searchController.searchBar.delegate = self

        viewModel.delegate = self

        locations = viewModel.locations

        isShowingHistory = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    @IBAction func cancelButtonClicked(_: UIBarButtonItem) {
        searchController.searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }

    override func tableView(_: UITableView, titleForHeaderInSection _: Int) -> String? {
        return isShowingHistory ? viewModel.searchHistoryLabel : nil
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return locations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)
            ?? UITableViewCell(style: .subtitle,
                               reuseIdentifier: cellID)

        let location = locations[indexPath.row]
        cell.textLabel?.text = location.name
        cell.detailTextLabel?.text = location.address

        return cell
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard locations.count > indexPath.row else { return }
        searchController.searchBar.resignFirstResponder()
        delegate?.didSelectLocationSelected(location: locations[indexPath.row])
    }

    override func tableView(_: UITableView, canEditRowAt _: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, isShowingHistory {
            viewModel.delete(location: locations[indexPath.row])
            delegate?.refreshView(locations: viewModel.storage.fetch())
            locations.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
        }
    }
}

extension LocationSearchResultsViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text
        else { return }
        viewModel.search(searchString: searchString)
    }

    func selectedLocation(_ location: Location) {
        self.location = location
        viewModel.save(location)

        dismiss(animated: true,
                completion: nil)
    }
}

// MARK: UISearchBarDelegate

extension LocationSearchResultsViewController: UISearchBarDelegate {
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if let text = searchBar.text, text.isEmpty {
            searchBar.text = initialSearchString
        }
    }

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            location = nil
            searchBar.text = initialSearchString
        }
    }
}

extension LocationSearchResultsViewController: LocationSearchViewModelDelegate {
    func refreshView(locations: [Location], shouldShowHistory: Bool) {
        self.locations = locations
        isShowingHistory = shouldShowHistory
        tableView.reloadData()
    }
}
