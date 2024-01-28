import Foundation

class FishDefinition{
    let fishType: String
    let fishLevel: Int64 = 1
    
    let cost: Double
    let costMultiplier: Double
    
    let production: Double
    let productionMultiplier: Double
    
    init(fishType: String, cost: Double, costMultiplier: Double, production: Double, productionMultiplier: Double) {
        self.fishType = fishType

        self.cost = cost
        self.costMultiplier = costMultiplier
        self.production = production
        self.productionMultiplier = productionMultiplier
    }
}

class AppConstants: ObservableObject {
    let guppy: FishDefinition
    let goldFish: FishDefinition
    let clownFish: FishDefinition
    
    init() {
        self.guppy = FishDefinition(
            fishType: "guppy",
            
            cost: 10.0,
            costMultiplier: 1.1,
            production: 5.0,
            productionMultiplier: 1.17
        )
        self.goldFish = FishDefinition(
            fishType: "goldfish",
            
            cost: 50.0,
            costMultiplier: 1.1,
            production: 30.0,
            productionMultiplier: 1.2
        )
        self.clownFish = FishDefinition(
            fishType: "clownfish",
            
            cost: 200.0,
            costMultiplier: 1.1,
            production: 75.0,
            productionMultiplier: 1.22
        )
    }
}
