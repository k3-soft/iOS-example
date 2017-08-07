//
//  AnswerSelectionCell.swift
//  Movask
//
//  Created by Alina Yehorova on 07.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

protocol AnswerSelectionCellDelegate: class {
    func answerSelected(cell: AnswerSelectionCell)
}

class AnswerSelectionCell: UITableViewCell {
    
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var heightAnswerLabel: NSLayoutConstraint!
    
    @IBOutlet weak var checkboxButton: UIButton! {
        didSet {
            checkboxButton.touchAreaEdgeInsets = .init(top: -10, left: -10, bottom: -10, right: -10)
        }
    }
    
    weak var delegate: AnswerSelectionCellDelegate?
    var checked = false
    
    var answer: AnswerTest?
    
    // Sizes
    
    static var cellHeight: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 25.0
        } else {
            return 25.0
        }
    }
    
    static let textOffset: CGFloat = 73.0
    
    func setWithAnswer(_ answer: AnswerTest) {
        
        self.answer = answer
        
        // Get answer height
        
        let height = AnswerCheckboxCell.getCellHeightFor(viewWidth: bounds.width, answer: answer)
        
        heightAnswerLabel.constant = height
        answerLabel.text = answer.title
    }
    
    // MARK: - Actions
    
    @IBAction func ckeckboxDidTap(_ sender: UIButton) {
        
        checked = !checked
        answer?.isSelected = checked
        
        delegate?.answerSelected(cell: self)
    }
    
    // MARK: - Class functions
    
    static func getTextHeight(answer: AnswerTest, cellWidth: CGFloat) -> CGFloat {
        
        return answer.title.textHeightWithFont(size: 15.0, name: "Solomon-Sans-SemiBold", viewWidth: cellWidth - textOffset, offset: 0.0)
    }
    
    static func getCellHeightFor(viewWidth: CGFloat, answer: AnswerTest) -> CGFloat {
        
        let textHeight = getTextHeight(answer: answer, cellWidth: viewWidth)
        
        return cellHeight + textHeight
    }
}
