import Foundation
import UIKit

func createHourHandPath(hr: Double, h: Double, l1: Double, d: Double, k1: Double) -> UIBezierPath {
    let hourHand: UIBezierPath = UIBezierPath()
    let hourArrow = getFrontArrowCoordinatesByTime(hr: hr, h: h, l1: l1, d: d, k1: k1)
    
    hourHand.move(to: hourArrow["backTop"]!)
    hourHand.addLine(to: hourArrow["backBottom"]!)
    hourHand.addLine(to: hourArrow["centerBottom"]!)
    hourHand.addLine(to: hourArrow["lower"]!)
    hourHand.addLine(to: hourArrow["tip"]!)
    hourHand.addLine(to: hourArrow["upper"]!)
    hourHand.addLine(to: hourArrow["centerTop"]!)
    
    hourHand.close()
    
    return hourHand
}

func createMinuteHandPath(min: Double, h: Double, l2: Double, k2: Double) -> UIBezierPath {
    let minuteHand: UIBezierPath = UIBezierPath()
    let minuteArrow = getBackArrowCoordinatesByTime(min: min, h: h, l2: l2, k2: k2)
    
    minuteHand.move(to: minuteArrow["backTop"]!)
    minuteHand.addLine(to: minuteArrow["upper"]!)
    minuteHand.addLine(to: minuteArrow["inner"]!)
    minuteHand.addLine(to: minuteArrow["lower"]!)
    minuteHand.addLine(to: minuteArrow["backBottom"]!)
    
    minuteHand.close()
    
    return minuteHand
}
