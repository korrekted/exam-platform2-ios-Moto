//
//  OExperienceProgressView.swift
//  Moto
//
//  Created by Andrey Chernyshev on 08.07.2021.
//

final class ODrivingExperienceProgressView: UIView {
    enum Period {
        case period1, period2, period3, period4
    }
    
    var period: Period = .period1 {
        didSet {
            moveCursorView()
        }
    }
    
    lazy var progressView = OSlider()
    lazy var period1Button = UIView()
    lazy var period2Button = UIView()
    lazy var period3Button = UIView()
    lazy var period4Button = UIView()
    lazy var period1Label = UILabel()
    lazy var period4Label = UILabel()
    lazy var cursorView = ODrivingExperienceCursor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        moveCursorView()
    }
}

// MARK: Private
private extension ODrivingExperienceProgressView {
    func initialize() {
        progressView.minimumValue = 1
        progressView.maximumValue = 4
        progressView.trackHeight = 4.scale
        progressView.touchAreaInsetX = -30.scale
        progressView.touchAreaInsetY = -30.scale
        progressView.frame.size = CGSize(width: 335.scale, height: 4.scale)
        progressView.frame.origin = CGPoint(x: 0, y: 35.scale)
        progressView.minimumTrackTintColor = UIColor(integralRed: 237, green: 237, blue: 237)
        progressView.maximumTrackTintColor = UIColor(integralRed: 237, green: 237, blue: 237)
        progressView.thumbTintColor = UIColor(integralRed: 255, green: 101, blue: 1)
        progressView.addTarget(self, action: #selector(update(sender:)), for: .valueChanged)
        
        period1Button.backgroundColor = UIColor(integralRed: 237, green: 237, blue: 237)
        period1Button.frame.size = CGSize(width: 12.scale, height: 12.scale)
        period1Button.frame.origin = CGPoint(x: 0, y: 31.scale)
        period1Button.layer.cornerRadius = 6.scale
        
        period2Button.backgroundColor = UIColor(integralRed: 237, green: 237, blue: 237)
        period2Button.frame.size = CGSize(width: 12.scale, height: 12.scale)
        period2Button.frame.origin = CGPoint(x: 107, y: 31.scale)
        period2Button.layer.cornerRadius = 6.scale
        
        period3Button.backgroundColor = UIColor(integralRed: 237, green: 237, blue: 237)
        period3Button.frame.size = CGSize(width: 12.scale, height: 12.scale)
        period3Button.frame.origin = CGPoint(x: 221.scale, y: 31.scale)
        period3Button.layer.cornerRadius = 6.scale
        
        period4Button.backgroundColor = UIColor(integralRed: 237, green: 237, blue: 237)
        period4Button.frame.size = CGSize(width: 12.scale, height: 12.scale)
        period4Button.frame.origin = CGPoint(x: 323.scale, y: 31.scale)
        period4Button.layer.cornerRadius = 6.scale
        
        period1Label.attributedText = "Onboarding.DrivingExperience.Period1".localized
            .attributed(with: TextAttributes()
                            .textColor(UIColor(integralRed: 31, green: 31, blue: 31, alpha: 0.6))
                            .font(Fonts.SFProRounded.regular(size: 16.scale))
                            .lineHeight(22.4.scale))
        period1Label.frame.origin = CGPoint(x: 0, y: 0)
        period1Label.sizeToFit()
        
        period4Label.attributedText = "Onboarding.DrivingExperience.Period4".localized
            .attributed(with: TextAttributes()
                            .textColor(UIColor(integralRed: 31, green: 31, blue: 31, alpha: 0.6))
                            .font(Fonts.SFProRounded.regular(size: 16.scale))
                            .lineHeight(22.4.scale))
        period4Label.sizeToFit()
        period4Label.frame.origin = CGPoint(x: 335.scale - period4Label.frame.width, y: 0)
        
        cursorView.backgroundColor = UIColor.clear
        cursorView.frame.size = CGSize(width: 98.scale, height: 59.scale)
        
        [
            period1Button, period2Button, period3Button, period4Button,
            progressView,
            period1Label, period4Label,
            cursorView
        ]
        .forEach { addSubview($0) }
    }
    
    @objc
    func update(sender: UISlider) {
        sender.value = round(sender.value)
        
        switch sender.value {
        case 1:
            period = .period1
        case 2:
            period = .period2
        case 3:
            period = .period3
        case 4:
            period = .period4
        default:
            break
        }
    }
    
    func moveCursorView() {
        switch period {
        case .period1, .period4:
            cursorView.isHidden = true
        case .period2:
            cursorView.title = "Onboarding.DrivingExperience.Period2".localized
            cursorView.frame.origin = CGPoint(x: 71.scale, y: 59.scale)
            cursorView.isHidden = false
        case .period3:
            cursorView.title = "Onboarding.DrivingExperience.Period3".localized
            cursorView.frame.origin = CGPoint(x: 182.scale, y: 59.scale)
            cursorView.isHidden = false
        }
    }
}
