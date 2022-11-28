
import UIKit

extension Int {
    public func toK() -> String {
        let input = "\(self)"
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.roundingMode = .down
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = 3
        formatter.minimumFractionDigits = 3
        
        let formatterK = NumberFormatter()
        formatterK.numberStyle = .decimal
        formatterK.roundingMode = .down
        formatterK.decimalSeparator = ","
        formatterK.maximumFractionDigits = 0
        formatterK.minimumFractionDigits = 0
        
        
        var money: String = "0"
        var suffix: String = "k"
        
        //tính độ dài để chia cho số 0, ví dụ 10000 thì sẽ chia 4 số 0 => 10k, 2000000 thì sẽ chia 7 số 0 => 2tr ...
        var totalLength = Double(input.count)
        
        let moneyDouble: Double = input.doubleValue
        
        if moneyDouble >= 1000 && moneyDouble < 1000000 {
            totalLength = 1000
            suffix = "k"
            if let str = formatterK.string(from: NSNumber(value: moneyDouble/totalLength)) {
                money = str
            }
        } else if moneyDouble >= 1000000 {
            if moneyDouble >= 1000000 && moneyDouble < 1000000000 {
                totalLength = 1000000
                suffix = "tr"
            } else if moneyDouble >= 1000000000{
                totalLength = 1000000000
                suffix = "tỷ"
            }
            if let str = formatter.string(from: NSNumber(value: moneyDouble/totalLength)) {
                money = str
            }
        }
        return money + suffix
    }
    
    public func isZero() -> Bool {
        return self == 0
    }
}

extension Optional {
    public func ifValue(_ fn: (Wrapped) throws -> Void) rethrows {
        if case let .some(unwrapped) = self {
            try fn(unwrapped)
        }
    }
    
    public func toValue<T>(_ fn: (Wrapped) throws -> T?) rethrows -> T? {
        if case let .some(unwrapped) = self {
            return try fn(unwrapped)
        }
        return nil
    }
}
