//
//  PersistenceManager.swift
//  MyWeatherApp
//
//  Created by Ajimi Fares on 26/6/2023.
//

import Foundation
import CoreData

class PersistenceManager {
    private let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    // Save or update a City object in the Core Data store
    func saveCity(city: City) {
        managedObjectContext.performAndWait {
            let name = city.name ?? ""
            
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "City")
            fetchRequest.predicate = NSPredicate(format: "name == %@", name)
            
            do {
                if let existingCity = try managedObjectContext.fetch(fetchRequest).first as? City {
                    managedObjectContext.delete(existingCity)
                }
                
                let newCity = NSEntityDescription.insertNewObject(forEntityName: "City", into: managedObjectContext) as! City
                newCity.name = city.name
                
                try managedObjectContext.save()
            } catch {
                print("Error saving City to Core Data: \(error)")
            }
        }
    }
    
    // Fetch all City objects from the Core Data store
    func fetchAllCities() -> [City]? {
        let fetchRequest: NSFetchRequest<City> = NSFetchRequest(entityName: "City")
        
        do {
            let cities = try managedObjectContext.fetch(fetchRequest)
            return cities
        } catch {
            print("Error fetching Cities from Core Data: \(error)")
            return nil
        }
    }
    
    // Delete a City object with the given name from the Core Data store
    func deleteCity(name: String) {
        managedObjectContext.performAndWait {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "City")
            fetchRequest.predicate = NSPredicate(format: "name == %@", name)
            
            do {
                if let city = try managedObjectContext.fetch(fetchRequest).first as? City {
                    managedObjectContext.delete(city)
                    try managedObjectContext.save()
                }
            } catch {
                print("Error deleting City from Core Data: \(error)")
            }
        }
    }
}

