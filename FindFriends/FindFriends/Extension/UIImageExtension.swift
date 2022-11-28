
import Foundation
import UIKit

typealias MultiPartData = (data: Data, withName: String, fileName: String, mimeType: String)

extension UIImage {
    
    func asMultiPartFormData(fileName: String = "file.jpg", withName: String) -> MultiPartData? {
        if let imageResize = self.resizeWithWidth(width: 800.0), let imageData = imageResize.jpegData(compressionQuality: 0.8) {
            return (imageData, withName, fileName, "image/jpeg" )
        }
        return nil
    }
    
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        if (width < size.width) {
            return resized(toWidth: width)
        }
        guard let cgImage = self.cgImage else {
            return nil
        }
        return UIImage.init(cgImage: cgImage)
    }
    
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

public
extension UIImageView {
    func rotate90(isRorate: Bool) {
        UIView.animate(withDuration: 0.15) {
            self.transform = isRorate ? CGAffineTransform(rotationAngle: CGFloat.pi/2) : CGAffineTransform.identity
        }
    }
    
    func rotate180(isRotate: Bool = true) {
        UIView.animate(withDuration: 0.15) {
            self.transform = isRotate ? CGAffineTransform(rotationAngle: CGFloat.pi) : CGAffineTransform.identity
        }
    }
}
