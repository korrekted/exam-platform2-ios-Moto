//
//  TestStatsFilterCell.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 13.02.2021.
//

import UIKit
import RxSwift
import RxCocoa

class TestStatsFilterCell: UITableViewCell {
    
    lazy var filterView = makeFilterView()
    private var disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

// MARK: Public
extension TestStatsFilterCell {
    func setup(selectedFilter: TestStatsFilter, didSelect: @escaping (TestStatsFilter) -> Void) {
        filterView.setup(selectedFilter: selectedFilter)
        Observable<TestStatsFilter>
            .merge(
                filterView.allButton.rx.tap.map { _ in .all },
                filterView.correctButton.rx.tap.map { _ in .correct },
                filterView.incorrectButton.rx.tap.map { _ in .incorrect }
            )
            .subscribe(onNext: didSelect)
            .disposed(by: disposeBag)
    }
}

// MARK: Private
private extension TestStatsFilterCell {
    func initialize() {
        backgroundColor = .clear
        selectionStyle = .none
        
    }
}

// MARK: Make constraints
private extension TestStatsFilterCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            filterView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24.scale),
            filterView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            filterView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            filterView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 24.scale),
        ])
    }
}

// MARK: Lazy initialization
private extension TestStatsFilterCell {
    func makeFilterView() -> TestStatsFilterView {
        let view = TestStatsFilterView()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
