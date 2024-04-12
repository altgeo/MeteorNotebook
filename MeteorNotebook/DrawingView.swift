//
//  DrawingView.swift
//  MeteorNotebook
//
//  Created by Nikolay Ivanov on 2.04.24.
//

import UIKit

class DrawingView: UIView {

    
    private var touchedPoints = [CGPoint]()
    private var bezierPaths = [UIBezierPath]()
    var strokeColor =  UIColor.black {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    func addTouchedPoint (pointToAdd:CGPoint) {
        touchedPoints.append(pointToAdd)
        //TODO: can we optimize by only redrawing rect between last two points
        self.setNeedsDisplay()
    }
    
    func finishPath() {
        guard !touchedPoints.isEmpty else {
            return
        }
        
        let path = UIBezierPath()
        
        path.move(to: touchedPoints[0])
        var pointNum = 1
        while pointNum < touchedPoints.count - 1 {
            path.addLine(to: touchedPoints[pointNum])
            pointNum += 1
        }
        self.bezierPaths.append(path)
        
        self.touchedPoints.removeAll()
    }
    
    func clearView() {
        touchedPoints.removeAll()
        bezierPaths.removeAll()
        self.setNeedsDisplay()
    }
//     Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        strokeColor.setStroke()
        for path in bezierPaths {
            path.stroke()
        }
        guard let context = UIGraphicsGetCurrentContext(), !touchedPoints.isEmpty else {
            return
        }
        
        context.move(to: touchedPoints[0])
        var pointNum = 1
        while pointNum < touchedPoints.count - 1 {
            context.addLine(to: touchedPoints[pointNum])
            pointNum += 1
        }
        
        context.strokePath()
    }
    

}
