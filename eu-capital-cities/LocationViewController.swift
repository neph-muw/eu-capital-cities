//
//  LocationViewController.swift
//  eu-capital-cities
//
//  Created by Roman Mykitchak on 27/08/2020.
//

import UIKit

class LocationViewController: UIViewController {
    
    // MARK: Variables
    
    var lat: String?
    var lon: String?
    private let backgroundView = UIView(frame: .zero)
    private let stackView = UIStackView(frame: .zero)
    private let latLabel = UILabel()
    private let lonLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        fullfillViewsData()
    }
    
    
    private func configureViews() {
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDissmiss))
        navigationItem.rightBarButtonItems = [done]
        
        backgroundView.backgroundColor = .white
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        backgroundView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
//        stackView.alignment = .center
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
            ])
        
        stackView.addArrangedSubview(latLabel)
        stackView.addArrangedSubview(lonLabel)
    }
    
    private func fullfillViewsData() {
        guard let lat = lat, let lon = lon else {
            latLabel.text = "unknown location"
            lonLabel.text = "unknown location"

            return
        }
        
        latLabel.text = "Lattitude: " + lat
        lonLabel.text = "Longitude: " + lon
    }
    
    // MARK: Actions
    
    @objc func onDissmiss() {
        dismiss(animated: true, completion: nil)
    }
}
