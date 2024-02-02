import Foundation
import UIKit


class FirstFishCard: UIView{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    weak var viewController: ViewController?
    
    var progressBar: UIProgressView?
    var progressBarTimer: Timer?
    var currentSecond: Int64 = 0
    
    var isInProgress: Bool = false
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
        
        progressBar = UIProgressView(progressViewStyle: .default)
        progressBar?.translatesAutoresizingMaskIntoConstraints = false
        progressBar?.progress = 0.0
        addSubview(progressBar!)
        // Set the progress bar constraints
        if let progressBar = progressBar {
            NSLayoutConstraint.activate([
                progressBar.leadingAnchor.constraint(equalTo: breedButton.trailingAnchor, constant: 10),
                progressBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                progressBar.topAnchor.constraint(equalTo: breedButton.topAnchor),
                progressBar.bottomAnchor.constraint(equalTo: purchaseButton.topAnchor, constant: -10)
            ])
        }
    }
    
    func updateProgressBar(duration: TimeInterval) {
        guard let progressBar = progressBar else {
            return
        }
        if isInProgress == false{
            self.isInProgress = true
            progressBar.progress = 0.0
            var totalTimeInterval: TimeInterval = 0.0
            var roundedTotalTimeInterval = 0.0
            // Use Timer to update the progress bar over time
            progressBarTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                progressBar.progress += 0.1 / Float(duration)
                

            
                totalTimeInterval += timer.timeInterval
                roundedTotalTimeInterval = round(100 * totalTimeInterval) / 100
                
                if roundedTotalTimeInterval.truncatingRemainder(dividingBy: 1) == 0 {
                    self.currentSecond = Int64(roundedTotalTimeInterval)
                    // The value is a whole number
                    print(roundedTotalTimeInterval)
                    do{
                        
                    }
                    
                    catch{
                        print("error saving state of progress bar")
                    }
                }
                
                if progressBar.progress >= 1.0 {
                    timer.invalidate()
                    progressBar.progress = 0.0
                    self.isInProgress = false
                    self.breedCompleted()
                    
                    // Add any additional logic when the progress bar completes
                }
            }
        }
        else{
            print("in progress")
        }

    }
    func breedCompleted(){
        do{
            let players = try context.fetch(Player.fetchRequest())
            players[0].balance += self.production
            try context.save()
            viewController?.getBalance()
        }
        catch{
            
        }
    }
    @objc private func breedButtonPressed() {
        updateProgressBar(duration: 5.0)
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
    
    @objc func stopProgressBarTimer() {
        
        do{
            print("The last status before interuption--", String(self.currentSecond))
            let gameState = try self.context.fetch(GameStateManager.fetchRequest())
            if gameState.isEmpty{
                let newFirstFishState = GameStateManager(context: self.context)
                newFirstFishState.firstFishStatus = self.currentSecond
                try self.context.save()
            }
            else{
                gameState[0].firstFishStatus = self.currentSecond
                try self.context.save()
            }
            
        }
        catch{
            
        }
        
        progressBarTimer?.invalidate()
        progressBarTimer = nil
        isInProgress = false
    }
    
}




