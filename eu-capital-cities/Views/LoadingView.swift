//
//  LoadingView.swift
//  eu-capital-cities
//
//  Created by Roman Mykitchak on 25/08/2020.
//

import UIKit

class LoadingView: UIView {
    
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureActivityIndicator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            layoutMarginsGuide.centerYAnchor.constraint(equalTo: activityIndicator.centerYAnchor),
            layoutMarginsGuide.centerXAnchor.constraint(equalTo: activityIndicator.centerXAnchor),
            ])
    }
    
    func startLoading() {
        activateConstraints()
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
        isHidden = true
    }
}
