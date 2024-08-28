//
//  CNoticeBar.swift
//  TestSwift6
//
//  Created by toro-ios on 2024/8/26.
//

import UIKit
import SnapKit

public enum CNoticeBarLoction {
    case top
    case middle
    case bottom
}

public class CNoticeBarConfig{
    public var bgColor: UIColor = .black
    public var contentFont: UIFont = UIFont.systemFont(ofSize: 15)
    public var contentColor: UIColor = .white
    public var icon: String? = nil
    public var content: String = "content"
    public var loction: CNoticeBarLoction = .top
    public var margin: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    public var imageSize: CGFloat = 20
    public var space: CGFloat = 30
    public var radius: CGFloat = 10
    public var minHeight: CGFloat = 40
    public var stayTime: CGFloat = 2

    public init(content: String,
                bgColor: UIColor? = nil,
                contentFont: UIFont? = nil,
                contentColor: UIColor? = nil,
                icon: String? = nil,
                loction: CNoticeBarLoction? = nil,
                margin: UIEdgeInsets? = nil,
                imageSize: CGFloat? = nil,
                space: CGFloat? = nil,
                radius: CGFloat? = nil,
                minHeight: CGFloat? = nil,
                stayTime: CGFloat? = nil){
        self.content = content
        if bgColor != nil {
            self.bgColor = bgColor!
        }
        if contentFont != nil {
            self.contentFont = contentFont!
        }
        if contentColor != nil {
            self.contentColor = contentColor!
        }
        if loction != nil {
            self.loction = loction!
        }
        if icon != nil {
            self.icon = icon!
        }
        if margin != nil {
            self.margin = margin!
        }
        if imageSize != nil {
            self.imageSize = imageSize!
        }
        if space != nil {
            self.space = space!
        }
        if radius != nil {
            self.radius = radius!
        }
        if minHeight != nil {
            self.minHeight = minHeight!
        }
        if stayTime != nil {
            self.stayTime = stayTime!
        }
    }
}

public class CNoticeBar: UIView {
    
    public var config: CNoticeBarConfig?
    
    private var timer: Timer?
    
    private var textLabel: UILabel?
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(config: CNoticeBarConfig) {
        super.init(frame: .zero)
        self.config = config
        self.backgroundColor = config.bgColor
        self.layer.cornerRadius = config.radius
        initSubViews()
    }
    
    private func initSubViews() -> Void {
                
        let attributedString = NSMutableAttributedString(string: "")
        
        if !(config?.icon?.isEmpty ?? true) {
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(named: (config?.icon)!)
            
            // 设置图片大小
            let imageSize = CGSize(width: config!.imageSize, height: config!.imageSize)
            imageAttachment.bounds = CGRect(origin: CGPoint(x: 0, y: -(config!.imageSize)/4), size: imageSize)
            let imageString = NSAttributedString(attachment: imageAttachment)
            attributedString.append(imageString)
        }
        
        attributedString.append(NSMutableAttributedString(string: " \(config!.content)"))
        
        let textLabel = UILabel()
        textLabel.attributedText = attributedString
        textLabel.textColor = config?.contentColor
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.font = config?.contentFont
        self.textLabel = textLabel
        addSubview(textLabel)
        
        textLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-(config?.margin.right)!)
            make.left.equalTo(config!.margin.left)
        }
        
    }
    
    public func show() -> Void {
        if let window = getCurrentWindow() {
            //移除控制器中的一样视图
            for view in window.subviews {
                if view.isKind(of: CNoticeBar.self) {
                    view.removeFromSuperview()
                }
            }
            //添加新视图
            window.addSubview(self)
        }
        
        //调整视图高度
        var height = config!.minHeight
        self.snp.makeConstraints { make in
            make.left.equalTo(config!.space)
            make.right.equalTo(-config!.space)
        }
        layoutIfNeeded()
        let textHeight = (textLabel?.frame.size.height ?? 0) + config!.margin.top + config!.margin.bottom
        height = textHeight < config!.minHeight ? config!.minHeight : textHeight
        self.snp.makeConstraints { make in
            make.left.equalTo(config!.space)
            make.right.equalTo(-config!.space)
            make.height.equalTo(height)
            switch config?.loction {
            case .top:
                make.top.equalTo(getSafeAreaInsets().top)
            case .middle:
                make.centerY.equalToSuperview()
            case .bottom:
                make.bottom.equalTo(getSafeAreaInsets().bottom == 0 ? -20 :  -getSafeAreaInsets().bottom)
            case .none:
                make.top.equalTo(getSafeAreaInsets().top)
            }
        }
        
        //停掉旧计时器
        if timer?.isValid ?? false {
            timer?.invalidate()
        }
        //启动计时器
        timer = Timer.scheduledTimer(withTimeInterval: config!.stayTime, repeats: false) { timer in
            self.removeFromSuperview()
        }
    }
    
    func getSafeAreaInsets() -> UIEdgeInsets {
        if #available(iOS 13.0, *) {
            // iOS 13 及以上版本
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                return windowScene.windows.first?.safeAreaInsets ?? UIEdgeInsets.zero
            }
        } else {
            // iOS 13 以下版本
            return UIApplication.shared.keyWindow?.safeAreaInsets ?? UIEdgeInsets.zero
        }
        return UIEdgeInsets.zero
    }
    
    func getCurrentWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            // iOS 13 及以上版本
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                return windowScene.windows.first
            }
        } else {
            // iOS 13 以下版本
            return UIApplication.shared.keyWindow
        }
        return nil
    }

}
