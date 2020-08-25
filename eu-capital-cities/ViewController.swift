//
//  ViewController.swift
//  eu-capital-cities
//
//  Created by Roman Mykitchak on 19/08/2020.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Configuration
    
    private enum Configuration {
        static let cellReuseIdentifier = "CityCellIdentifier"
    }
    
    // MARK: Variables
    
    let network = NetworkManager()
    let tableView = UITableView(frame: .zero, style: .plain)
    let loadingView = LoadingView(frame: .zero)
    private(set) var cities: [EuCity] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        loadCities()
    }
    
    private func configureViews() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        tableView.allowsSelection = false
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: Configuration.cellReuseIdentifier)
//        tableView.delegate = self
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
            debugPrint("TMPLOG loading images done")
            self.loadingView.stopLoading()
            self.tableView.reloadData()
        }
    }
}

//extension ViewController: UITableViewDelegate {
//
//}
//
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = (tableView.dequeueReusableCell(withIdentifier: Configuration.cellReuseIdentifier) ?? CityTableViewCell(style: .value1, reuseIdentifier: Configuration.cellReuseIdentifier)) as? CityTableViewCell else {
            return UITableViewCell(style: .value1, reuseIdentifier: Configuration.cellReuseIdentifier)
        }
        
        let city = cities[indexPath.row]
        cell.updateWithItem(city)

        return cell
    }
}
