//
//  DateExtention.swift
//  Workforce Pro
//
//  Created by Mahmoud Abdul-wahab on 1/25/21.
//

import Foundation

func isDateInRange(date: String, startDate: String, endDate: String) -> Bool {
    // Create date formatter
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    // Convert strings to dates
    guard let dateToCheck = dateFormatter.date(from: date),
          let start = dateFormatter.date(from: startDate),
          let end = dateFormatter.date(from: endDate) else {
        return false // Return false if any string can't be converted to date
    }
    
    // Check if date is between start and end (inclusive)
    return (dateToCheck >= start) && (dateToCheck <= end)
}

extension Date {
    
    func getNameOfMonth() -> String {
               let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Force English locale
               return dateFormatter.string(from: self)
           
    }
    
    func toApiFormat3() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Force English locale
        return dateFormatter.string(from: self)
    }
    
    func toApiFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Force English locale

        return dateFormatter.string(from: self)
    }
    
    func toDateOnlyFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Force English locale

        return dateFormatter.string(from: self)
    }
    
    func toTimeOnlyFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Force English locale

        return dateFormatter.string(from: self)
    }
    
  

    
    func getTime24() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Force English locale

        
//        return dateFormatter.string(from: self)

        let date = dateFormatter.date(from: dateFormatter.string(from: self))
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Force English locale

        let Date24 = dateFormatter.string(from: date!)
        return Date24
    }
    
    func toTimeOnlyFormats() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Force English locale

        return dateFormatter.string(from: self)
    }
    
    func toUrlDate() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/dd/yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Force English locale

        return dateFormatter.string(from: self)
    }
    
    func toUrlDate2() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Force English locale

        return dateFormatter.string(from: self)
    }
    
    func toUrlTime() -> String
    {
        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "M/dd/yyyy h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Force English locale

        return dateFormatter.string(from: self)
    }
    
//    func toPrettyFormate() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = AppHelper.getLanguage() == "en" ? Locale(identifier: "en"):Locale(identifier: "ar")
//        dateFormatter.dateFormat = "MMM d, yyyy"
//        return dateFormatter.string(from: self)
//    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func daysInMonth(_ monthNumber: Int? = nil, _ year: Int? = nil) -> Int {
        if let interval = Calendar.current.dateInterval(of: .month, for: self),
            let days = Calendar.current.dateComponents([.day], from: interval.start, to: interval.end).day {
            return days
        }else {
            return -1
        }
    }
}
