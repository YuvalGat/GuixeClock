import UIKit

public class Clock: UIView, UIPickerViewDelegate  {
    var words: [String]
    
    var backgroundColorPicker: ChromaColorPicker!
    var clockColorPicker: ChromaColorPicker!
    var handsColorPicker: ChromaColorPicker!
    
    public init() {
        words = [
            "WORK",
            "BELIEF",
            "DESIRE",
            "DESIGN",
            "EMOTION",
            "TECH",
            "APPLE",
            "FOOD",
            "LIFE",
            "CONFLICT",
            "LOVE",
            "DREAM"
        ]
        
        let frame = CGRect(x: 0, y: 0, width: 768, height: 950)
        super.init(frame: frame)
        
        // Initialise pickers and adjust to default colour
        backgroundColorPicker = ChromaColorPicker(frame: CGRect(x: 27, y: 700, width: 238, height: 238))
        backgroundColorPicker.adjustToColor(UIColor.cyan)
        
        clockColorPicker = ChromaColorPicker(frame: CGRect(x: 265, y: 700, width: 238, height: 238))
        clockColorPicker.adjustToColor(UIColor.blue)
        
        handsColorPicker = ChromaColorPicker(frame: CGRect(x: 503, y: 700, width: 238, height: 238))
        handsColorPicker.adjustToColor(UIColor.purple)
        
        // Set stroke, delegate and hide unnecessary components. Then, update UI when finish choosing colour and add to subview
        [backgroundColorPicker, clockColorPicker, handsColorPicker].forEach {
            $0!.stroke = 3
            $0!.delegate = self
            $0!.supportsShadesOfGray = true
            
            $0!.hexLabel.isHidden = true
            $0!.addButton.isHidden = true
            $0!.handleLine.isHidden = true
            
            $0!.addTarget(self, action: #selector(self.update), for: .editingDidEnd)
            self.addSubview($0!)
        }
        
        // Initialise UILabels for ColorPickers
        let backgroundColorPickerUILabel = UILabel(frame: CGRect(x: 93, y: 770, width: 100, height: 100))
        let clockColorPickerUILabel = UILabel(frame: CGRect(x: 331, y: 770, width: 100, height: 100))
        let handsColorPickerUILabel = UILabel(frame: CGRect(x: 569, y: 770, width: 100, height: 100))
        
        backgroundColorPickerUILabel.text = "BACKGROUND\nCOLOR"
        clockColorPickerUILabel.text = "CLOCK\nCOLOR"
        handsColorPickerUILabel.text = "HANDS\nCOLOR"
        
        [backgroundColorPickerUILabel, clockColorPickerUILabel, handsColorPickerUILabel].forEach {
            $0.textAlignment = .center
            $0.font = getSoWhatFont(size: 25)
            $0.numberOfLines = 0
            self.addSubview($0)
        }
        
        update()
        
        // Get closest minute, at which we start a timer which updates the UIView every minute, so that the clock functions as expected from a clock.
        // This way, the clock is precisely identical to the computer's clock.
        let closestMinute = getClosestRoundMinute()
        
        let timer = Timer(fireAt: closestMinute, interval: 60, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    }
    
    // Changes a word when the sender, of type UIButton, is clicked
    @objc func changeWord(sender: UIButton) {
        // Create the alert and add a text field to it
        let alert = UIAlertController(title: "Enter a new word to replace \"\((sender.titleLabel?.text ?? "").lowercased())\" with", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your word here!"
        }
        
        // When Done is pressed, get the value of the text field and put it in the words array, then update.
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            textField.autocorrectionType = .no // Makes it so no keyboard tips are shown
            self.words[sender.tag] = textField.text!.uppercased()
            self.update()
        }))
        
