//
//  ReceiptFooter.swift
//  DigiPay
//
//  Created by Amirhesam Rayatnia on 2018-08-17.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

class ReceiptFooter: UITableViewHeaderFooterView {
    @IBOutlet weak var dashView: UIView!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        // drawDottedLine(start: CGPoint(x: 0, y: 0), end: CGPoint(x: rect.bounds.width, y: 0) , view: dashView)
    }
    
    func drawDottedLine(start p0: CGPoint, end p1: CGPoint, view: UIView) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [7, 3] // 7 is the length of dash, 3 is length of the gap.
        
        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
}
