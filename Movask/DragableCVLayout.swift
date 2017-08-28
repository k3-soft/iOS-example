//
//  DragableCVLayout.swift
//  Movask
//
//  Created by mac on 28.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class DragableCVLayout: UICollectionViewFlowLayout {
    
    override func invalidationContext(forInteractivelyMovingItems targetIndexPaths: [IndexPath], withTargetPosition targetPosition: CGPoint, previousIndexPaths: [IndexPath], previousPosition: CGPoint) -> UICollectionViewLayoutInvalidationContext {
        
        let context = super.invalidationContext(forInteractivelyMovingItems: targetIndexPaths, withTargetPosition: targetPosition, previousIndexPaths: previousIndexPaths, previousPosition: previousPosition)
        
        self.collectionView?.dataSource?.collectionView!(self.collectionView!, moveItemAt: previousIndexPaths[0], to: targetIndexPaths[0])
        
        return context
    }
    
    
}
