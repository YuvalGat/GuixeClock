import UIKit
import Foundation

// Returns a CAShapeLayer representing a circle
public func getCircleLayer(x: Int, y: Int, r: Int, color: CGColor) -> CAShapeLayer {
    let circlePath = UIBezierPath(arcCenter: CGPoint(x: x, y: y), radius: CGFloat(r), startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
    
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = circlePath.cgPath
    
    shapeLayer.fillColor = color
    return shapeLayer
}

// Returns the CGPoint with coordinates corresponding to the given hour
public func getCoordinatesOfLabelByHour(hr: Int) -> CGPoint {
    let theta = Double(mod(30 * hr - 90, 360))
    return CGPoint(
        x: 262 * cosd(theta) + 300,
        y: 262 * sind(theta) + 300
    )
}

// Returns the SoWhat-Regular.ttf font, with a given font size
public func getSoWhatFont(size: Int) -> UIFont {
    let fontCFURL = Bundle.main.url(forResource: "SoWhat-Regular", withExtension: "ttf")! as CFURL
    
    CTFontManagerRegisterFontsForURL(fontCFURL, CTFontManagerScope.process, nil)
    
    return UIFont(name: "SoWhat-Regular", size: CGFloat(size))!
}
