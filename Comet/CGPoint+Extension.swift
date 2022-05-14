//
//  CGPoint+Extension.swift
//  Comet
//
//  Created by Stuart Wallace on 5/2/22.
//

import Foundation


extension CGPoint {
    func distance(from point: CGPoint) -> CGFloat { hypot(point.x - x, point.y - y) }
}
