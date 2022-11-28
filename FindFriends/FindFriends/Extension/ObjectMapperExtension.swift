import ObjectMapper

extension Map {
    func fromPossibleKeys(_ keys: [String], nested: Bool? = nil, delimiter: String = ".", ignoreNil: Bool = false) -> Map {
        guard keys.count > 0 else { return self }
        
        switch mappingType {
        case .fromJSON:
            var map: Map!
            for i in (0..<keys.count).reversed() { // reverse order
                map = self[keys[i]]
                if map.isKeyPresent {
                    return map
                }
            }
            
            return map
            
        case .toJSON:
            return self[keys.last!]
        }
    }
}

extension Mapper {
    public func mapArrayOrNull(JSONObject: Any?) -> [N]? {
        guard JSONObject != nil, !(JSONObject is NSNull)
            else { return [] }
        
        return mapArray(JSONObject: JSONObject)
    }
}

class MapFromJSONToType<T>: TransformType {
    typealias Object = T
    typealias JSON   = Any
    
    private let fromJSON: (Any?) -> T?
    
    public init(fromJSON: @escaping (Any?) -> T?) {
        self.fromJSON = fromJSON
    }

    open func transformFromJSON(_ value: Any?) -> T? {
        return fromJSON(value)
    }

    open func transformToJSON(_ value: T?) -> JSON? {
        return value
    }
}

public
struct MapperGetter {
    static func getDoubleForValue(_ input: Any?) -> Double? {
        if let value = input as? Double {
            return value
        }
        else if let value = input as? String {
            return value.doubleValue
        }
        return nil
    }

    static func getIntForValue(_ input: Any?) -> Int? {
        if let value = input as? Int {
            return value
        }
        else if let value = input as? String {
            return value.intValue
        }
        return nil
    }

    static func getStringForValue(_ input: Any?) -> String? {
        if let value = input as? String {
            return value
        }
        
        if let value = input as? Int {
            return "\(value)"
        }
        if let value = input as? Double {
            return "\(value)"
        }
        return nil
    }

    static func getBoolForValue(_ input: Any?) -> Bool? {
        if let value = input as? Bool {
            return value
        }
        else if let value = input as? Int {
            return !(value == 0)
        }
        else if let value = input as? String {
            return !(value == "" || value == "0" || value.lowercased() == "false")
        }
        return nil
    }
}

let MapFromJSONToDouble = MapFromJSONToType<Double>(fromJSON: MapperGetter.getDoubleForValue)
let MapFromJSONToInt    = MapFromJSONToType<Int>(fromJSON: MapperGetter.getIntForValue)
let MapFromJSONToString = MapFromJSONToType<String>(fromJSON: MapperGetter.getStringForValue)
let MapFromJSONToBool   = MapFromJSONToType<Bool>(fromJSON: MapperGetter.getBoolForValue)

class MapBetweenJSONAndType<J, T>: TransformType {
    typealias Object = T
    typealias JSON   = J
    
    private let fromJSON: (Any?) -> T?
    private let toJSON  : (T?) -> J?
    
    public init(fromJSON: @escaping (Any?) -> T?, toJSON: @escaping (T?) -> J?) {
        self.fromJSON = fromJSON
        self.toJSON   = toJSON
    }

    open func transformFromJSON(_ value: Any?) -> T? {
        return fromJSON(value)
    }

    open func transformToJSON(_ value: T?) -> J? {
        return toJSON(value)
    }
}
