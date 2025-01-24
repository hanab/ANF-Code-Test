//
//  ContentButtonsStackView.swift
//  ANF Code Test
//
//  Created by Hana on 1/23/25.
//

import UIKit

class ContentButtonsStackView: UIView {
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        let bottom = stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        bottom.priority = UILayoutPriority(rawValue: 999)
        bottom.isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateWith(contents: [Content]) {
        removeSubviews()
        for content in contents {
            let contentButton = ContentButtonsView()
            contentButton.update(content: content)
            stackView.addArrangedSubview(contentButton)
        }
    }
    
    private func removeSubviews() {
        for subView in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(subView)
            subView.removeFromSuperview()
        }
    }
}
