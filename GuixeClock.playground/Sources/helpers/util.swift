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
        x: 280 * cosd(theta) + 250,
        y: 280 * sind(theta) + 280
    )
}

// Returns the paradise_road.ttf font, with a given size
public func getParadiseRoadFont(size: Int) -> UIFont {
    let fontCFURL = Bundle.main.url(forResource: "paradise_road", withExtension: "ttf")! as CFURL
    
    CTFontManagerRegisterFontsForURL(fontCFURL, CTFontManagerScope.process, nil)
    
    let paradiseRoad = UIFont(name: "ParadiseRoad", size: CGFloat(size))!
    
    return paradiseRoad
}
