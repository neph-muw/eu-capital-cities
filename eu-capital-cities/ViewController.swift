//
//  ViewController.swift
//  eu-capital-cities
//
//  Created by Roman Mykitchak on 19/08/2020.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    // MARK: Configuration
    
    private enum Configuration {
        static let cellReuseIdentifier = "CityCellIdentifier"
    }
    
    // MARK: Variables
    
    let network = NetworkManager()
    let tableView = UITableView(frame: .zero, style: .plain)
    let loadingView = LoadingView(frame: .zero)
    private(set) var cities: [EuCity] = []
    var isFilterEnabled: Bool = false

    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        loadCities()
    }
    
    private func configureViews() {
        let filter = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(onFilter))
        navigationItem.rightBarButtonItems = [filter]
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: Configuration.cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        NSLayoutConstraint.activate([
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        loadingView.startLoading()
    }
    
    private func loadCities() {
        guard let url = URL(string: NetworkManager.Configuration.serverUrl) else { return }
        network.networkRequest(url: url,
                               withBody: nil,
                               andHeaders: [ "Content-Type": "application/json; charset=utf-8"])
        { (output, response, error) throws in
            do {
                guard let output = output else { return }
                let jsonOutput = try JSONDecoder().decode([EuCity].self, from: output)
                self.cities = jsonOutput
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.downloadImages()
            } catch let error {
                debugPrint(error)
                throw error
            }
        }
    }
    
    private func downloadImages() {
        
        let group = DispatchGroup()
        let dispatchQueue = DispatchQueue.global(qos: .default)
        
        for city in cities {
            group.enter()
            dispatchQueue.async {
                
                guard let url = URL(string: city.imageUrl ?? "") else { return }
                self.network.networkRequest(url: url,
                                       withBody: nil,
                                       andHeaders: nil)
                { (output, response, error) throws in
                    if let error = error {
                        debugPrint(error)
                    }
                    guard let output = output else { return }
                    city.imageData = output
                    group.leave()
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            
            do {
                
                try CoreDataInteractor.shared.coreDataFetch()
                
            } catch CoreDataInteractorError.coreDataFetchError(problem: let problemDescription) {
                showError(from: self, with: problemDescription)
            } catch let error as NSError {
                showError(from: self, with: "CoreData: Could not fetch. \(error), \(error.userInfo)")
            }
            
            self.mapFavourites()
            
            self.loadingView.stopLoading()
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    // MARK: Actions
    
    @objc func onFilter() {
        isFilterEnabled = !isFilterEnabled
        tableView.reloadData()
    }
    
    func filteredCities() -> [EuCity] {
        return cities.filter { $0.favourited == true }
    }
    
    // MARK: Core Data
    
    func mapFavourites() {
         cities.forEach { city in
            guard let cityId = city.id, let coreDataCity = CoreDataInteractor.shared.coreDataCity(whereId: cityId) else { return }
            
            city.favourited = coreDataCity.value(forKeyPath: "favourited") as? Bool
        }
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var calculatedCities: [EuCity] {
            if isFilterEnabled {
                return filteredCities()
            } else {
                return cities
            }
        }
        
        let city = calculatedCities[indexPath.row]
        
        let vc = DetailsViewController()
        vc.city = city
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilterEnabled {
            return filteredCities().count
        } else {
            return cities.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = (tableView.dequeueReusableCell(withIdentifier: Configuration.cellReuseIdentifier) ?? CityTableViewCell(style: .value1, reuseIdentifier: Configuration.cellReuseIdentifier)) as? CityTableViewCell else {
            return UITableViewCell(style: .value1, reuseIdentifier: Configuration.cellReuseIdentifier)
        }
        
        cell.cityCellDelegate = self
        
        var calculatedCities: [EuCity] {
            if isFilterEnabled {
                return filteredCities()
            } else {
                return cities
            }
        }
        
        let city = calculatedCities[indexPath.row]
        cell.updateWithItem(city)

        return cell
    }
}

extension ViewController: CityTableViewCellDelegate {
    func wasFavourited(favourited: Bool, forCell: CityTableViewCell, withItem: EuCity) {
        let changedCity = cities.filter { city in
            return city.id == withItem.id
        }.first
        guard let city = changedCity else { return }
        city.favourited = favourited
        
        do {
            try CoreDataInteractor.shared.coreDataSave(city: city)
        } catch CoreDataInteractorError.coreDataSaveError(problem: let problemDescription) {
            showError(from: self, with: problemDescription)
        } catch let error as NSError {
            showError(from: self, with: "CoreData: Could not save/delete. \(error), \(error.userInfo)")
        }
        
    }
}

// MARK: Handling errors

func showError(from presenter: UIViewController, with message:String?) {
    let alert = UIAlertController(title: "Error",
                                  message: message,
                                  preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .cancel)
    alert.addAction(cancelAction)
    presenter.present(alert, animated: true)
}
