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
     
        update(circleColor: UIColor(rgb: 0xF7F7E2).cgColor, backgroundColor: .purple, hourHandColor: UIColor.white.cgColor, minuteHandColor: UIColor.white.cgColor, words: self.words)
        
        // Get closest minute, at which we start a timer which updates the UIView every minute, so that the clock functions like a normal
        // This way, the clock is precise.
        let closestMinute = getClosestRoundMinute()
        
        let timer = Timer(fireAt: closestMinute, interval: 60, target: self, selector: #selector(self.updateWithDefaults), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    }
    
    @objc func updateWithDefaults() {
        update(circleColor: UIColor(rgb: 0xF7F7E2).cgColor, backgroundColor: .purple, hourHandColor: UIColor.white.cgColor, minuteHandColor: UIColor.white.cgColor, words: self.words)
    }
    
    func update(circleColor: CGColor, backgroundColor: UIColor, hourHandColor: CGColor, minuteHandColor: CGColor, words: [String]) {
        self.backgroundColor = backgroundColor
        
        // Create circle layer
        let circ = getCircleLayer(x: 300, y: 300, r: 300, color: circleColor)
        self.layer.addSublayer(circ)
        
        // Remove the already-existing hands
        self.layer.sublayers!.forEach {
            if $0.name == "minuteHand" || $0.name == "hourHand" {
                $0.removeFromSuperlayer()
            }
        }
        
        // Remove the generated sentence so it can be regenerated
        self.subviews.forEach {
            if $0.tag == 99 {
                $0.removeFromSuperview()
            }
        }
        
        // Variables for arrow sizes; Described in the PDF file
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
        
        // Create the paths for the clock's hands
        let hourHand: UIBezierPath = createHourHandPath(hr: hr, min: min, h: h, l1: l1, d: d, k1: k1)
        let minuteHand: UIBezierPath = createMinuteHandPath(min: min, h: h, l2: l2, k2: k2)
        
        // Create layers and properties and add to view
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
        let currentHourForSentence = Int(getCurrentHour()) - 1
        
        let sentence = UILabel(frame: CGRect(x: 0, y: 600, width: 600, height: 100))
        sentence.textAlignment = .center
        
        let firstWordIndex = mod(Int(round(Double(currentMinuteForSentence) / 5.0)) - 1, 12)
        
        // The hour hand word is dependent on whether or not the minute is more than 30
        var secondWordIndex: Int
        secondWordIndex = currentMinuteForSentence <= 30 ? currentHourForSentence : currentHourForSentence + 1
        secondWordIndex = mod(secondWordIndex, 12)

        let firstWord = words[firstWordIndex]
        let secondWord = words[secondWordIndex]
        
        sentence.text = "\(firstWord) Is \(secondWord)"
        sentence.font = getParadiseRoadFont(size: 40)
        
        sentence.tag = 99
        
        self.addSubview(sentence)
        
        // Initialise the buttons with the corresponding words
        for hr in 1...12 {
            let coords: CGPoint = getCoordinatesOfLabelByHour(hr: hr)
            let button = UIButton(frame: CGRect(x: coords.x, y: coords.y, width: 100, height: 50))
            
            button.setTitle(words[hr - 1], for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = getParadiseRoadFont(size: 20)
            
            self.addSubview(button)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
