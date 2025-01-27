//
//  ContentButtonsStackView.swift
//  ANF Code Test
//
//  Created by Hana on 1/23/25.
//

import UIKit

class ContentButtonsStackView: UIView {
    
    // MARK: properties
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 6
        stackView.distribution = .fill
        return stackView
    }()
    
    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
    
    // MARK: methods
    func updateWith(contents: [Content]) {
        removeSubviews()
        for content in contents {
            let contentButton = ContentButtonsView()
            contentButton.translatesAutoresizingMaskIntoConstraints = false
            contentButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            contentButton.update(content: content)
            stackView.addArrangedSubview(contentButton)
        }
    }
    
    func removeSubviews() {
        for subView in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(subView)
            subView.removeFromSuperview()
        }
    }
}
