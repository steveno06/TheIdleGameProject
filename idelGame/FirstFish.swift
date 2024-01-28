import Foundation
import UIKit


class FirstFishCard: UIView{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    weak var viewController: ViewController?
    
    var fishType = "Default_Name"
    var fishLevel: Int64 = 1
    var cost = 0.0
    var costMultiplier = 0.0
    var production = 0.0
    var productionMultiplier = 0.0
    
    init(viewController: ViewController) {
        self.viewController = viewController
        super.init(frame: .zero)
        getFish()
        setUpCard()

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        getFish()
        setUpCard()
        
    }
    
    func setUpCard(){
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        let breedButton: UIButton = {
            let button = UIButton()
            button.backgroundColor = .black
            button.setTitle(self.fishType, for: .normal)
            button.addTarget(target, action: #selector(breedButtonPressed), for: .touchUpInside)
            return button
        }()
        
        let fishLevelLabel: UILabel = {
            let label = UILabel()
            label.backgroundColor = .cyan
            label.text = String(self.fishLevel)
            label.textAlignment = .center
            return label
        }()
        
        let purchaseButton: UIButton = {
            let button = UIButton()
            button.backgroundColor = .gray
            button.setTitle(String(self.cost), for: .normal)
            button.addTarget(target, action: #selector(purchaseButtonPressed), for: .touchUpInside)
            return button
        }()
        
        let timerLabel: UILabel = {
            let label = UILabel()
            label.backgroundColor = .magenta
            label.text = "timer"
            return label
        }()
        
        addSubview(breedButton)
        addSubview(fishLevelLabel)
        addSubview(purchaseButton)
        addSubview(timerLabel)
        
        breedButton.translatesAutoresizingMaskIntoConstraints = false
        fishLevelLabel.translatesAutoresizingMaskIntoConstraints = false
        purchaseButton.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //Breed Button
        NSLayoutConstraint.activate([
            breedButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            breedButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            breedButton.widthAnchor.constraint(equalToConstant: 80),
            breedButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        //Fish Level Label
        NSLayoutConstraint.activate([
            fishLevelLabel.topAnchor.constraint(equalTo: breedButton.bottomAnchor, constant: 10),
            fishLevelLabel.centerXAnchor.constraint(equalTo: breedButton.centerXAnchor),
            fishLevelLabel.widthAnchor.constraint(equalToConstant: 60),
            fishLevelLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        //Purchase Button
        NSLayoutConstraint.activate([
            purchaseButton.leadingAnchor.constraint(equalTo: breedButton.trailingAnchor, constant: 10),
            purchaseButton.bottomAnchor.constraint(equalTo: fishLevelLabel.bottomAnchor),
            purchaseButton.widthAnchor.constraint(equalToConstant: 175),
            purchaseButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        //Timer Label
        NSLayoutConstraint.activate([
            timerLabel.leadingAnchor.constraint(equalTo: purchaseButton.trailingAnchor,constant: 10),
            timerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            timerLabel.bottomAnchor.constraint(equalTo: purchaseButton.bottomAnchor),
            timerLabel.topAnchor.constraint(equalTo: purchaseButton.topAnchor)
        ])
    }
    
    @objc private func breedButtonPressed() {
                do {
            let players = try context.fetch(Player.fetchRequest())
            players[0].balance += self.production
            try context.save()
            viewController?.getBalance()
        } catch {
            // Handle error
        }
        
        // Add your custom logic here for breed button action
    }

    @objc private func purchaseButtonPressed() {
        print("Purchase button pressed")
        // Add your custom logic here for purchase button action
    }
    
    func getFish(){
        do{
            let fishes = try context.fetch(Fish.fetchRequest())
            self.fishType = fishes[0].fishType!
            self.fishLevel = fishes[0].fishLevel
            
            self.cost = fishes[0].cost
            self.costMultiplier = fishes[0].costMultiplier
            
            self.production = fishes[0].production
            self.productionMultiplier = fishes[0].productionMultiplier
            
        }
        catch{
            print("error retrieving fish")
        }
    }
    
}




