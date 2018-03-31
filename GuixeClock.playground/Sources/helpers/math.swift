import Foundation
import UIKit

/*:
 - Note:
 A lot of mathematics were applied here. The general formula for rotating (x, y) around (0, 0) by angle θ is shown in the PDF file. θ is calculated for the minutes hand and for the hours hand, after which we apply the formulas for each of the arrow's coordinates.
 
 The variables h, l1, d, k1, l2, k2 are also described in the PDF file.
 
 Even though I coulf have returned an array, I decided to use a dictionary to make sure each variable name is clear.
 
 The PDF File was generated with LaTeX using TikZ.
 */

public func getFrontArrowCoordinatesByTime(hr: Double, min: Double, h: Double, l1: Double, d: Double, k1: Double) -> [String: CGPoint] {
    let hrTheta: Double = Double(mod(Int(round(hr * 30 + min / 2)), 360))
    
    let arrowFrontBackTopX = -h * cosd(hrTheta) + 300
    let arrowFrontBackTopY = -h * sind(hrTheta) + 300
    
    let arrowFrontBackBottomX = h * cosd(hrTheta) + 300
    let arrowFrontBackBottomY = h * sind(hrTheta) + 300
    
    let arrowFrontMiddleBottomX = -l1 * cosd(hrTheta + 90) + h * sind(hrTheta + 90) + 300
    let arrowFrontMiddleBottomY = -l1 * sind(hrTheta + 90) - h * cosd(hrTheta + 90) + 300
    
    let arrowFrontMiddleBottomBottomX = l1 * cosd(hrTheta - 90) - (h + d) * sind(hrTheta - 90) + 300
    let arrowFrontMiddleBottomBottomY = l1 * sind(hrTheta - 90) + (h + d) * cosd(hrTheta - 90) + 300
    
    let arrowFrontPointyX = (l1 + k1) * cosd(hrTheta - 90) + 300
    let arrowFrontPointyY = (l1 + k1) * sind(hrTheta - 90) + 300
    
    let arrowFrontMiddleTopTopX = l1 * cosd(hrTheta - 90) - (-h - d) * sind(hrTheta - 90) + 300
    let arrowFrontMiddleTopTopY = l1 * sind(hrTheta - 90) + (-h - d) * cosd(hrTheta - 90) + 300
    
    let arrowFrontMiddleTopX = -l1 * cosd(hrTheta + 90) - h * sind(hrTheta + 90) + 300
    let arrowFrontMiddleTopY = -l1 * sind(hrTheta + 90) + h * cosd(hrTheta + 90) + 300
    
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
    
    let arrowBackInnerX = (l2 - k2) * sind(360 - minTheta) + 300
    let arrowBackInnerY = (l2 - k2) * cosd(360 - minTheta) + 300
    
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

public func mod(_ a: Int, _ n: Int) -> Int {
    let r = a % n
    return r >= 0 ? r : r + n
}
