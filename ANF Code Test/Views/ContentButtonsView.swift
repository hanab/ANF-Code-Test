//
//  ContentButtonsView.swift
//  ANF Code Test
//
//  Created by Hana on 1/23/25.
//

import UIKit
public typealias ContentButtonBlock = () -> Void

class ContentButtonsView: UIView {
    
    var contentButtonBlock: ContentButtonBlock?
    
    lazy var contentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(contentButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentButton)
        
        contentButton.translatesAutoresizingMaskIntoConstraints = false
        contentButton.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        contentButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        contentButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        contentButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        contentButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func contentButtonTapped() {
        self.contentButtonBlock?()
    }
    
    func update(content: Content) {
        contentButton.setTitle(content.title, for: .normal)
        contentButtonBlock = {
            if let url = URL(string: content.target) {
                UIApplication.shared.open(url)
            }
        }
    }
}