        alert.presentInOwnWindow(animated: true, completion: nil)
    }
    
    @objc func update() {
        // Update background color according to color picker
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
        
        // Remove the generated sentence so it can be regenerated. We also remove the label for the word "IS", so that we don't generate another one on top of the already existing one.
        self.subviews.forEach {
            if [99, 199].contains($0.tag) {
                $0.removeFromSuperview()
            }
        }
        
        // Create the clock, which is a circle layer
        let circ = getCircleLayer(x: 384, y: 300, r: 300, color: clockColorPicker.currentColor.cgColor)
        circ.name = "clockCircle"
        circ.shadowOpacity = 1
        circ.shadowRadius = 6
        self.layer.addSublayer(circ)
        
        // Variables for arrow sizes; Described in the PDF file under Sources/main.pdf
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
        let minuteLayer = CAShapeLayer()

        hourLayer.path = hourHand.cgPath
        minuteLayer.path = minuteHand.cgPath

        hourLayer.fillColor = handsColorPicker.currentColor.cgColor
        minuteLayer.fillColor = handsColorPicker.currentColor.cgColor

        hourLayer.shadowOpacity = 1
        minuteLayer.shadowOpacity = 1
        hourLayer.shadowRadius = 10
        minuteLayer.shadowRadius = 10
        
        hourLayer.name = "hourHand"
        minuteLayer.name = "minuteHand"
        
        self.layer.addSublayer(hourLayer)
        self.layer.addSublayer(minuteLayer)
        
        // Create the sentence
        let currentMinuteForSentence = Int(getCurrentMinute())
        let currentHourForSentence = Int(getCurrentHour()) - 1
        
        let sentence = UILabel(frame: CGRect(x: 84, y: 585, width: 600, height: 100))
        sentence.textAlignment = .center
        
        let firstWordIndex = mod(Int(round(Double(currentMinuteForSentence) / 5.0)) - 1, 12)
        
        // The hour hand word is dependent on whether or not the minute is more than 30
        var secondWordIndex: Int
        secondWordIndex = currentMinuteForSentence <= 30 ? currentHourForSentence : currentHourForSentence + 1
        secondWordIndex = mod(secondWordIndex, 12) // Make sure the index is within range
        
        let firstWord = words[firstWordIndex]
        let secondWord = words[secondWordIndex]
        
        sentence.text = "\(firstWord) IS \(secondWord)"
        sentence.font = getSoWhatFont(size: 60)
        
        sentence.tag = 99
        
        self.addSubview(sentence)
        
        // Add the circle behind the word "IS"
        let circleBehindIS = getCircleLayer(x: 384, y: 300, r: 50, color: UIColor(rgb: 0xf2ebd5).cgColor)
        circleBehindIS.shadowOpacity = 1
        circleBehindIS.shadowRadius = 10
        self.layer.addSublayer(circleBehindIS)
        
        // Add the rotating "IS" label. Rotation is dependent on the hour arrow's direction, and is therefore calculated with the same formula.
        let labelForIS = UILabel(frame: CGRect(x: 354, y: 270, width: 60, height: 60))
        
        labelForIS.text = "IS"
        labelForIS.textAlignment = .center
        labelForIS.font = getSoWhatFont(size: 60)
        labelForIS.tag = 199
        labelForIS.transform = CGAffineTransform(rotationAngle: CGFloat(Double(mod(Int(round(hr * 30 + min / 2)), 360)).degrees()))
        
        self.addSubview(labelForIS)
        
        // Initialise the buttons with the corresponding words and add the target upon click
        for hr in 1...12 {
            let coords: CGPoint = getCoordinatesOfLabelByHour(hr: hr)
            let button = UIButton(frame: CGRect(x: coords.x - 25, y: coords.y - 25, width: 100, height: 50))
            
            button.setTitle(words[hr - 1], for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = getSoWhatFont(size: 30)
            button.sizeToFit()
            button.titleLabel!.textAlignment = .center
            
            button.tag = hr - 1
            
            button.addTarget(self, action: #selector(changeWord), for: .touchUpInside)
            
            self.addSubview(button)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Clock must conform to the ChromaColorPickerDelegate delegate. When a color is picked, we update the screen.
extension Clock: ChromaColorPickerDelegate {
    public func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        update()
    }
}
