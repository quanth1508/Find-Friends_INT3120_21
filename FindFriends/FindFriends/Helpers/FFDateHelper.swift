
import UIKit

public
struct FFDateHelper {
    
    static func stringFromDate(_ date: Date, format: String, locale: Locale = .current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = locale
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        return dateFormatter.string(from: date)
    }
    
    public
    static func dateFromString(_ timeStr: String, format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.init(identifier: "en_US")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        if let date = dateFormatter.date(from: timeStr){
            return date
        }
        return Date()
    }
    
    static func stringFromDateSring(_ dateString: String, fromFormat: String, toFormat: String) -> String {
        let oldDate = FFDateHelper.dateFromString(dateString, format: fromFormat)
        let newString = FFDateHelper.stringFromDate(oldDate, format: toFormat)
        return newString
    }
    
    static func getDefaultMonthRange() -> [Date] {
        let dateFormat = DateFormatter()
        dateFormat.timeZone = TimeZone.init(abbreviation: "UTC")
        dateFormat.locale = Locale.init(identifier: "en_US")
        dateFormat.dateFormat = "dd/MM/yyyy"
        dateFormat.calendar = Calendar(identifier: .gregorian)
        
        let date = Date()//today
        let calendar = Calendar.current
        var dateComp = calendar.dateComponents([.day, .month, .weekday, .year], from: date)
        
        let previous30Days = calendar.date(byAdding: .day, value: -30, to: date)
        
        dateComp.setValue(1, for: .day)
        let firstDayInThisMonth = calendar.date(from: dateComp)
        
        dateComp.setValue(dateComp.day!-1, for: .day)
        let lastDayInLastMonth = calendar.date(from: dateComp)
        
        dateComp.setValue(dateComp.month! - 1, for: .month)
        dateComp.setValue(1, for: .day)
        let firstDayInLastMonth = calendar.date(from: dateComp)
        
        dateComp.setValue(dateComp.day!-1, for: .day)
        let lastDayInLast2Month = calendar.date(from: dateComp)
        
        dateComp.setValue(dateComp.month! - 1, for: .month)
        dateComp.setValue(1, for: .day)
        let firstDayInLast2Month = calendar.date(from: dateComp)
        
        dateComp.setValue(dateComp.day!-1, for: .day)
        let lastDayInLast3Month = calendar.date(from: dateComp)
        
        dateComp.setValue(dateComp.month! - 1, for: .month)
        dateComp.setValue(1, for: .day)
        let firstDayInLast3Month = calendar.date(from: dateComp)
        
        var dateRange = [Date]()
        dateRange.append(previous30Days!)
        dateRange.append(date)
        dateRange.append(firstDayInThisMonth!)
        dateRange.append(date)
        dateRange.append(firstDayInLastMonth!)
        dateRange.append(lastDayInLastMonth!)
        dateRange.append(firstDayInLast2Month!)
        dateRange.append(lastDayInLast2Month!)
        dateRange.append(firstDayInLast3Month!)
        dateRange.append(lastDayInLast3Month!)
        return dateRange
    }
    
    static func timeTextFromDate(_ date: Date) -> String {
        
        let countTime = Date.init().timeIntervalSince1970 - date.timeIntervalSince1970
        if (countTime < 60){
            return "vừa mới"
        }
        else if (countTime/60 < 60){
            return "\(Int(countTime/60)) phút trước"
        }
        else if (countTime/3600 < 24){
            return "\(Int(countTime/3600)) giờ trước"
        }
        else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.locale = Locale.init(identifier: "en_US")
            
            let date1 = dateFormatter.string(from: date)
            let date2 = dateFormatter.string(from: Date.init())
            
            let inputDate = dateFormatter.date(from: date1)
            let currentDate = dateFormatter.date(from: date2)
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: inputDate!, to: currentDate!)
            let day = components.day
            
            return "\(String(describing: day!)) ngày trước"
        }
        
    }
    
    public
    static func dateFromString(_ timeStr: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.calendar = Calendar(identifier: .gregorian)

        if let date = dateFormatter.date(from: timeStr){
            return date
        }
        
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        if let date = dateFormatter.date(from: timeStr) {
            return date
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss a"
        if let date = dateFormatter.date(from: timeStr){
            return date
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let date = dateFormatter.date(from: timeStr){
            return date
        }
        dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ss.SSS'Z'"
        if let date = dateFormatter.date(from: timeStr){
            return date
        }
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        if let date = dateFormatter.date(from: timeStr){
            return date
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: timeStr){
            return date
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: timeStr){
            return date
        }
        
        // dùng trong trường hợp device để định dạng 12h
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = dateFormatter.date(from: timeStr){
            return date
        }
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let date = dateFormatter.date(from: timeStr){
            return date
        }
        
        return nil
    }
}

extension Date {
    func stringUTC(format: String) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.init(abbreviation: "UTC")
        formatter.locale = Locale.init(identifier: "en_US")
        formatter.dateFormat = format
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter.string(from: self)
    }
    
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    func daysFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.day, from: date, to: self, options: []).day!
    }
}
