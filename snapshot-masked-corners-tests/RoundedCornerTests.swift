//
//  RoundedCornerTests.swift
//  snapshot-masked-corners
//
//  Created by Aaron Connolly on 8/18/21.
//

import SnapshotTesting
import XCTest

final class RoundedCornerTests: XCTestCase {
    let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
    
    override func setUp() {
        //isRecording = true
    }
    
    func testRoundCorners() {
        let v = UIView(frame: rect)
        v.backgroundColor = .green
        
        v.roundCorners([.bottomLeft, .bottomRight], radius: 20)
        
        assertSnapshot(matching: v, as: .image)
    }
    
    func testLayerCornerRadius() {
        let v = UIView(frame: rect)
        v.backgroundColor = .red
        
        v.layer.cornerRadius = 20.0
        v.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            
        // Fails to correctly mask the bottom left and bottom right corners
        assertSnapshot(matching: v, as: .image)
    }
    
    func testLayerCornerRadiusWithKeyWindowDrawing() {
        let v = UIView(frame: rect)
        v.backgroundColor = .blue
        
        v.layer.cornerRadius = 20.0
        v.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        // Correctly masks the bottom left and bottom right corners
        assertSnapshot(matching: v, as: .image(drawHierarchyInKeyWindow: true))
    }
}

// Round Corners
fileprivate extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoun        dingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
