
import UIKit

public struct FFCommonHelper {
    
    public static func onPhoneCall(_ phone: String) {
        if phone.isEmpty {
            return
        }
        
        guard let url = URL(string: "TEL://" + phone) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    public
    static func hidePhoneNumber(phone: String) -> String {
        var hidePhone = phone
        if phone.count > 7 {
            
            let startingIndex = phone.index(phone.startIndex, offsetBy: 3)
            let endingIndex = phone.index(phone.endIndex, offsetBy: -4)
            let stars = String(repeating: "*", count: phone.count - 7)
            hidePhone = phone.replacingCharacters(in: startingIndex..<endingIndex,
                                                  with: stars)
            
        }
        return hidePhone
    }
    
    static func logout() {
        FFUser.shared.token = ""
    }
}
