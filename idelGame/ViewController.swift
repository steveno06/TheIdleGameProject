import UIKit
import CoreData

class ViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var balance: Double = 0

    private let balanceTitle: UILabel = {
        let label = UILabel()
        label.text = "Balance"
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    private let actionButton: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.setTitle("Press Me", for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.configuration = .bordered()
        button.setTitle("Delete Data", for: .normal)
        button.addTarget(self, action: #selector(removeAllData), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getBalance()
        getFish()
    }

    private func setupUI() {
        let fishcard = createCard(target: self)
        // Balance Title
        view.addSubview(balanceTitle)
        balanceTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            balanceTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            balanceTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            balanceTitle.widthAnchor.constraint(equalToConstant: 200),
            balanceTitle.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        
        view.addSubview(fishcard)
        fishcard.translatesAutoresizingMaskIntoConstraints = false
        fishcard.backgroundColor = .red
        NSLayoutConstraint.activate([
            fishcard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            fishcard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            fishcard.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            fishcard.heightAnchor.constraint(equalToConstant: 100),
        ])
        

        // Button
        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.topAnchor.constraint(equalTo: balanceTitle.bottomAnchor, constant: 100),
            actionButton.widthAnchor.constraint(equalToConstant: 200),
            actionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 200),
            deleteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func getBalance() {
        print("get balance")
        do {
            let players = try context.fetch(Player.fetchRequest())
            print(String(players.count))
            if players.isEmpty { // First Time Opening App
                initializePlayer()
                initializeFish()
            } else {
                self.balance = players[0].balance
                DispatchQueue.main.async {
                    self.reloadBalance()
                }
            }
        } catch {
            // Handle error
        }
    }
    
    func getFish(){
        print("get fish")
        do{
            let fishes = try context.fetch(Fish.fetchRequest())
            if fishes.isEmpty{
                print("fatal error no fish")
            }
            else{
                for fish in fishes{
                    print(fish.fishType!)
                }
            }
        }
        catch{
            
        }
    }

    func initializePlayer() {
        print("initialized")
        let newPlayer = Player(context: context)
        newPlayer.balance = 0
        newPlayer.totalBalanceMade = 0
        try! context.save()
        self.balance = 0
        self.reloadBalance()
    }
    
    func initializeFish() {
        let fishes = AppConstants()
        
        let guppy = fishes.guppy
        let gold = fishes.goldFish
        
        let guppyFish = Fish(context: context)
        guppyFish.fishType = guppy.fishType
        guppyFish.cost = guppy.cost
        guppyFish.costMultiplier = guppy.costMultiplier
        guppyFish.production = guppy.production
        guppyFish.productionMultiplier = guppy.productionMultiplier
        guppyFish.fishLevel = guppy.fishLevel
        
        let goldFish = Fish(context: context)
        goldFish.fishType = gold.fishType
        goldFish.cost = gold.cost
        goldFish.costMultiplier = gold.costMultiplier
        goldFish.production = gold.production
        goldFish.productionMultiplier = gold.productionMultiplier
        goldFish.fishLevel = gold.fishLevel
        
        try! context.save()
        
    }

    func reloadBalance() {
        print("reload")
        balanceTitle.text = String(balance)
    }

    @objc private func buttonPressed() {
        do {
            let players = try context.fetch(Player.fetchRequest())
            players[0].balance += 5
            try context.save()
            getBalance()
        } catch {
            // Handle error
        }
    }
    
    // Function to remove all data
    @objc private func removeAllData() {
        do {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Player.fetchRequest()
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                        
            
            try context.execute(batchDeleteRequest)
            try context.save()
            
            // Reset your balance or perform any other necessary actions
            balance = 0
            reloadBalance()
            
            print("All data removed successfully.")
        } catch {
            print("Failed to remove all data: \(error)")
        }
    }
    
    private func createCard(target: Any) -> UIView{
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        let breedButton: UIButton = {
            let button = UIButton()
            button.backgroundColor = .black
            button.setTitle("fish name", for: .normal)
            button.addTarget(target, action: #selector(breedButtonPressed), for: .touchUpInside)
            return button
        }()
        
        let fishLevelLabel: UILabel = {
            let label = UILabel()
            label.backgroundColor = .cyan
            label.text = "1/25"
            label.textAlignment = .center
            return label
        }()
        
        let purchaseButton: UIButton = {
            let button = UIButton()
            button.backgroundColor = .gray
            button.setTitle("purchase", for: .normal)
            button.addTarget(target, action: #selector(purchaseButtonPressed), for: .touchUpInside)
            return button
        }()
        
        card.addSubview(breedButton)
        card.addSubview(fishLevelLabel)
        card.addSubview(purchaseButton)
        
        breedButton.translatesAutoresizingMaskIntoConstraints = false
        fishLevelLabel.translatesAutoresizingMaskIntoConstraints = false
        purchaseButton.translatesAutoresizingMaskIntoConstraints = false
        
        //Breed Button
        NSLayoutConstraint.activate([
            breedButton.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 10),
            breedButton.topAnchor.constraint(equalTo: card.topAnchor, constant: 10),
            breedButton.widthAnchor.constraint(equalToConstant: 100),
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
            purchaseButton.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -10),
            purchaseButton.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            purchaseButton.widthAnchor.constraint(equalToConstant: 80),
            purchaseButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        return card
    }
    
    @objc private func breedButtonPressed() {
        print("Breed button pressed")
        // Add your custom logic here for breed button action
    }

    @objc private func purchaseButtonPressed() {
        print("Purchase button pressed")
        // Add your custom logic here for purchase button action
    }
}
