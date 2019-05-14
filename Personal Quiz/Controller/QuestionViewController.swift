//
//  QuestionViewController.swift
//  Personal Quiz
//
//  Created by Denis Bystruev on 30/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

/// Question Screen
class QuestionViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var singleStackView: UIStackView!
    @IBOutlet var singleButtons: [UIButton]!
    
    @IBOutlet weak var multipleStackView: UIStackView!
    @IBOutlet var multiLabels: [UILabel]!
    @IBOutlet var multiSwitches: [UISwitch]!
    
    @IBOutlet weak var rangedStackView: UIStackView!
    @IBOutlet var rangedLabels: [UILabel]!
    @IBOutlet weak var rangedSlider: UISlider!
    
    @IBOutlet weak var questionProgressView: UIProgressView!
    
    // MARK: - Stored Properties
    /// Answers chosen by user
    var answersChosen = [Answer]()
    
    /// Index of current question
    var questionIndex = 0
    
    /// List of questions
    var questions = Question.loadData()
}

// MARK: - IB Actions
extension QuestionViewController {
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
        let currentAnswers = questions[questionIndex].answers
        guard let buttonIndex = singleButtons.firstIndex(of: sender) else { return }
        let answer = currentAnswers[buttonIndex]
        answersChosen.append(answer)
        
        nextQuestion()
    }
    
    @IBAction func multiAnswerButtonPressed() {
        let currentAnswers = questions[questionIndex].answers
        for (multiSwitch, answer) in zip(multiSwitches, currentAnswers) {
            if multiSwitch.isOn {
                answersChosen.append(answer)
            }
        }
        
        nextQuestion()
    }
    
    @IBAction func rangedAnswerButtonPressed() {
        let currentAnswers = questions[questionIndex].answers
        let index = Int(round(rangedSlider.value * Float(currentAnswers.count - 1)))
        answersChosen.append(currentAnswers[index])
        
        nextQuestion()
    }
}

// MARK: - Navigation
extension QuestionViewController {
    /// Show next question or go to the next screen
    func nextQuestion() {
        questionIndex += 1
        
        if questionIndex < questions.count {
            updateUI()
        } else {
            performSegue(withIdentifier: "ResultsSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ResultsSegue" else { return }
        guard let destination = segue.destination as? ResultsViewController else { return }
        destination.responses = answersChosen
    }
}

// MARK: - UIViewController Methods
extension QuestionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // update user interface
        updateUI()
    }
}

// MARK: - User Interface
extension QuestionViewController {
    /// Updates user interface
    func updateUI() {
        // hide everything
        for stackView in [singleStackView, multipleStackView, rangedStackView] {
            stackView?.isHidden = true
        }
        
        // get current question
        let currentQuestion = questions[questionIndex]
        
        questionLabel.text = currentQuestion.text
        
        // get current answers
        let currentAnswers = currentQuestion.answers
        
        // calculate progress
        let totalProgress = Float(questionIndex) / Float(questions.count)
        
        // set progress for questionProgressView
        questionProgressView.setProgress(totalProgress, animated: true)
        
        // set navigation title
        navigationItem.title = "Вопрос № \(questionIndex + 1) из \(questions.count)"
        
        // show stack view corresponding to question type
        switch currentQuestion.type {
        case .single:
            updateSingleStack(using: currentAnswers)
        case .multiple:
            updateMultipleStack(using: currentAnswers)
        case .ranged:
            updateRangedStack(using: currentAnswers)
        }
    }
    
    /// Setup single stack view
    ///
    /// - Parameter answers: [Answer] array with answers
    func updateSingleStack(using answers: [Answer]) {
        // show single stack view
        singleStackView.isHidden = false
        
        for (button, answer) in zip(singleButtons, answers) {
            button.setTitle(answer.text, for: [])
        }
    }
    
    /// Setup multiple stack view
    ///
    /// - Parameter answers: [Answer] array with answers
    func updateMultipleStack(using answers: [Answer]) {
        // show multiple stack view
        multipleStackView.isHidden = false
        
        for (label, answer) in zip (multiLabels, answers) {
            label.text = answer.text
        }
    }
    
    /// Setup ranged stack view
    ///
    /// - Parameter answers: [Answer] array with answers
    func updateRangedStack(using answers: [Answer]) {
        // show ranged stack view
        rangedStackView.isHidden = false
        
        rangedLabels.first?.text = answers.first?.text
        rangedLabels.last?.text = answers.last?.text
    }
}
