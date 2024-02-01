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
    
    private let logOffLabel: UILabel = {
        let label = UILabel()
        label.text = "time"
        label.backgroundColor = .cyan
        return label
    }()
    
    private let progressBarState: UILabel = {
        let label = UILabel()
        label.text = "text"
        label.backgroundColor = .red
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        getBalance()
        getFish()
        getLastLogOff()
    }

    private func setupUI() {
        // Balance Title
        view.addSubview(balanceTitle)
        balanceTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            balanceTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            balanceTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            balanceTitle.widthAnchor.constraint(equalToConstant: 200),
            balanceTitle.heightAnchor.constraint(equalToConstant: 50)
        ])

        let guppyCard = FirstFishCard(viewController: self)
        guppyCard.translatesAutoresizingMaskIntoConstraints = false
        guppyCard.backgroundColor = .systemMint
        guppyCard.layer.cornerRadius = 10
        guppyCard.layer.borderWidth = 2.0
        guppyCard.layer.borderColor = UIColor.black.cgColor
        
        view.addSubview(guppyCard)
        NSLayoutConstraint.activate([
            guppyCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            guppyCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            guppyCard.topAnchor.constraint(equalTo: balanceTitle.bottomAnchor, constant: 10),
            guppyCard.heightAnchor.constraint(equalToConstant: 100)
        ])
        
//        let goldFishCard = createCard(target: self, fish: fishes[1])
//        goldFishCard.translatesAutoresizingMaskIntoConstraints = false
//        goldFishCard.backgroundColor = .red
//        view.addSubview(goldFishCard)
//
//        NSLayoutConstraint.activate([
//            goldFishCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
//            goldFishCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
//            goldFishCard.topAnchor.constraint(equalTo: guppyCard.bottomAnchor, constant: 10),
//            goldFishCard.heightAnchor.constraint(equalToConstant: 100)
//        ])
        view.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 200),
            deleteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(logOffLabel)
        logOffLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logOffLabel.widthAnchor.constraint(equalToConstant: 200),
            logOffLabel.heightAnchor.constraint(equalToConstant: 50),
            logOffLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logOffLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func getBalance() {
        print("get balance")
        print(Date())
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
    
    func getLastLogOff(){
        do{
            let timeTracked = try context.fetch(TimerStateManager.fetchRequest())
            if timeTracked.isEmpty{
                print("fatal timer error")
            }
            else{
                let startDate = timeTracked[0].timeOfLogOff!
                let secondDate = Date()
                let differenceInSeconds: Int = secondsBetweenDates(startDate: startDate, endDate: secondDate)
                logOffLabel.text = "\(differenceInSeconds) Seconds Have Passed"
                
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
            
            // Remove data for TimerStateManager entity
            let timerFetchRequest: NSFetchRequest<NSFetchRequestResult> = TimerStateManager.fetchRequest()
            let timerBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: timerFetchRequest)
            
            try context.execute(timerBatchDeleteRequest)
            
            try context.save()
            
            // Reset your balance or perform any other necessary actions
            balance = 0
            reloadBalance()
            
            print("All data removed successfully.")
        } catch {
            print("Failed to remove all data: \(error)")
        }
    }
    
    func secondsBetweenDates(startDate: Date, endDate: Date) -> Int {
        let timeInterval = endDate.timeIntervalSince(startDate)
        return Int(timeInterval)
    }
}
