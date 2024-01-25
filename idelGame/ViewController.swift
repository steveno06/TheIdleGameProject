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

    func initializePlayer() {
        print("initialized")
        let newPlayer = Player(context: context)
        newPlayer.balance = 0
        newPlayer.totalBalanceMade = 0
        try! context.save()
        self.balance = 0
        self.reloadBalance()
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
}
