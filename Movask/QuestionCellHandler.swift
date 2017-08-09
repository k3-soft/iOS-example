//
//  QuestionCellInterface.swift
//  Movask
//
//  Created by Alina Yehorova on 10.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import Foundation

protocol QuestionCellHandler {
    
    var confirmHandler: (()->())? { get set }
    var skipHandler: (()->())? { get set }
}
