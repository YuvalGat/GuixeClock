import Foundation
import UIKit

/*:
 - Note:
 A lot of mathematics were applied here. The general formula for rotating (x, y) around (0, 0) by angle θ is shown in the PDF file under Sources/main.pdf. θ is calculated for the minutes hand and for the hours hand, after which we apply the formulas for each of the arrow's coordinates.
 
 The variables h, l1, d, k1, l2, k2 are also described in the PDF file.
 
 Even though I could have returned an array, I decided to use a dictionary to make sure each variable name is clear.
 
 The PDF File was generated with LaTeX using TikZ.
 */

fileprivate let xOffset: Double = 384.0
fileprivate let yOffset: Double = 300.0

public func getFrontArrowCoordinatesByTime(hr: Double, min: Double, h: Double, l1: Double, d: Double, k1: Double) -> [String: CGPoint] {
    let hrTheta: Double = Double(mod(Int(round(hr * 30 + min / 2)), 360))
    
    let arrowFrontBackTopX: Double = -h * cosd(hrTheta) + xOffset
    let arrowFrontBackTopY: Double = -h * sind(hrTheta) + yOffset
    
    let arrowFrontBackBottomX: Double = h * cosd(hrTheta) + xOffset
    let arrowFrontBackBottomY: Double = h * sind(hrTheta) + yOffset
    
    let arrowFrontMiddleBottomX: Double = -l1 * cosd(hrTheta + 90) + h * sind(hrTheta + 90) + xOffset
    let arrowFrontMiddleBottomY: Double = -l1 * sind(hrTheta + 90) - h * cosd(hrTheta + 90) + yOffset
    
    let arrowFrontMiddleBottomBottomX: Double = l1 * cosd(hrTheta - 90) - (h + d) * sind(hrTheta - 90) + xOffset
    let arrowFrontMiddleBottomBottomY: Double = l1 * sind(hrTheta - 90) + (h + d) * cosd(hrTheta - 90) + yOffset
    
    let arrowFrontPointyX: Double = (l1 + k1) * cosd(hrTheta - 90) + xOffset
    let arrowFrontPointyY: Double = (l1 + k1) * sind(hrTheta - 90) + yOffset
    
    let arrowFrontMiddleTopTopX: Double = l1 * cosd(hrTheta - 90) - (-h - d) * sind(hrTheta - 90) + xOffset
    let arrowFrontMiddleTopTopY: Double = l1 * sind(hrTheta - 90) + (-h - d) * cosd(hrTheta - 90) + yOffset
    
    let arrowFrontMiddleTopX: Double = -l1 * cosd(hrTheta + 90) - h * sind(hrTheta + 90) + xOffset
    let arrowFrontMiddleTopY: Double = -l1 * sind(hrTheta + 90) + h * cosd(hrTheta + 90) + yOffset
    
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
    let minTheta: Double = Double(mod(Int(min * 6 + 180), 360))
    
    let arrowBackBackTopX: Double = -h * cosd(minTheta) + xOffset
    let arrowBackBackTopY: Double = -h * sind(minTheta) + yOffset
    
    let arrowBackUpperX: Double = -h * cosd(minTheta) - l2 * sind(minTheta) + xOffset
    let arrowBackUpperY: Double = -h * sind(minTheta) + l2 * cosd(minTheta) + yOffset
    
    let arrowBackInnerX: Double = -(l2 - k2) * sind(minTheta) + xOffset
    let arrowBackInnerY: Double = (l2 - k2) * cosd(minTheta) + yOffset
    
    let arrowBackLowerX: Double = h * cosd(minTheta) - l2 * sind(minTheta) + xOffset
    let arrowBackLowerY: Double = h * sind(minTheta) + l2 * cosd(minTheta) + yOffset
    
    let arrowBackBackBottomX: Double = h * cosd(minTheta) + xOffset
    let arrowBackBackBottomY: Double = h * sind(minTheta) + yOffset
    
    return [
        "backTop": CGPoint(x: arrowBackBackTopX, y: arrowBackBackTopY),
        "upper": CGPoint(x: arrowBackUpperX, y: arrowBackUpperY),
        "inner": CGPoint(x: arrowBackInnerX, y: arrowBackInnerY),
        "lower": CGPoint(x: arrowBackLowerX, y: arrowBackLowerY),
        "backBottom": CGPoint(x: arrowBackBackBottomX, y: arrowBackBackBottomY),
    ]
}

// sin and cos in degrees
public func sind(_ degrees: Double) -> Double {
    return __sinpi(degrees / 180.0)
}

public func cosd(_ degrees: Double) -> Double {
    return __cospi(degrees / 180.0)
}

// Custom mod function, works for negatives
public func mod(_ a: Int, _ n: Int) -> Int {
    let r: Int = a % n
    return r >= 0 ? r : r + n
}

// Formula for calculating brightness of colour
func brightness(color: UIColor) -> CGFloat {
    let cg: CGColor = color.cgColor
    
    let r: CGFloat = cg.components![0]
    let g: CGFloat = cg.components![1]
    let b: CGFloat = cg.components![2]
    
    return (299 * r + 587 * g + 114 * b) / 1000
}

