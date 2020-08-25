//
//  CityCellConfiguration.swift
//  eu-capital-cities
//
//  Created by Roman Mykitchak on 25/08/2020.
//

import Foundation
import UIKit

struct CityCellConfiguration: UIContentConfiguration, Hashable {
    var image: UIImage? = nil
    var cityName: String? = nil
    var fafourited: Bool? = false
    
    func makeContentView() -> UIView & UIContentView {
        return CustomContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        guard let state = state as? UICellConfigurationState else { return self }
        let updatedConfig = self
//        if state.isSelected || state.isHighlighted {
//
//        }
        return updatedConfig
    }
}

class CustomContentView: UIView, UIContentView {
    init(configuration: CityCellConfiguration) {
        super.init(frame: .zero)
        setupInternalViews()
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var configuration: UIContentConfiguration {
        get { appliedConfiguration }
        set {
            guard let newConfig = newValue as? CityCellConfiguration else { return }
            apply(configuration: newConfig)
        }
    }
    
    // MARK: InternalConfiguration
    
    private enum InternalConfiguration {
        static let favouriteButtonSize = CGSize(width: 40, height: 40)
        static let imageSize = CGSize(width: 100.0, height: 100.0)
        static let imageLabelPadding = CGFloat(-20.0)
    }
    
    private let imageView = UIImageView()
    private var favouriteButton: FavouriteButton!
    private let textLabel = UILabel()
    
    private func setupInternalViews() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.preferredSymbolConfiguration = .init(font: .preferredFont(forTextStyle: .body), scale: .large)
        imageView.isHidden = true
        
        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        favouriteButton = FavouriteButton(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: InternalConfiguration.favouriteButtonSize))
        favouriteButton.addTarget(self, action: #selector(onFauvorite), for: .touchUpInside)
        addSubview(favouriteButton)
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //imageView
            NSLayoutConstraint(item: imageView as Any, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: InternalConfiguration.imageSize.width),
            NSLayoutConstraint(item: imageView as Any, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: InternalConfiguration.imageSize.height),
            imageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: textLabel.leadingAnchor, constant: InternalConfiguration.imageLabelPadding),
            imageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            //textLabel
            textLabel.trailingAnchor.constraint(equalTo: favouriteButton.leadingAnchor),
            textLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            textLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            //favouriteButton
            NSLayoutConstraint(item: favouriteButton as Any, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: InternalConfiguration.favouriteButtonSize.width),
            NSLayoutConstraint(item: favouriteButton as Any, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: InternalConfiguration.favouriteButtonSize.height),
            layoutMarginsGuide.centerYAnchor.constraint(equalTo: favouriteButton.centerYAnchor),
            layoutMarginsGuide.trailingAnchor.constraint(equalTo: favouriteButton.trailingAnchor, constant: InternalConfiguration.favouriteButtonSize.width)
            ])
    }
    
    @objc func onFauvorite() {
//        sender.isSelected = !sender.isSelected
//        guard let configuration = self.configuration as? CityCellConfiguration else { return }
//        configuration.fafourited = !configuration.fafourited
        favouriteButton.isFavourited = !favouriteButton.isFavourited
    }
    
    private var appliedConfiguration: CityCellConfiguration!
    
    private func apply(configuration: CityCellConfiguration) {
        guard appliedConfiguration != configuration else { return }
        appliedConfiguration = configuration
        
        imageView.isHidden = configuration.image == nil
        imageView.image = configuration.image
        textLabel.isHidden = configuration.cityName == nil
        textLabel.text = configuration.cityName
        favouriteButton.isFavourited = configuration.fafourited ?? false
    }
}
