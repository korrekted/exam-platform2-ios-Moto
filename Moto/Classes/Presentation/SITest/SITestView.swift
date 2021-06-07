//
//  SITestView.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 07.04.2021.
//

final class SITestView: UIView {
    lazy var bottomButton = makeBottomButton()
    lazy var nextButton = makeNextButton()
    lazy var tableView = makeTableView()
    lazy var gradientView = makeGradientView()
    lazy var navigationView = makeNavigationView()
    lazy var progressView = makeCollectionView()
    lazy var loader = makeLoader()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Public
extension SITestView {
    func setupBottomButton(for state: SIBottomButtonState) {
        switch state {
        case .confirm:
            bottomButton.setAttributedTitle("Question.Continue".localized.attributed(with: Self.buttonAttr), for: .normal)
        case .finish:
            bottomButton.setAttributedTitle("Question.Finish".localized.attributed(with: Self.buttonAttr), for: .normal)
        case .hidden:
            break
        }
        
        [bottomButton, gradientView].forEach {
            $0.isHidden = state == .hidden
        }
    }
    
    func saveQuestion(_ isSave: Bool) {
        let image = isSave ? UIImage(named: "Question.Bookmark.Check") : UIImage(named: "Question.Bookmark.Uncheck")
        navigationView.rightAction.setImage(image, for: .normal)
    }
}

// MARK: Private
private extension SITestView {
    func initialize() {
        backgroundColor = TestPalette.background
        nextButton.isHidden = true
    }
    
    static let buttonAttr = TextAttributes()
        .font(Fonts.SFProRounded.semiBold(size: 20.scale))
        .textColor(TestPalette.primaryTint)
        .textAlignment(.center)
}

// MARK: Make constraints
private extension SITestView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            navigationView.topAnchor.constraint(equalTo: topAnchor),
            navigationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            navigationView.heightAnchor.constraint(equalToConstant: 125.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: navigationView.bottomAnchor),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 75.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: progressView.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            gradientView.heightAnchor.constraint(equalToConstant: 177.scale),
            gradientView.leftAnchor.constraint(equalTo: leftAnchor),
            gradientView.rightAnchor.constraint(equalTo: rightAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomButton.heightAnchor.constraint(equalToConstant: 60.scale),
            bottomButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            bottomButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            bottomButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -59.scale)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.heightAnchor.constraint(equalToConstant: 44.scale),
            nextButton.widthAnchor.constraint(equalTo: nextButton.heightAnchor),
            nextButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16.scale),
            nextButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -59.scale)
        ])
        
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: centerYAnchor),
            loader.heightAnchor.constraint(equalToConstant: 35.scale),
            loader.widthAnchor.constraint(equalTo: loader.heightAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SITestView {
    func makeTableView() -> SITestTableView {
        let view = SITestTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.contentInsetAdjustmentBehavior = .never
        addSubview(view)
        return view
    }
    
    func makeBottomButton() -> UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20.scale
        view.backgroundColor = TestPalette.primaryButton
        addSubview(view)
        return view
    }
    
    func makeNextButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "Question.Next"), for: .normal)
        view.tintColor = TestPalette.secondaryTint
        view.backgroundColor = TestPalette.secondaryButton
        view.layer.cornerRadius = 16.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeGradientView() -> UIView {
        let view = UIView()
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = TestPalette.bottomGradients
        gradientLayer.locations = [0, 0.65]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 195.scale))
        
        view.layer.mask = gradientLayer
        view.isUserInteractionEnabled = false
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNavigationView() -> NavigationBar {
        let view = NavigationBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = NavigationPalette.navigationBackground
        view.leftAction.setImage(UIImage(named: "General.Pop"), for: .normal)
        view.leftAction.tintColor = NavigationPalette.navigationTint
        view.rightAction.tintColor = NavigationPalette.navigationTint
        addSubview(view)
        return view
    }
    
    func makeCollectionView() -> SIProgressCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 9.scale
        let view = SIProgressCollectionView(frame: .zero, collectionViewLayout: layout)
        view.contentInset = UIEdgeInsets(top: 0, left: 24.scale, bottom: 0, right: 24.scale)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLoader() -> LoaderView {
        let view = LoaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
