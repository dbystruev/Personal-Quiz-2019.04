//
//  ResultsViewController.swift
//  Personal Quiz
//
//  Created by Denis Bystruev on 14/05/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    // MARK: IB Outlets
    @IBOutlet weak var resultAnswerLabel: UILabel!
    @IBOutlet weak var resultDefinitionLabel: UILabel!
    
    // MARK: - Stored Properties
    var responses: [Answer]!
}

// MARK: - UIViewController Methods
extension ResultsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        updateResult()
    }
}

// MARK: - Update User Interface
extension ResultsViewController {
    func updateResult() {
        var frequencyOfAnswers = [AnimalType: Int]()
        let responseTypes = responses.map { $0.type }
        
        for response in responseTypes {
            frequencyOfAnswers[response] = (frequencyOfAnswers[response] ?? 0) + 1
        }
        
        let frequencyOfAnswersSorted = frequencyOfAnswers.sorted { $0.value > $1.value }
        guard let mostFrequentAnswer = frequencyOfAnswersSorted.first?.key else { return }
        
        updateUI(with: mostFrequentAnswer)
    }
    
    func updateUI(with animalType: AnimalType) {
        resultAnswerLabel.text = "Вы — \(animalType.rawValue)!"
        resultDefinitionLabel.text = animalType.definition
    }
}
