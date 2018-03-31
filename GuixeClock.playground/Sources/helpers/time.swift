import Foundation
import UIKit

// Returns current hour/minute
public func getCurrentHour() -> Double {
    return Double(Calendar.current.component(.hour, from: Date()))
}

public func getCurrentMinute() -> Double {
    return Double(Calendar.current.component(.minute, from: Date()))
}

// Get the closest round minute (i.e., if it's 6:15:23, the function would return 6:16:00)
public func getClosestRoundMinute() -> Date {
    var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
    
    let currentHour: Int = Calendar.current.component(.hour, from: Date())
    let currentMinute: Int = Calendar.current.component(.minute, from: Date())
    
    let inOneMinute = Date().setTime(hour: currentHour, min: currentMinute + 1, sec: 0, timeZoneAbbrev: localTimeZoneAbbreviation)
    
    return inOneMinute!
}
