//
//  Test.swift
//  TestGreenP
//
//  Created by 신아람 on 1/18/24.
//

import UIKit
import UAdFramework

extension FeedListTableViewCell {
    func configure(nativeAd: UAdNativeAd) {
        
        feedInfoView.configure(title: nativeAd.headline()!, content: nativeAd.body()!, reward: 1, point: nativeAd.price()!)
        
        if let icon = nativeAd.icon() {
            iconImageView.image = icon
        }

        button.setTitle(nativeAd.callToAction()!, for: .normal)
        button.isHidden = false
        
        print("store : \(nativeAd.store())")
    }
}

class FeedListTableViewCell : UIView {
    private let feedImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 8
        view.backgroundColor = .lightGray
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 8
        view.backgroundColor = .lightGray
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    private let feedInfoView = FeedInfoView()
    private let button: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.titleLabel?.textColor = .yellow
        button.backgroundColor = .gray
        button.layer.cornerRadius = 4
        button.isEnabled = false
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        
        feedImageView.image = nil
        iconImageView.image = nil
        feedImageView.isHidden = true
        iconImageView.isHidden = false
        
        setupLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Never Will Happen")
    }
    
    private func setupLayoutConstraints() {
        let bgView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        let verticalStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.alignment = .fill
            stackView.distribution = .fill
            stackView.spacing = 10
            return stackView
        }()
        let horizontalStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .fillProportionally
            stackView.spacing = 10
            return stackView
        }()
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(5)
        }
        bgView.addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
        
        verticalStackView.addArrangedSubview(feedImageView)
        verticalStackView.addArrangedSubview(horizontalStackView)
        feedImageView.snp.makeConstraints { make in
            make.width.equalTo(feedImageView.snp.height).multipliedBy(2).priority(.high)
        }
        horizontalStackView.snp.makeConstraints { make in
            make.height.equalTo(70)
        }
        horizontalStackView.addArrangedSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(iconImageView.snp.height)
        }
        horizontalStackView.addArrangedSubview(feedInfoView)
        feedInfoView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
        horizontalStackView.addArrangedSubview(button)
        button.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
    }
    
    private func updateUIOnListMode() {
        feedImageView.isHidden = true
        iconImageView.isHidden = false
    }
    
    private func updateUIOnFeedMode() {
        feedImageView.isHidden = false
        iconImageView.isHidden = true
    }
}
