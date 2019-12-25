//
//  LocationListViewController.swift
//  Weather
//
//  Created by Vandana Kanwar on 22/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import UIKit

protocol LocationListViewControllerDelegate: NSObject {
    func didTapOnCell(location: Location)
}

final class LocationListViewController: UITableViewController {
    typealias SearchLocationActionHandler = ([Location]) -> Void

    weak var delegate: LocationListViewControllerDelegate?

    private let openWeatherUrlString = "https://openweathermap.org"
    private let estimatedHeight: CGFloat = 54.0
    private var locations: [Location] = []
    private var viewModel: LocationListViewModel!
    private var searchLocationActionHandler: SearchLocationActionHandler!

    func setupDependencies(
        viewModel: LocationListViewModel,
        locations: [Location], searchLocationActionHandler: @escaping SearchLocationActionHandler
    ) {
        self.viewModel = viewModel
        self.locations = locations
        self.searchLocationActionHandler = searchLocationActionHandler
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        clearsSelectionOnViewWillAppear = false

        tableView.register(LocationListTableViewCell.self)
        tableView.estimatedRowHeight = estimatedHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundView = UIImageView(image: UIImage(asset: Asset.background))
        let footerView = FooterRow(frame: CGRect(x: 0,
                                                 y: 0,
                                                 width: view.frame.width,
                                                 height: estimatedHeight))
        footerView.delegate = self
        footerView.bind(dataSource: viewModel.getFooterModel())
        tableView.tableFooterView = footerView
    }

    // MARK: - Table view data source

    override func tableView(_: UITableView, titleForHeaderInSection _: Int) -> String? {
        return ""
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return locations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(LocationListTableViewCell.self,
                                     for: indexPath)
        let location = locations[indexPath.row]
        viewModel.selectedLocation = location
        viewModel.loadWeatherInfo(location: location) { model, name in
            self.updateCell(row: indexPath.row, model: model, name: name)
        }

        return cell
    }

    override func tableView(_: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        delegate?.didTapOnCell(location: locations[indexPath.row])
        navigationController?.popViewController(animated: true)
    }

    override func tableView(_: UITableView,
                            canEditRowAt _: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.storageManager.delete(locations[indexPath.row])
            locations.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
        }
    }

    private func updateCell(row: Int, model: WeatherListViewModel, name _: String?) {
        let indexPath = IndexPath(row: row, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? LocationListTableViewCell {
            cell.bind(dataSource: model)
            cell.layoutIfNeeded()
        }
    }
}

extension LocationListViewController: SearchResultsDelegate {
    func refreshView(locations: [Location]) {
        self.locations = locations
        tableView.reloadData()
    }

    func didSelectLocationSelected(location: Location) {
        // dismiss search results
        dismiss(animated: true) {
            self.viewModel.save(location: location) { updatedLocations in
                self.locations = updatedLocations
                self.tableView.reloadData()
            }
        }
    }
}

extension LocationListViewController: FooterRowDelegate {
    func didTapLabel(_: UITapGestureRecognizer, forView _: FooterRow) {
        if let url = URL(string: openWeatherUrlString) {
            UIApplication.shared.open(url, options: [:])
        }
    }

    func didTapImage(_: UITapGestureRecognizer, forView _: FooterRow) {
        searchLocationActionHandler(locations)
    }
}
