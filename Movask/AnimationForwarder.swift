//
//  AnimationForwarder.swift
//  Movask
//
//  Created by Alina Yehorova on 09.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

/**
 Internal class used to forward the layer actions from the backing view to a layer.
 It should be used as the delegate of a layer.
 */
internal class AnimationForwarder: UIView {
    
    fileprivate weak var backingView: UIView?
    
    internal convenience init(view: UIView) {
        self.init()
        backingView = view
    }
    
    override func action(for layer: CALayer, forKey event: String) -> CAAction? {
        return backingView?.action(for: layer, forKey: event)
    }
}
