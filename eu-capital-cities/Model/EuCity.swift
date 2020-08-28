//
//  EuCity.swift
//  eu-capital-cities
//
//  Created by Roman Mykitchak on 21/08/2020.
//

import Foundation

class EuCity: Codable, Hashable {
    
    // MARK: Variables
    
    let id: String?
    let name: String?
    let description: String?
    let imageUrl: String?
    let latitude: String?
    let longitude: String?
    
    // MARK: Computed varialbes
    
    var imageData: Data?
    var favourited: Bool? = false
    
    static func == (lhs: EuCity, rhs: EuCity) -> Bool {
        guard lhs.id == rhs.id,
              lhs.name == rhs.name,
              lhs.description == rhs.description,
              lhs.imageUrl == rhs.imageUrl,
              lhs.latitude == rhs.latitude,
              lhs.longitude == rhs.longitude
        else { return false }
        
        return true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
