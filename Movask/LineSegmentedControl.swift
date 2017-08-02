//
//  LineSegmentedControl.swift
//  Movask
//
//  Created by Alina Yehorova on 02.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

protocol LineSegmentedControlDelegate: class {
    func lineSegmentedControl(_ control: LineSegmentedControl, didChangeSelection index: Int)
}

class LineSegmentedControl: NibView {
    
    private static let lineHeight: CGFloat = 2.0
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var activeLine: UIView!
    
    weak var delegate: LineSegmentedControlDelegate?
    
    private var lastCreatedCellIndex = -1
    
    private(set) var cells: [LineSegmentedControlCell] = []
    private(set) var selectedCell: LineSegmentedControlCell?
    var selectionIndex: Int? {
        return selectedCell?.index
    }
    
    func createCell(title: String? = "Title") {
        
        let newCell = LineSegmentedControlCell()
        
        lastCreatedCellIndex += 1
        
        newCell.index = lastCreatedCellIndex
        newCell.title = title!
        
        if lastCreatedCellIndex == 0 {
            selectedCell = newCell
            selectedCell?.setToSelectedState(true)
        }
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(cellDidTap(_:)))
        newCell.addGestureRecognizer(recognizer)
        
        cells.append(newCell)
        stackView.addArrangedSubview(newCell)
    }
    
    func cellDidTap(_ recognizer: UITapGestureRecognizer) {
        
        guard let tappedCell = recognizer.view as? LineSegmentedControlCell else { return }
        
        selectCell(tappedCell)
    }
    
    func selectCell(_ cell: LineSegmentedControlCell) {
        
        selectedCell?.setToSelectedState(false)
        cell.setToSelectedState(true)
        
        selectedCell = cell
        
        delegate?.lineSegmentedControl(self, didChangeSelection: selectedCell!.index)
        
        updateLineState()
    }
    
    func selectCellAtIndex(_ index: Int) {
        
        guard index < cells.count else { return }
        
        selectCell(cells[index])
    }
    
    func updateLineState() {
        
        guard selectedCell != nil else { return }
        
        let newX = selectedCell!.frame.origin.x
        let newWidth = selectedCell!.frame.width
        
        updateLine(newX: newX, newWidth: newWidth)
    }
    
    func updateLineStateWith(width: CGFloat) {
        
        guard selectedCell != nil else { return }
        
        let newWidth = width / CGFloat(cells.count)
        let newX = CGFloat(selectionIndex ?? 0) * newWidth
        
        updateLine(newX: newX, newWidth: newWidth)
    }
    
    func updateLine(newX: CGFloat, newWidth: CGFloat) {
        
        let newY = frame.height - LineSegmentedControl.lineHeight
        let newHeight = LineSegmentedControl.lineHeight
        
        UIView.animate(withDuration: 0.4, animations: {
            self.activeLine.frame = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
        })
    }
}
