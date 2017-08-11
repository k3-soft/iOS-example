//
//  QuestionCell.swift
//  Movask
//
//  Created by Alina Yehorova on 04.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class QuestionCell: UICollectionViewCell, QuestionCellHandler {
    
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
    
    // Selection
    var selectedIndex: Int?
    
    // Handlers
    var confirmHandler: (()->())?
    var skipHandler: (()->())?
    
    // Sizes
    
    let heightQuestionViewWithoutLabel: CGFloat = 45.0
    
    static var cellHeight: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 435.0
        } else {
            return 453.0
        }
    }
    
    // TableView
    
    @IBOutlet weak var answersTableView: UITableView!
    
    let ckeckboxCellIdentifier = "AnswerCheckboxCell"
    let radiobuttonCellIdentifier = "AnswerRadiobuttonCell"
    let gapCellIdentifier = "AnswerGapCell"
    
    // MARK: - Set cell

    func setWithQuestion(_ question: QuestionTest) {
        
        self.question = question
        
        setAnswersTableView()
        
        // Get question height
        
        let height = question.question.textHeightWithFont(size: 16.0, name: "Solomon-Sans-SemiBold", viewWidth: bounds.width, offset: 0.0)
        
        heightQuestionLabel.constant = height
        heightQuestionView.constant = height + heightQuestionViewWithoutLabel
        
        // Set labels
        
        questionLabel.text = question.question
        instructionLabel.text = question.type.instruction
    }
    
    func setAnswersTableView() {
        
        answersTableView.delegate = self
        answersTableView.dataSource = self
        answersTableView.contentInset = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        let cellIdentifiers = [ckeckboxCellIdentifier, radiobuttonCellIdentifier]
        
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
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ckeckboxCellIdentifier, for: indexPath) as! AnswerCheckboxCell
            
            cell.setWithAnswer(question!.answers[indexPath.row])
            cell.selectionStyle = .none
            
            return cell
            
        case .radiobuttons:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: radiobuttonCellIdentifier, for: indexPath) as! AnswerRadiobuttonCell
            
            cell.setWithAnswer(question!.answers[indexPath.row])
            cell.delegate = self
            cell.selectionStyle = .none
            
            return cell
            
        case .gaps:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let answer = question!.answers[indexPath.row]
        
        switch question!.type {
        case .checkmarks, .radiobuttons:
            return AnswerSelectionCell.getCellHeightFor(viewWidth: bounds.width, answer: answer)
            
        case .gaps:
            return 50.0
        }
    }
}

extension QuestionCell: AnswerSelectionCellDelegate {
    
    func answerSelected(cell: AnswerSelectionCell) {
        
        if question!.type == .radiobuttons {
            
            guard let newSelectedIndex = answersTableView.indexPath(for: cell)?.row else { return }
            
            // Deselect previous cell
            
            if  selectedIndex != nil, let cellToDeselect = answersTableView.cellForRow(at: IndexPath(row: selectedIndex!, section: 0)) as? AnswerRadiobuttonCell {
                
                cellToDeselect.checked = false
                cellToDeselect.answer?.isSelected = false
            }
            
            // Select new answer
            
            if selectedIndex != nil, selectedIndex! == newSelectedIndex {
                selectedIndex = nil
            } else {
                selectedIndex = newSelectedIndex
            }
        }
    }
}
