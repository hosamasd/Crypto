//
//  PortfolioDataService.swift
//  Crypto
//
//  Created by hosam on 04/07/2026.
//

import Foundation
import CoreData

class PortfolioDataService{
    
    private let container:NSPersistentContainer
    private let containerName:String="PortfolioContainer"
    private let entityName="PortfolioEntity"
    
    @Published var savedEntites:[PortfolioEntity]=[]
    
    init() {
        container=NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let err=error{
                print("Error loading core data: \(err.localizedDescription)")
            }
        }
        self.getPortfolio()
    }
    
    func updatePortfolio(coin:CoinModel,amount:Double)  {
        if let entity=savedEntites.first(where: { $0.coinID==coin.id }){
            if amount > 0 {
                update(entity: entity, amount: amount)
            }else{
                delete(entity: entity, amount: amount)
            }
        }else{
            add(coin: coin, amount: amount)
        }
    }
    
    // MARRK: PRIVATE
    private  func getPortfolio()  {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do{
            savedEntites=try container.viewContext.fetch(request)
        }catch let error{
            print("Error fetching portfolio entites: \(error.localizedDescription)")
        }
        
    }
    
    private func add(coin:CoinModel,amount:Double)  {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID=coin.id
        entity.amount=amount
        applyChanges()
    }
    
    private  func update(entity:PortfolioEntity,amount:Double)  {
        entity.amount=amount
        applyChanges()
    }
    
    private  func delete(entity:PortfolioEntity,amount:Double)  {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private  func save()  {
        do {
            try container.viewContext.save()
        }catch let error{
            print("Error saving to core data: \(error.localizedDescription)")
        }
    }
    
    
    
    private  func applyChanges()  {
        save()
        getPortfolio()
    }
}
