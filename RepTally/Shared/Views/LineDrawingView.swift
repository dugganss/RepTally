//
//  LineDrawingView.swift
//  RepTally
//
//  Created by Samuel Duggan on 02/12/2024.
//

import UIKit

class LineDrawingView: UIView {
    var startPoint: CGPoint = .zero
    var endPoint: CGPoint = .zero
    
    override func draw(_ rect: CGRect) {
        //code adapted from Epic Defeater (2015)
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)  //Create UIBezierPath object and set start and end point
        
        path.close() //finish adding points to path
        
        UIColor.safeBlack.set() //set line colour
        path.lineWidth = 2.0 //set line width
        
        path.stroke() //draw line as configured above
        //end of adapted code
    }
}
