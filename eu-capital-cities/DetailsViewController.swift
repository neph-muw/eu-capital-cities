//
//  DetailsViewController.swift
//  eu-capital-cities
//
//  Created by Roman Mykitchak on 27/08/2020.
//

import UIKit

class DetailsViewController: UIViewController {
    
    // MARK: InternalConfiguration
    
    private enum InternalConfiguration {
        static let imageSize = CGSize(width: 320, height: 320)
        static let titleHeight = CGFloat(40)
        static let favouriteButtonSize = CGSize(width: 40, height: 40)
        static let padding = CGFloat(10)
    }

    // MARK: Variables
    
    var city: EuCity?
    private let backgroundView = UIView(frame: .zero)
    private let stackView = UIStackView(frame: .zero)
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private var favouriteButton: FavouriteButton!
    private var favouritedStatusChanged: Bool = false
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        fullfillViewsData()
    }
    
    private func configureViews() {
        navigationController?.delegate = self
        
        let location = UIBarButtonItem(title: "Location", style: .plain, target: self, action: #selector(onLocation))
        navigationItem.rightBarButtonItems = [location]
        
        backgroundView.backgroundColor = .systemBackground
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
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
            ])
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
        favouritedStatusChanged = false
        favouriteButton = FavouriteButton(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: InternalConfiguration.favouriteButtonSize))
        favouriteButton.addTarget(self, action: #selector(onDetailFauvorite), for: .touchUpInside)
        imageView.addSubview(favouriteButton)
        imageView.isUserInteractionEnabled = true
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //imageView
            NSLayoutConstraint(item: imageView as Any, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: InternalConfiguration.imageSize.width),
            NSLayoutConstraint(item: imageView as Any, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: InternalConfiguration.imageSize.height),
            //favouriteButton
            imageView.trailingAnchor.constraint(equalTo: favouriteButton.trailingAnchor, constant: InternalConfiguration.padding),
            imageView.bottomAnchor.constraint(equalTo: favouriteButton.bottomAnchor, constant: InternalConfiguration.padding),
            NSLayoutConstraint(item: favouriteButton as Any, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: InternalConfiguration.favouriteButtonSize.width),
            NSLayoutConstraint(item: favouriteButton as Any, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: InternalConfiguration.favouriteButtonSize.height),
            //titleLabel
            NSLayoutConstraint(item: titleLabel as Any, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: InternalConfiguration.imageSize.width),
            NSLayoutConstraint(item: titleLabel as Any, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: InternalConfiguration.titleHeight)
        ])
        
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 23)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        
        guard let city = city else { return }
        favouriteButton.isFavourited = city.favourited ?? false
    }
    
    private func fullfillViewsData() {
        guard let city = city else {
            imageView.image = "🏢".image()
            titleLabel.text = "Lorem Ipsum"
            descriptionLabel.text = "Lorem Ipsum dolor sit amet, consectetuer adipiscingelit. Duis tellus. Donec ante dolor, iaculis nec, gravidaac, cursus in, eros. Mauris vestibulum, felis et egestasullamcorper, purus nibh vehicula sem, eu egestas antenisl non justo. Fusce tincidunt, lorem nev dapibusconsectetuer, leo orci mollis ipsum, eget suscipit erospurus in ante."

            return
        }
        
        if let data = city.imageData {
            imageView.image = UIImage(data: data)
        }
        titleLabel.text = city.name
        descriptionLabel.text = city.description
    }
    
    // MARK: Actions
    
    @objc private func onLocation() {
        let vc = LocationViewController()
        vc.lat = city?.latitude
        vc.lon = city?.longitude
        let navigation = UINavigationController(rootViewController: vc)
        self.show(navigation, sender: self)
    }
    
    @objc private func onDetailFauvorite() {
        favouriteButton.isFavourited = !favouriteButton.isFavourited
        guard let city = city else { return }
        city.favourited = favouriteButton.isFavourited
        favouritedStatusChanged = true
        
        do {
            try CoreDataInteractor.shared.coreDataSave(city: city)
        } catch CoreDataInteractorError.coreDataSaveError(problem: let problemDescription) {
            showError(from: self, with: problemDescription)
        } catch let error as NSError {
            showError(from: self, with: "CoreData: Details View - Could not save/delete. \(error), \(error.userInfo)")
        }
    }
}


extension DetailsViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let vc = viewController as? ViewController {
            if favouritedStatusChanged {
                vc.shouldReloadFavourites = true
            }
            navigationController.delegate = nil
        }
    }
}
