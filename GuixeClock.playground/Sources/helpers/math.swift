import Foundation
import UIKit

/*:
 - Note:
 A lot of mathematics were applied here. The general formula for rotating (x, y) around (0, 0) by angle θ is shown in the PDF file under Sources/main.pdf. θ is calculated for the minutes hand and for the hours hand, after which we apply the formulas for each of the arrow's coordinates.
 
 The variables h, l1, d, k1, l2, k2 are also described in the PDF file.
 
 Even though I could have returned an array, I decided to use a dictionary to make sure each variable name is clear.
 
 The PDF File was generated with LaTeX using TikZ.
 */

let xOffset = 384.0
let yOffset = 300.0

public func getFrontArrowCoordinatesByTime(hr: Double, min: Double, h: Double, l1: Double, d: Double, k1: Double) -> [String: CGPoint] {
    let hrTheta: Double = Double(mod(Int(round(hr * 30 + min / 2)), 360))
    
    let arrowFrontBackTopX = -h * cosd(hrTheta) + xOffset
    let arrowFrontBackTopY = -h * sind(hrTheta) + yOffset
    
    let arrowFrontBackBottomX = h * cosd(hrTheta) + xOffset
    let arrowFrontBackBottomY = h * sind(hrTheta) + yOffset
    
    let arrowFrontMiddleBottomX = -l1 * cosd(hrTheta + 90) + h * sind(hrTheta + 90) + xOffset
    let arrowFrontMiddleBottomY = -l1 * sind(hrTheta + 90) - h * cosd(hrTheta + 90) + yOffset
    
    let arrowFrontMiddleBottomBottomX = l1 * cosd(hrTheta - 90) - (h + d) * sind(hrTheta - 90) + xOffset
    let arrowFrontMiddleBottomBottomY = l1 * sind(hrTheta - 90) + (h + d) * cosd(hrTheta - 90) + yOffset
    
    let arrowFrontPointyX = (l1 + k1) * cosd(hrTheta - 90) + xOffset
    let arrowFrontPointyY = (l1 + k1) * sind(hrTheta - 90) + yOffset
    
    let arrowFrontMiddleTopTopX = l1 * cosd(hrTheta - 90) - (-h - d) * sind(hrTheta - 90) + xOffset
    let arrowFrontMiddleTopTopY = l1 * sind(hrTheta - 90) + (-h - d) * cosd(hrTheta - 90) + yOffset
    
    let arrowFrontMiddleTopX = -l1 * cosd(hrTheta + 90) - h * sind(hrTheta + 90) + xOffset
    let arrowFrontMiddleTopY = -l1 * sind(hrTheta + 90) + h * cosd(hrTheta + 90) + yOffset
    
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
    
    let arrowBackBackTopX = -h * cosd(minTheta) + xOffset
    let arrowBackBackTopY = -h * sind(minTheta) + yOffset
    
    let arrowBackUpperX = -h * cosd(minTheta) - l2 * sind(minTheta) + xOffset
    let arrowBackUpperY = -h * sind(minTheta) + l2 * cosd(minTheta) + yOffset
    
    let arrowBackInnerX = -(l2 - k2) * sind(minTheta) + xOffset
    let arrowBackInnerY = (l2 - k2) * cosd(minTheta) + yOffset
    
    let arrowBackLowerX = h * cosd(minTheta) - l2 * sind(minTheta) + xOffset
    let arrowBackLowerY = h * sind(minTheta) + l2 * cosd(minTheta) + yOffset
    
    let arrowBackBackBottomX = h * cosd(minTheta) + xOffset
    let arrowBackBackBottomY = h * sind(minTheta) + yOffset
    
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

