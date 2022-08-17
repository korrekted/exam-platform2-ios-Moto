//
//  STChangeLocaleView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 26.05.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class STChangeLocaleView: SSlideView {
    lazy var scrollView = makeScrollView()
    lazy var countryView = LocaleCountryView()
    lazy var languageView = LocaleLanguageView()
    lazy var stateView = LocaleStateView()
    
    private lazy var manager = ProfileManager()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var countries = [Country]()
    
    private lazy var completeTrigger = PublishRelay<Void>()
    
    private lazy var activity = RxActivityIndicator()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var contentViews: [UIView] = {
        [
            countryView,
            languageView,
            stateView
        ]
    }()
}

// MARK: Private
private extension STChangeLocaleView {
    func initialize() {
        backgroundColor = Onboarding.background
        
        countryView.onNext = { [weak self] in self?.countrySelected() }
        languageView.onNext = { [weak self] in self?.languageSelected() }
        stateView.onNext = { [weak self] in self?.stateSelected() }
        
        contentViews
            .enumerated()
            .forEach { index, view in
                scrollView.addSubview(view)
                
                view.frame.origin = CGPoint(x: UIScreen.main.bounds.width * CGFloat(index), y: 0)
                view.frame.size = CGSize(width: UIScreen.main.bounds.width,
                                         height: UIScreen.main.bounds.height)
            }
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(contentViews.count),
                                        height: UIScreen.main.bounds.height)
        
        rx.sentMessage(#selector(layoutSubviews))
            .filter { [weak self] _ -> Bool in
                guard let frame = self?.frame else {
                    return false
                }
                
                return frame.width > 0 && frame.height > 0
            }
            .take(1)
            .flatMapLatest { [weak self] _ -> Single<[Country]> in
                guard let self = self else {
                    return .never()
                }
                
                return self.manager
                    .obtainCountries(forceUpdate: false)
            }
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] countries in
                self?.countries = countries
                
                self?.refresh()
            })
            .disposed(by: disposeBag)
        
        completeTrigger
            .flatMapLatest { [weak self] _ -> Observable<Void> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<Void> {
                    self.manager.set(country: self.getSelectedCountry(),
                                     state: self.getSelectedState(),
                                     language: self.getSelectedLanguage())
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    self.openError()
                }
                
                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
                    .trackActivity(self.activity)
            }
            .subscribe(onNext: { [weak self] in
                self?.onNext()
            })
            .disposed(by: disposeBag)
    }
    
    func refresh() {
        countryView.setup(countries: countries)
        
        if countries.isEmpty {
            completeTrigger.accept(Void())
        } else if countries.count == 1 {
            countrySelected()
        }
    }
    
    func countrySelected() {
        guard
            let countryCode = getSelectedCountry(),
            let languages = countries.first(where: { $0.code == countryCode })?.languages
        else {
            return
        }
        
        languageView.setup(languages: languages)
        
        if languages.isEmpty {
            completeTrigger.accept(Void())
        } else if languages.count == 1 {
            languageSelected()
        } else {
            scroll(to: languageView)
        }
    }
    
    func languageSelected() {
        guard
            let countryCode = getSelectedCountry(),
            let languages = countries.first(where: { $0.code == countryCode })?.languages,
            let languageCode = getSelectedLanguage(),
            let states = languages.first(where: { $0.code == languageCode })?.states
        else {
            return
        }
        
        stateView.setup(states: states)
        
        if states.isEmpty {
            completeTrigger.accept(Void())
        } else if states.count == 1 {
            stateSelected()
        } else {
            scroll(to: stateView)
        }
    }
    
    func stateSelected() {
        completeTrigger.accept(Void())
    }
    
    func getSelectedCountry() -> String? {
        let elements = countryView.tableView.elements
        if elements.isEmpty {
            return nil
        } else if elements.count == 1 {
            return elements.first?.code
        } else {
            return elements.first(where: { $0.isSelected })?.code
        }
    }
    
    func getSelectedLanguage() -> String? {
        let elements = languageView.tableView.elements
        
        if elements.isEmpty {
            return nil
        } else if elements.count == 1 {
            return elements.first?.code
        } else {
            return elements.first(where: { $0.isSelected })?.code
        }
    }
    
    func getSelectedState() -> String? {
        let stats = stateView.states
        
        if stats.isEmpty {
            return nil
        } else if stats.count == 1 {
            return stats.first?.code
        } else {
            let row = stateView.pickerView.selectedRow(inComponent: 0)
            guard stats.indices.contains(row) else {
                return nil
            }
            return stats[row].code
        }
    }
    
    func scroll(to view: UIView) {
        let frame = view.frame
        
        scrollView.scrollRectToVisible(frame, animated: true)
    }
    
    func openError() -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make {
                    observe.onNext(())
                }
                self.vc?.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
}

// MARK: Make constraints
private extension STChangeLocaleView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension STChangeLocaleView {
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = UIColor.clear
        view.isScrollEnabled = false
        view.isPagingEnabled = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
