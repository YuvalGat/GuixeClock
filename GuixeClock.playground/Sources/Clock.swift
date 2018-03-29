import UIKit

public class Clock: UIView  {
    var words: [String]
    
    var backgroundColorPicker: ChromaColorPicker!
    var clockColorPicker: ChromaColorPicker!
    var handsColorPicker: ChromaColorPicker!
    
    public init() {
        words = [
            "DESIRE",
            "LOVE",
            "JOY",
            "MOUSE",
            "BAG",
            "FOOD",
            "TABLE",
            "CUP",
            "APPLE",
            "HAT",
            "CHARGER",
            "IPHONE"
        ]
        
        let frame = CGRect(x: 0, y: 0, width: 900, height: 700)
        super.init(frame: frame)
        
        // Set color picker properties and hide inner components
        backgroundColorPicker = ChromaColorPicker(frame: CGRect(x: 585, y: 0, width: 200, height: 200))
        backgroundColorPicker.delegate = self
        
        backgroundColorPicker.stroke = 3
        
        backgroundColorPicker.adjustToColor(UIColor.cyan)
        
        backgroundColorPicker.hexLabel.isHidden = true
//        backgroundColorPicker.shadeSlider.isHidden = true
        backgroundColorPicker.addButton.isHidden = true
        backgroundColorPicker.handleLine.isHidden = true
        
        clockColorPicker = ChromaColorPicker(frame: CGRect(x: 585, y: 200, width: 200, height: 200))
        clockColorPicker.delegate = self
        
        clockColorPicker.stroke = 3
        
        clockColorPicker.adjustToColor(UIColor.blue)
        
        clockColorPicker.hexLabel.isHidden = true
//        clockColorPicker.shadeSlider.isHidden = true
        clockColorPicker.addButton.isHidden = true
        clockColorPicker.handleLine.isHidden = true
        
        handsColorPicker = ChromaColorPicker(frame: CGRect(x: 585, y: 400, width: 200, height: 200))
        handsColorPicker.delegate = self
        
        handsColorPicker.stroke = 3
        
        handsColorPicker.adjustToColor(UIColor.purple)
        
        handsColorPicker.hexLabel.isHidden = true
//        handsColorPicker.shadeSlider.isHidden = true
        handsColorPicker.addButton.isHidden = true
        handsColorPicker.handleLine.isHidden = true
        
        // Update colors upon release
        backgroundColorPicker.addTarget(self, action: #selector(updateWithDefaults), for: .editingDidEnd)
        clockColorPicker.addTarget(self, action: #selector(updateWithDefaults), for: .editingDidEnd)
        handsColorPicker.addTarget(self, action: #selector(updateWithDefaults), for: .editingDidEnd)

        self.addSubview(backgroundColorPicker)
        self.addSubview(clockColorPicker)
        self.addSubview(handsColorPicker)
        
        // Initialise UILabels for ColorPickers
        let backgroundColorPickerUILabel = UILabel(frame: CGRect(x: 635, y: 50, width: 100, height: 100))
        let clockColorPickerUILabel = UILabel(frame: CGRect(x: 635, y: 245, width: 100, height: 100))
        let handsColorPickerUILabel = UILabel(frame: CGRect(x: 635, y: 445, width: 100, height: 100))
        
        backgroundColorPickerUILabel.text = "BACKGROUND\nCOLOR"
        backgroundColorPickerUILabel.textAlignment = .center
        backgroundColorPickerUILabel.font = getSoWhatFont(size: 25)
        backgroundColorPickerUILabel.numberOfLines = 0
        
        clockColorPickerUILabel.text = "CLOCK\nCOLOR"
        clockColorPickerUILabel.textAlignment = .center
        clockColorPickerUILabel.font = getSoWhatFont(size: 25)
        clockColorPickerUILabel.numberOfLines = 0
        
        handsColorPickerUILabel.text = "HANDS\nCOLOR"
        handsColorPickerUILabel.textAlignment = .center
        handsColorPickerUILabel.font = getSoWhatFont(size: 25)
        handsColorPickerUILabel.numberOfLines = 0
        
        self.addSubview(backgroundColorPickerUILabel)
        self.addSubview(clockColorPickerUILabel)
        self.addSubview(handsColorPickerUILabel)
        
        updateWithDefaults()
        
        // Get closest minute, at which we start a timer which updates the UIView every minute, so that the clock functions like a normal
        // This way, the clock is precise.
        let closestMinute = getClosestRoundMinute()
        
        let timer = Timer(fireAt: closestMinute, interval: 60, target: self, selector: #selector(self.updateWithDefaults), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    }
    
    @objc func updateWithDefaults() {
        update(
            circleISColor: UIColor(rgb: 0xf2ebd5).cgColor,
            words: self.words
        )
    }
    
    func update(circleISColor: CGColor, words: [String]) {
        self.backgroundColor = backgroundColorPicker.currentColor

        // We must first remove the already-existing layers from the pervious update() call and UILabels
        if self.layer.sublayers != nil {
            self.layer.sublayers!.forEach {
                if let name = $0.name {
                    if ["clockCircle", "minuteHand", "hourHand", "IS"].contains(name) {
                        $0.removeFromSuperlayer()
                    }
                }
            }
        }
        
        // Remove the generated sentence so it can be regenerated
        self.subviews.forEach {
            if [99, 199].contains($0.tag) {
                $0.removeFromSuperview()
            }
        }
        
        // Create the clock, which is a circle layer
        let circ = getCircleLayer(x: 300, y: 300, r: 300, color: clockColorPicker.currentColor.cgColor)
        circ.name = "clockCircle"
        circ.shadowOpacity = 0.4
        self.layer.addSublayer(circ)
        
        // Variables for arrow sizes; Described in the PDF file
        let h = 15.0
        let l1 = 170.0
        let d = 25.0
        let k1 = 45.0
        let l2 = 245.0
        let k2 = 15.0
        
        let min = getCurrentMinute()
        let hr = getCurrentHour()
        
        // Create the paths for the clock's hands
        let hourHand: UIBezierPath = createHourHandPath(hr: hr, min: min, h: h, l1: l1, d: d, k1: k1)
        let minuteHand: UIBezierPath = createMinuteHandPath(min: min, h: h, l2: l2, k2: k2)
        
        // Create layers and properties and add to view
        let hourLayer = CAShapeLayer()
        hourLayer.path = hourHand.cgPath
        hourLayer.fillColor = handsColorPicker.currentColor.cgColor
        
        hourLayer.shadowOpacity = 0.3
        
        hourLayer.name = "hourHand"
        
        self.layer.addSublayer(hourLayer)
        
        let minuteLayer = CAShapeLayer()
        minuteLayer.path = minuteHand.cgPath
        minuteLayer.fillColor = handsColorPicker.currentColor.cgColor
        
        minuteLayer.shadowOpacity = 0.3
        
        minuteLayer.name = "minuteHand"
        
        self.layer.addSublayer(minuteLayer)
        
        // Create the sentence
        let currentMinuteForSentence = Int(getCurrentMinute())
        let currentHourForSentence = Int(getCurrentHour()) - 1
        
        let sentence = UILabel(frame: CGRect(x: 0, y: 585, width: 600, height: 100))
        sentence.textAlignment = .center
        
        let firstWordIndex = mod(Int(round(Double(currentMinuteForSentence) / 5.0)) - 1, 12)
        
        // The hour hand word is dependent on whether or not the minute is more than 30
        var secondWordIndex: Int
        secondWordIndex = currentMinuteForSentence <= 30 ? currentHourForSentence : currentHourForSentence + 1
        secondWordIndex = mod(secondWordIndex, 12)
        
        let firstWord = words[firstWordIndex]
        let secondWord = words[secondWordIndex]
        
        sentence.text = "\(firstWord) IS \(secondWord)"
        sentence.font = getSoWhatFont(size: 60)
        
        sentence.tag = 99
        
        self.addSubview(sentence)
        
        // Add the circle behind the word "IS"
        let circleBehindIS = getCircleLayer(x: 300, y: 300, r: 50, color: circleISColor)
        circleBehindIS.shadowOpacity = 0.3
        self.layer.addSublayer(circleBehindIS)
        
        // Add the rotating "IS" label. Rotation is dependent on the hour arrow's direction, and is therefore calculated with the same formula.
        let labelForIS = UILabel(frame: CGRect(x: 270, y: 270, width: 60, height: 60))
        
        labelForIS.text = "IS"
        labelForIS.textAlignment = .center
        labelForIS.font = getSoWhatFont(size: 60)
        labelForIS.tag = 199
        labelForIS.transform = CGAffineTransform(rotationAngle: CGFloat(Double(mod(Int(round(hr * 30 + min / 2)), 360)).degrees()))
        
        self.addSubview(labelForIS)
        
        // Initialise the buttons with the corresponding words
        for hr in 1...12 {
            let coords: CGPoint = getCoordinatesOfLabelByHour(hr: hr)
            let button = UIButton(frame: CGRect(x: coords.x - 50, y: coords.y - 25, width: 100, height: 50))
            
            button.setTitle(words[hr - 1], for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = getSoWhatFont(size: 30)
            
            self.addSubview(button)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Clock: ChromaColorPickerDelegate {
    public func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        updateWithDefaults()
    }
}
