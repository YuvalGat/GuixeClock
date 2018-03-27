import UIKit

public class Clock: UIView {
    var words: [String]
    public init() {
        words = [
            "Desire",
            "Love",
            "Joy",
            "Sadness",
            "Happiness",
            "Food",
            "Table",
            "Macbook",
            "Apple",
            "Hat",
            "Charger",
            "iPhone"
        ]
        
        let frame = CGRect(x: 0, y: 0, width: 700, height: 700)
        super.init(frame: frame)
        
//        let button = UIButton()
//        
//        button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//        button.setTitle("Test", for: .normal)
//        button.backgroundColor = .red
//        
//        button.addTarget(self, action: #selector(self.redrawHandsDefault), for: .touchUpInside)
//
//        self.addSubview(button)
        
        drawClock(circleColor: UIColor(rgb: 0xF7F7E2).cgColor, backgroundColor: .purple, hourHandColor: UIColor.white.cgColor, minuteHandColor: UIColor.white.cgColor)
        
        let closestMinute = getClosestRoundMinute()
        
        let timer = Timer(fireAt: closestMinute, interval: 60, target: self, selector: #selector(redrawHandsDefault), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    }
    
    func drawClock(circleColor: CGColor, backgroundColor: UIColor, hourHandColor: CGColor, minuteHandColor: CGColor) {
        
        self.backgroundColor = backgroundColor
        
        let circ = getCircleLayer(x: 300, y: 300, r: 300, color: circleColor)
        self.layer.addSublayer(circ)
        
        self.redrawHands(hourHandColor: hourHandColor, minuteHandColor: minuteHandColor)
        
        // Initialise the buttons with the corresponding words
        for hr in 1...12 {
            let coords: CGPoint = getCoordinatesOfLabelByHour(hr: hr)
            let button = UIButton(frame: CGRect(x: coords.x, y: coords.y, width: 100, height: 50))
            button.setTitle(words[hr - 1], for: .normal)
            button.backgroundColor = .black
            self.addSubview(button)
        }
    }
    
    @objc func redrawHandsDefault() {
        redrawHands(hourHandColor: UIColor.white.cgColor, minuteHandColor: UIColor.white.cgColor)
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
        
        let min = getCurrentMinute()
        let hr = getCurrentHour()
//        let min = Double(arc4random_uniform(60))
//        let hr = Double(arc4random_uniform(12))
        
        let hourHand: UIBezierPath = createHourHandPath(hr: hr, min: min, h: h, l1: l1, d: d, k1: k1)
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
        
        // Create the sentence
        let currentMinuteForSentence = Int(getCurrentMinute())
        let currentHourForSentence = mod(Int(getCurrentHour()), 12) - 1
        
        let sentence = UILabel(frame: CGRect(x: 0, y: 600, width: 600, height: 100))
        sentence.textAlignment = .center
        
        let firstWord = words[mod(Int(round(Double(currentMinuteForSentence) / 5.0)) - 1, 12)]
        let secondWord = words[Int(round(Double(currentHourForSentence) + Double(currentMinuteForSentence / 60)))]
        
        sentence.text = "\(firstWord) Is \(secondWord)"
        self.addSubview(sentence)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
