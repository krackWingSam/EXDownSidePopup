//
//  EXDownSidePopup.swift
//  EXDownSidePopup
//
//  Created by 강상우 on 11/03/2019.
//  Copyright © 2019 강상우. All rights reserved.
//

import UIKit

extension UIView {
    
}

class EXDownSidePopup: UIView {
    
    let HEIGHT_MARGIN: CGFloat = 90             // X 이상의 기종에서 Bottom UI 표기 오류를 숨기기 위한 preset
    let AVAILABLE_TOUCH_EVENT_Y: CGFloat = 50   // 캔슬 혹은 확대를 위한 터치 가능 범위
    let CANCLE_MOVING_DISTANCE: CGFloat = 100   // 캔슬 기능을 사용하기 위해 사용
    
    enum EXDownSidePopupAction: Int {
        case EXDownSidePopupAction_None = 0
        case EXDownSidePopupAction_Up   = 1
        case EXDownSidePopupAction_Down = 2
    }
    
    enum EXDownSidePopupKind: Int {
        case EXDownSidePopupExtension   = 0     // 확장 애니메이션이 가능
        case EXDownSidePopupCancle      = 1     // 캔슬 가능
    }
    
    // MARK: - Initialization
    class func getPopup(with contentView:UIView!, superView:UIView!, popupKind: EXDownSidePopupKind!) -> EXDownSidePopup {
        let viewsInNib = Bundle.main.loadNibNamed("EXDownSidePopup", owner: self, options: nil)
        var returnView: EXDownSidePopup!
        for view in viewsInNib! {
            if let view = view as? EXDownSidePopup {
                returnView = view
                break
            }
        }
        
        returnView.contentView = contentView
        returnView.superView = superView
        returnView.popupKind = popupKind
        
        returnView.initUI()
        return returnView
    }
    
    private func initUI() {
        if #available(iOS 11.0, *) {
            marginBottom = (UIApplication.shared.windows[0].safeAreaLayoutGuide.owningView?.frame.size.height)! - UIApplication.shared.windows[0].safeAreaLayoutGuide.layoutFrame.origin.y - UIApplication.shared.windows[0].safeAreaLayoutGuide.layoutFrame.size.height
        }
        
        self.frame.size.height = contentHeight + marginBottom
        self.frame.origin.y = _superView.frame.size.height
        self.frame.size.width = _superView.frame.size.width
        
        _contentView.frame.size.width = self.frame.size.width
        _contentView.frame.size.height = self.frame.size.height + HEIGHT_MARGIN
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.shadowMasks(CGSize(width: 0, height: 10), color: UIColor.black.cgColor)
        self.roundCorners([.topLeft, .topRight], radius: 10)
    }
    
    
    //MARK: - UI Custom
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        _contentView.layer.mask = mask
        _contentView.layer.masksToBounds = true
    }
    
    func shadowMasks(_ offset: CGSize, color: CGColor) {
        let path = UIBezierPath(rect: self.bounds)
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
        self.layer.shadowColor = color
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = 10.0
        self.layer.shadowOpacity = 1.0
        self.layer.shadowPath = path.cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = 1
        self.clipsToBounds = false
    }
    
    
    // MARK: - Properties : private
    @IBOutlet weak var imageView: UIImageView!
    
    private var _contentView: UIView!
    var contentView: UIView! {
        get {
            return _contentView
        }
        
        set {
            _contentView = newValue
            contentHeight = _contentView.frame.size.height
            self.insertSubview(_contentView, at: 0)
        }
    }
    
    private var _superView: UIView!
    var superView: UIView {
        get {
            return _superView
        }
        set {
            _superView = newValue
            _superView.addSubview(self)
        }
    }
    
    private var _popupKind: EXDownSidePopupKind!
    var popupKind: EXDownSidePopupKind {
        get {
            return _popupKind
        }
        set {
            _popupKind = newValue
            
            switch _popupKind {
            case .EXDownSidePopupExtension?:
                imageView.image = UIImage(named: "line72")
                break
                
            case .EXDownSidePopupCancle?:
                imageView.image = UIImage(named: "path886")
                break
                
            default:
                break
            }
        }
    }
    
    var isMoving: Bool = false
    var touchPoint: CGPoint = .zero
    var marginBottom: CGFloat = 0
    var contentHeight: CGFloat = 0
}


//MARK: - Animations
extension EXDownSidePopup {
    public func show() {
        self.frame.size.height = contentHeight + marginBottom
        _contentView.frame.size.height = self.frame.size.height + HEIGHT_MARGIN
        self.frame.origin.y = superView.frame.size.height + HEIGHT_MARGIN
        
        restore()
    }
    
    public func hide() {
        let yPosition = superView.frame.size.height + self.frame.size.height + HEIGHT_MARGIN
        
        UIView.animate(withDuration: 0.2) {
            self.frame.origin.y = yPosition
        }
    }
    
    private func restore() {
        UIView.animate(withDuration: 0.2) {
            let yPosition = self.superView.frame.size.height - self.contentHeight - self.marginBottom
            self.frame.origin.y = yPosition
//            self.frame.size.height = self.contentHeight + self.marginBottom
//            self._contentView.frame.size.height = self.contentHeight + self.marginBottom
        }
    }
    
    
    //MARK: - Touch Override
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)
        
        if point.x > 0 && point.x < self.frame.size.width && point.y > 0 && point.y < self.frame.size.height {
            return true
        }
        
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let location = touches.first?.location(in: self)
        
        touchPoint = location!
        if touchPoint.y < 50 {
            isMoving = true
            
            print(touchPoint)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (isMoving) {
            let location = (touches.first?.location(in: superView))!
            
            var yPosition: CGFloat = 0.0
            if (popupKind == .EXDownSidePopupCancle) {
                if location.y < superView.frame.size.height - contentHeight - marginBottom {
                    yPosition = superView.frame.size.height - contentHeight - marginBottom
                }
                else {
                    yPosition = location.y
                }
            }
            else {
                yPosition = location.y
            }
            
            var height: CGFloat = contentHeight + marginBottom
            if height < superView.frame.size.height - self.frame.origin.y {
                height = superView.frame.size.height - self.frame.origin.y
            }
            
            self.frame.origin.y = yPosition
            self.frame.size.height = height + HEIGHT_MARGIN
            _contentView.frame.size.height = self.frame.size.height
            print(self.frame.origin.y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isMoving = false
        
        let location = (touches.first?.location(in: superView))!
        if location.y > superView.frame.size.height - contentHeight - marginBottom + CANCLE_MOVING_DISTANCE {
            hide()
        }
        else if false {
            
        }
        else {
            restore()
        }
    }
}
