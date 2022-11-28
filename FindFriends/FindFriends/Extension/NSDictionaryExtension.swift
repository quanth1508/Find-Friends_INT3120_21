import UIKit


extension NSDictionary {
    
    func getIntForKey(key:String, defaultValue: Int = 0) -> Int {
        if let value = self[key] as? Int {
            return value
        }
        
        if let value = self[key] as? String {
            return value.intValue
        }
        
        return defaultValue
    }
    
    func getFloatForKey(key:String) -> Float {
        if let value = self[key] as? Float {
            return value
        }
        
        if let value = self[key] as? String {
            return value.floatValue
        }
        
        return 0
    }
    
    func getDoubleForKey(key:String, defaultValue: Double = 0) -> Double {
        if let value = self[key] as? Double {
            return value
        }
        
        if let value = self[key] as? String {
            return value.doubleValue
        }
        
        return defaultValue
    }
    
    func getStringForKey(key:String) -> String {
        if let value = self[key] as? String {
            return value
        }
        
        if let value = self[key] as? Int {
            return "\(value)"
        }
        if let value = self[key] as? Double {
            return "\(value)"
        }
        return ""
    }
    
    func getBoolForKey(key:String) -> Bool {
        if let value = self[key] as? Bool {
            return value
        }
        
        if let value = self[key] as? Int {
            return !(value == 0)
        }
        if let value = self[key] as? String {
            return !(value == "" || value == "0")
        }
        return false
    }
}

extension Dictionary {
    
    func getStringForKey(key:String) -> String {
        if let dict = self as? Dictionary<String, Any> {
            if let value = dict[key] as? String {
                return value
            }
            if let value = dict[key] as? Int {
                return "\(value)"
            }
            if let value = dict[key] as? Double {
                return "\(value)"
            }
        }
        return ""
    }
    
    func getIntForKey(key:String) -> Int {
        if let dict = self as? Dictionary<String, Any> {
            if let value = dict[key] as? Int {
                return value
            }
            
            if let value = dict[key] as? String {
                return value.intValue
            }
        }
        return 0
    }
}
