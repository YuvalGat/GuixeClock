import UIKit
import Foundation

public func getCircleLayer(x: Int, y: Int, r: Int, color: CGColor) -> CAShapeLayer {
    let circlePath = UIBezierPath(arcCenter: CGPoint(x: x, y: y), radius: CGFloat(r), startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
    
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = circlePath.cgPath
    
    shapeLayer.fillColor = color
    return shapeLayer
}

/*:
 - Note:
 A lot of mathematics were applied here. The general formula for rotating (x, y) around (0, 0) by angle θ is shown in the PDF file. θ is calculated for the minutes hand and for the hours hand, after which we apply the formulas for each of the arrow's coordinates.
 
 The variables h, l1, d, k1, l2, k2 are also described in the PDF file.
 
 I've decided to use a Dictionary instead of an array for readability reasons.
 
 The PDF File was generated with LaTeX using TikZ.
 */

public func getFrontArrowCoordinatesByTime(hr: Double, min: Double, h: Double, l1: Double, d: Double, k1: Double) -> [String: CGPoint] {
    let hrTheta: Double = (hr * 30 + min / 2).truncatingRemainder(dividingBy: 360);
    
    let arrowFrontBackTopX = -h * cosd(hrTheta) + 300;
    let arrowFrontBackTopY = -h * sind(hrTheta) + 300;
    
    let arrowFrontBackBottomX = h * cosd(hrTheta) + 300;
    let arrowFrontBackBottomY = h * sind(hrTheta) + 300;
    
    let arrowFrontMiddleBottomX = -l1 * cosd(hrTheta + 90) + h * sind(hrTheta + 90) + 300;
    let arrowFrontMiddleBottomY = -l1 * sind(hrTheta + 90) - h * cosd(hrTheta + 90) + 300;
    
    let arrowFrontMiddleBottomBottomX = l1 * cosd(hrTheta - 90) - (h + d) * sind(hrTheta - 90) + 300;
    let arrowFrontMiddleBottomBottomY = l1 * sind(hrTheta - 90) + (h + d) * cosd(hrTheta - 90) + 300;
    
    let arrowFrontPointyX = (l1 + k1) * cosd(hrTheta - 90) + 300;
    let arrowFrontPointyY = (l1 + k1) * sind(hrTheta - 90) + 300;
    
    let arrowFrontMiddleTopTopX = l1 * cosd(hrTheta - 90) - (-h - d) * sind(hrTheta - 90) + 300;
    let arrowFrontMiddleTopTopY = l1 * sind(hrTheta - 90) + (-h - d) * cosd(hrTheta - 90) + 300;
    
    let arrowFrontMiddleTopX = -l1 * cosd(hrTheta + 90) - h * sind(hrTheta + 90) + 300;
    let arrowFrontMiddleTopY = -l1 * sind(hrTheta + 90) + h * cosd(hrTheta + 90) + 300;
    
    return [
        "backTop": CGPoint(x: arrowFrontBackTopX, y: arrowFrontBackTopY),
        "backBottom": CGPoint(x: arrowFrontBackBottomX, y: arrowFrontBackBottomY),
        "centerBottom": CGPoint(x: arrowFrontMiddleBottomX, y: arrowFrontMiddleBottomY),
        "lower": CGPoint(x: arrowFrontMiddleBottomBottomX, y: arrowFrontMiddleBottomBottomY),
        "tip": CGPoint(x: arrowFrontPointyX, y: arrowFrontPointyY),
        "upper": CGPoint(x: arrowFrontMiddleTopTopX, y: arrowFrontMiddleTopTopY),
        "centerTop": CGPoint(x: arrowFrontMiddleTopX, y: arrowFrontMiddleTopY),
    ]
}

public func getBackArrowCoordinatesByTime(min: Double, h: Double, l2: Double, k2: Double) -> [String: CGPoint] {
    let minTheta = (min * 6 + 180).truncatingRemainder(dividingBy: 360)
    
    let arrowBackBackTopX = -h * cosd(minTheta) + 300
    let arrowBackBackTopY = -h * sind(minTheta) + 300
    
    let arrowBackUpperX = -h * cosd(minTheta) - l2 * sind(minTheta) + 300
    let arrowBackUpperY = -h * sind(minTheta) + l2 * cosd(minTheta) + 300
    
    let arrowBackInnerX = (l2 - k2) * sind(360 - minTheta) + 300;
    let arrowBackInnerY = (l2 - k2) * cosd(360 - minTheta) + 300;
    
    let arrowBackLowerX = h * cosd(minTheta) - l2 * sind(minTheta) + 300
    let arrowBackLowerY = h * sind(minTheta) + l2 * cosd(minTheta) + 300
    
    let arrowBackBackBottomX = h * cosd(minTheta) + 300
    let arrowBackBackBottomY = h * sind(minTheta) + 300
    
    return [
        "backTop": CGPoint(x: arrowBackBackTopX, y: arrowBackBackTopY),
        "upper": CGPoint(x: arrowBackUpperX, y: arrowBackUpperY),
        "inner": CGPoint(x: arrowBackInnerX, y: arrowBackInnerY),
        "lower": CGPoint(x: arrowBackLowerX, y: arrowBackLowerY),
        "backBottom": CGPoint(x: arrowBackBackBottomX, y: arrowBackBackBottomY),
    ]
}

public func sind(_ degrees: Double) -> Double {
    return __sinpi(degrees / 180.0)
}

public func cosd(_ degrees: Double) -> Double {
    return __cospi(degrees / 180.0)
}

public extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension Date {
    public func setTime(hour: Int, min: Int, sec: Int, timeZoneAbbrev: String = "UTC") -> Date? {
        let x: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.current
        var components = cal.dateComponents(x, from: self)
        
        components.timeZone = TimeZone(abbreviation: timeZoneAbbrev)
        components.hour = hour
        components.minute = min
        components.second = sec
        
        return cal.date(from: components)
    }
}

public func getClosestRoundMinute() -> Date {
    var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
    
    let currentHour: Int = Calendar.current.component(.hour, from: Date())
    let currentMinute: Int = Calendar.current.component(.minute, from: Date())
    
    let inOneMinute = Date().setTime(hour: currentHour, min: currentMinute + 1, sec: 0, timeZoneAbbrev: localTimeZoneAbbreviation)
    
    return inOneMinute!
}

func mod(_ a: Int, _ n: Int) -> Int {
    let r = a % n
    return r >= 0 ? r : r + n
}

public func getCoordinatesOfLabelByHour(hr: Int) -> CGPoint {
    let theta = Double(mod(30 * hr - 90, 360))
    return CGPoint(
        x: 280 * cosd(theta) + 250,
        y: 280 * sind(theta) + 280
    )
}

public func getCurrentHour() -> Double {
    return Double(Calendar.current.component(.hour, from: Date()))
}

public func getCurrentMinute() -> Double {
    return Double(Calendar.current.component(.minute, from: Date()))
}
