import UIKit

public class Clock: UIView {
    public init() {
        let frame = CGRect(x: 0, y: 0, width: 600, height: 600)
        super.init(frame: frame)
        
        let button = UIButton()
        
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        button.setTitle("Test", for: .normal)
        button.backgroundColor = .red
        //        button.setTitle("Test", for: .normal)
        
        button.addTarget(self, action: #selector(self.redrawHandsDefault), for: .touchUpInside)
        
        self.addSubview(button)
        
        drawClock(circleColor: UIColor(rgb: 0xF7F7E2).cgColor, backgroundColor: UIColor.lightGray, hourHandColor: UIColor.cyan.cgColor, minuteHandColor: UIColor.cyan.cgColor)
    }
    
    func drawClock(circleColor: CGColor, backgroundColor: UIColor, hourHandColor: CGColor, minuteHandColor: CGColor) -> () {
        self.backgroundColor = backgroundColor
        
        let circ = getCircleLayer(x: 300, y: 300, r: 300, color: circleColor)
        self.layer.addSublayer(circ)
        
        self.redrawHands(hourHandColor: hourHandColor, minuteHandColor: minuteHandColor)
    }
    
    @objc func redrawHandsDefault() {
        redrawHands(hourHandColor: UIColor.red.cgColor, minuteHandColor: UIColor.blue.cgColor)
    }
    
    func redrawHands(hourHandColor: CGColor, minuteHandColor: CGColor) {
        self.layer.sublayers!.forEach {
            if $0.name == "minuteHand" || $0.name == "hourHand" {
                $0.removeFromSuperlayer()
            }
        }
        
        let h = 15.0
        let l1 = 180.0
        let d = 30.0
        let k1 = 45.0
        let l2 = 270.0
        let k2 = 15.0
        
//        let min = Double(Calendar.current.component(.minute, from: Date()))
//        let hr = Double(Calendar.current.component(.hour, from: Date()))
        let min = Double(arc4random_uniform(60))
        let hr = Double(arc4random_uniform(12))
        
        let hourHand: UIBezierPath = createHourHandPath(hr: hr, h: h, l1: l1, d: d, k1: k1)
        let minuteHand: UIBezierPath = createMinuteHandPath(min: min, h: h, l2: l2, k2: k2)
        
        let hourLayer = CAShapeLayer()
        hourLayer.path = hourHand.cgPath
        hourLayer.fillColor = hourHandColor
        
        hourLayer.shadowOpacity = 0.3
        
        hourLayer.name = "hourHand"
        
        self.layer.addSublayer(hourLayer)
        
        let minuteLayer = CAShapeLayer()
        minuteLayer.path = minuteHand.cgPath
        minuteLayer.fillColor = minuteHandColor
        
        minuteLayer.shadowOpacity = 0.3
        
        minuteLayer.name = "minuteHand"
        
        self.layer.addSublayer(minuteLayer)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
