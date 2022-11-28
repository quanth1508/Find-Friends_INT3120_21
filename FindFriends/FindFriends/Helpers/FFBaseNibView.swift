//
//  FFBaseNibView.swift
//  FF
//
//  Created by Quan Tran on 15/10/2022.
//

import UIKit
import SnapKit


public protocol FFViewSetup {
    func setup()
}

public
extension UIView {
    func ff_loadNib (owner: Any? = nil, bundle: Bundle?) {
        (bundle ?? Bundle.main).loadNibNamed(
            self.className,
            owner  : owner ?? self,
            options: nil
        )
    }
    
    @discardableResult
    func ff_loadViewFromNib (bundle: Bundle?) -> UIView? {
        let nib = UINib(nibName: self.className,
                        bundle: bundle)
        guard let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        else { return nil }
        
        addSubview(nibView)
        nibView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // cần để subview này ở dưới để các view khác được thêm trên interface builder còn hiện lên
        sendSubviewToBack(nibView)
        
        return nibView
    }
}

public protocol GViewSetup {
    func setup()
}

open class FFBaseNibView: UIView, FFViewSetup {
    /// Khi subclass dùng ở các package khác cần trả đúng bundle cho nib để load được
    open var bundle: Bundle? { nil }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        ff_loadViewFromNib(bundle: self.bundle)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        ff_loadViewFromNib(bundle: self.bundle)
        setup()
    }
    
    open func setup() {
        // TODO: Implement in sub class
    }
}

open class FFBaseWithoutNibView: UIView, GViewSetup {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    open func setup() {
        // TODO: Implement in sub class
    }
}

public
extension NSObject {
    var className: String {
        return String(describing: type(of: self)).components(separatedBy: ".").last!
    }
    
    class var className: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}
