//
//  CoreDataInteractor.swift
//  eu-capital-cities
//
//  Created by Roman Mykitchak on 11/10/2020.
//

import Foundation
import UIKit
import CoreData

enum CoreDataInteractorError: Error {
    case coreDataSaveError(problem: String)
    case coreDataFetchError(problem: String)
}

class CoreDataInteractor {
    
    // MARK: Variables
    
    private(set) var coreDataCities: [NSManagedObject] = []
    
    // MARK: Singleton, Lifecycle
    static let shared = CoreDataInteractor()
    
    func coreDataCity(whereId: String) -> NSManagedObject? {
        coreDataCities.filter { city in
            city.value(forKeyPath: "id") as? String == whereId
        }.first
    }
    
    func coreDataSave(city: EuCity) throws {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let cityId = city.id else { return }
        
        guard city.favourited == true else {
            // delete if unfauvorited and found in core data
            guard let cityToBeDeleted: NSManagedObject = coreDataCity(whereId: cityId) else { return }
            
            managedContext.delete(cityToBeDeleted)
            coreDataCities.removeAll { $0 == cityToBeDeleted }
            
            do {
                try managedContext.save()
            } catch _ as NSError {
                throw CoreDataInteractorError.coreDataSaveError(problem: "CoreData: Could not delete(delete if unfauvorited and found in core data).")
            }
            return
        }
        
        // do not add extra favourited values if exists
        if coreDataCity(whereId: cityId) != nil { return }
        
        let entity = NSEntityDescription.entity(forEntityName: "CoreDataEuCity", in: managedContext)!
        let coreDataCity = NSManagedObject(entity: entity, insertInto: managedContext)
        
        coreDataCity.setValue(city.id, forKeyPath: "id")
        coreDataCity.setValue(city.favourited, forKeyPath: "favourited")
        
        
        do {
            try managedContext.save()
            coreDataCities.append(coreDataCity)
        } catch _ as NSError {
            throw CoreDataInteractorError.coreDataSaveError(problem: "CoreData: Could not save.")
        }
    }
        
    func coreDataFetch() throws {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreDataEuCity")
        do {
            coreDataCities = try managedContext.fetch(fetchRequest)
        } catch _ as NSError {
            throw CoreDataInteractorError.coreDataSaveError(problem: "CoreData: Could not fetch.")
        }
    }
}
