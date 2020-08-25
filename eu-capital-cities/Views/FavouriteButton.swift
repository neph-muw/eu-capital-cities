//
//  FavouriteButton.swift
//  eu-capital-cities
//
//  Created by Roman Mykitchak on 23/08/2020.
//

import UIKit

class FavouriteButton: UIButton {
    
    var isFavourited: Bool = false {
        didSet {
            if isFavourited {
                self.setImage("💛".image(), for: .normal)
            } else {
                self.setImage("🖤".image(), for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureButton()
    }
    
    private func configureButton() {
        self.isFavourited = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
