//
//  CustomTabBar.swift
//  EventsApp
//
//  Created by Никита Грицунов on 12.09.2025.
//

import UIKit

class CustomTabBar: UITabBar {
    private var centerBtn: UIButton?
    private var shapeLayer: CALayer?
    private var isFavourite: Bool = false {
        didSet {
            updateCenterButtonAppearance()
        }
    }
    var onCenterTap: (() -> Void)?
    
    struct Constants {
//        static var btnBackgroundColor: UIColor { UIColor(red: 86 / 255, green: 105 / 255, blue: 255 / 255, alpha: 1) }
        static var btnSize: CGSize { CGSize(width: 46, height: 46) }
        static var btnRadius: CGFloat { 23 }
        
        static var btnShadowColor: CGColor { UIColor(red: 74 / 255, green: 67 / 255, blue: 236 / 255, alpha: 0.3).cgColor }
        static var btnSelectedShadowColor: CGColor { UIColor(red: 236 / 255, green: 67 / 255, blue: 67 / 255, alpha: 0.3).cgColor }
        static var btnShadowRadius: CGFloat { 20 }
        static var btnShadowOpacity: Float { 1 }
        
        static var tabBarShadowColor: CGColor { UIColor(red: 157 / 255, green: 178 / 255, blue: 214 / 255, alpha: 0.13).cgColor }
        static var holeInset: CGFloat { 7 }
        static var customHeight: CGFloat { 88 }
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height = Constants.customHeight
        return size
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = Constants.customHeight
        return sizeThatFits
    }
    
    override func draw(_ rect: CGRect) {
        self.addTabBarShape()
        self.createCenterBtn()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCenterButtonPosition()
    }
    
    // MARK: - TabBar Creation
    private func addTabBarShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath().cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        
        // Shadow
        shapeLayer.shadowColor = Constants.tabBarShadowColor
        shapeLayer.shadowOffset = CGSize(width: 0, height: -3)
        shapeLayer.shadowRadius = 8
        shapeLayer.shadowOpacity = 1
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        
        self.shapeLayer = shapeLayer
    }
    
    private func createPath() -> UIBezierPath {
        let path = UIBezierPath()
        let width = self.frame.width
        let height = Constants.customHeight
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()
        
        return path
    }
    
    private func createCenterBtn() {
        if centerBtn == nil {
            let btn: UIButton = {
                let element = UIButton(type: .custom)
                element.layer.cornerRadius = Constants.btnRadius
                element.layer.masksToBounds = false
                
                element.layer.shadowColor = Constants.btnShadowColor
                element.layer.shadowOffset = CGSize(width: 0, height: 8)
                element.layer.shadowRadius = Constants.btnShadowRadius
                element.layer.shadowOpacity = Constants.btnShadowOpacity
                element.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: Constants.btnSize.width, height: Constants.btnSize.height), cornerRadius: Constants.btnSize.width / 2).cgPath
                
                updateButtonBackground(element)
                
                element.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)
                element.translatesAutoresizingMaskIntoConstraints = false
                return element
            }()
            
            self.addSubview(btn)
            centerBtn = btn
            updateCenterButtonPosition()
        }
    }
    
    private func updateCenterButtonPosition() {
        guard let button = centerBtn else { return }
        button.frame = CGRect(x: (self.frame.width - Constants.btnRadius * 2) / 2,
                              y: -Constants.btnRadius,
                              width: Constants.btnRadius * 2,
                              height: Constants.btnRadius * 2)
    }
    
    
    @objc private func centerButtonTapped() {
        print("Center button tapped")
        onCenterTap?()
        isFavourite.toggle()
    }
    
    private func updateCenterButtonAppearance() {
        guard let button = centerBtn else { return }
        updateButtonBackground(button)
    }
    
    private func updateButtonBackground(_ button: UIButton) {
        var backgroundImage = UIImage()

        if isFavourite {
            guard let btn = UIImage(named: "tabBar_centerBtnSelected") else { return }
            backgroundImage = btn
            button.layer.shadowColor = Constants.btnSelectedShadowColor
        } else {
            guard let btn = UIImage(named: "tabBar_centerBtn") else { return }
            backgroundImage = btn
            button.layer.shadowColor = Constants.btnShadowColor
        }
        button.setBackgroundImage(backgroundImage, for: .normal)
    }
    
    // MARK: - Safe Area Insets
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        self.addTabBarShape()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            guard !self.isHidden else { return super.hitTest(point, with: event) }

            if let centerBtn = self.centerBtn {
                let buttonPoint = self.convert(point, to: centerBtn)

                if centerBtn.bounds.contains(buttonPoint) {
                    return centerBtn
                }
            }
            
            return super.hitTest(point, with: event)
        }
    
}
