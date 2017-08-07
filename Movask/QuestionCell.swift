//
//  QuestionCell.swift
//  Movask
//
//  Created by Alina Yehorova on 04.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class QuestionCell: UICollectionViewCell {
    
    // Labels
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    // Constraints
    @IBOutlet weak var heightQuestionLabel: NSLayoutConstraint!
    @IBOutlet weak var heightQuestionView: NSLayoutConstraint!
    
    // Data
    var question: QuestionTest?
    
    // Handlers
    var confirmHandler: (()->())?
    var skipHandler: (()->())?
    
    // Sizes
    
    let heightQuestionViewWithoutLabel: CGFloat = 43.0
    
    static var cellHeight: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 435.0
        } else {
            return 435.0
        }
    }
    
    // TableView
    
    @IBOutlet weak var answersTableView: UITableView!
    
    let checkboxCellIdentifier = "AnswerCheckboxCell"
    let radiobuttonCellIdentifier = "AnswerRadiobuttonCell"
    let gapCellIdentifier = "AnswerGapCell"
    
    // MARK: - Set cell

    func setWithQuestion(_ question: QuestionTest) {
        
        self.question = question
        
        setAnswersTableView()
        
        // Get question height
        
        let height = question.question.textHeightWithFont(size: 15.0, name: "Solomon-Sans-SemiBold", viewWidth: bounds.width, offset: 0.0)
        
        heightQuestionLabel.constant = height
        heightQuestionView.constant = height + heightQuestionViewWithoutLabel
        questionLabel.text = question.question
    }
    
    func setAnswersTableView() {
        
        answersTableView.delegate = self
        answersTableView.dataSource = self
        answersTableView.contentInset = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        let cellIdentifiers = [checkboxCellIdentifier, radiobuttonCellIdentifier, gapCellIdentifier]
        
        for identifier in cellIdentifiers {
            answersTableView.register(UINib(nibName: identifier, bundle: nil),
                                      forCellReuseIdentifier: identifier)
        }
        
        answersTableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func confirmDidTap(_ sender: UIButton) {
        confirmHandler?()
    }
    
    @IBAction func skipDidTap(_ sender: UIButton) {
        skipHandler?()
    }
}

extension QuestionCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question!.answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch question!.type {
        case .checkmarks:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: checkboxCellIdentifier, for: indexPath) as! AnswerCheckboxCell
            
            cell.setWithAnswer(question!.answers[indexPath.row])
            
            return cell
            
        case .radiobuttons:
            return UITableViewCell()
            
        case .gaps:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let answer = question!.answers[indexPath.row]
        
        switch question!.type {
        case .checkmarks:
            return AnswerCheckboxCell.getCellHeightFor(viewWidth: bounds.width, answer: answer)
            
        case .radiobuttons:
            return 50.0
            
        case .gaps:
            return 50.0
        }
    }
}
