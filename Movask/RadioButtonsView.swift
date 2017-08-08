//
//  RadioButtonsView.swift
//  Movask
//
//  Created by mac on 08.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

@objc
protocol RadioButtonsViewDelegate: class {
    @objc optional func radioWasSelectedOn(view: RadioButtonsView, with option: String)
    func answerVariantWasAdded(view: RadioButtonsView)
}

class RadioButtonsView: NibView, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var optionsTableView: UITableView!
    let cellHeight: CGFloat = 30.0
    
    let radioCell = "RadioCell"
    
    weak var delegate: RadioButtonsViewDelegate?
    weak var ownerCollectionView: UICollectionView?
    
    var answerVariants = [""]
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    
    var selectedItem: String? {
        if selectedIndexPath.row < answerVariants.count {
            return answerVariants[selectedIndexPath.row]
        } else {
            return nil
        }
    }
    
    override func setupViews() {
        setTableView()
    }
    
    func setTableView() {
        optionsTableView.dataSource = self
        optionsTableView.delegate = self
        optionsTableView.separatorStyle = .none
        optionsTableView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: -8)
        
        optionsTableView.register(UINib(nibName: radioCell, bundle: nil),
                            forCellReuseIdentifier: radioCell)
    }
    
    //MARK:- Actions
    
    func addAnswerVariant() {
        answerVariants.append("")
        optionsTableView.beginUpdates()
        optionsTableView.insertRows(at: [IndexPath(row: answerVariants.count-1, section: 0)], with: .bottom)
        optionsTableView.endUpdates()
        delegate?.answerVariantWasAdded(view: self)
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answerVariants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: radioCell, for: indexPath) as! RadioCell
        
        cell.selectionStyle = .none
        cell.radioTextView.text = answerVariants[indexPath.row]
        
        if indexPath == selectedIndexPath {
            cell.selectedCell = true
        } else {
            cell.selectedCell = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let oldSelectedCell = tableView.cellForRow(at: selectedIndexPath) as! RadioCell
        oldSelectedCell.selectedCell = false
        
        let newSelectedCell = tableView.cellForRow(at: indexPath) as! RadioCell
        newSelectedCell.selectedCell = true
        delegate?.radioWasSelectedOn?(view: self, with: answerVariants[indexPath.row])
        
        selectedIndexPath = indexPath
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = UnderLinedTextView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width - 8, height: 30), textContainer: nil)
        footerView.backgroundColor = UIColor.clear
        footerView.placeholder = "Add option"
        footerView.isEditable = false
        footerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (addAnswerVariant)))
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return cellHeight
    }
}
