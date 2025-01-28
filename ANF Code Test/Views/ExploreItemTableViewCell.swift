//
//  ExploreItemTableViewCell.swift
//  ANF Code Test
//
//  Created by Hana on 1/23/25.
//

import UIKit

class ExploreItemTableViewCell: UITableViewCell {
    
    // MARK: properties
    var heightConstraint: NSLayoutConstraint?
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var backgroundImageView: ScaleAspectFitImageView = {
        let imageView = ScaleAspectFitImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var topDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17).bold()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var promoMessage: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var bottomDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var exploreContentView: ContentButtonsStackView = {
        let contentView = ContentButtonsStackView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    
    // MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
     }
     
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: lifecycle methods
    override func prepareForReuse() {
        super.prepareForReuse()
        
        backgroundImageView.image = nil
        topDescriptionLabel.text = nil
        titleLabel.text = nil
        promoMessage.text = nil
        bottomDescription.text = nil
        exploreContentView.removeSubviews()
    }
    
    // MARK: methods
    func setUI() {
        contentView.addSubview(stackView)
        setStackViewConstraints()
        stackView.addArrangedSubview(backgroundImageView)
        stackView.addArrangedSubview(topDescriptionLabel)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(promoMessage)
        stackView.addArrangedSubview(bottomDescription)
        stackView.addArrangedSubview(exploreContentView)
        
        exploreContentView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20).isActive = true
        exploreContentView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20).isActive = true
        // spacing for the this positons look biger so I added this 
        stackView.setCustomSpacing(6, after: promoMessage)
        stackView.setCustomSpacing(20, after: backgroundImageView)
    }
    
    func setStackViewConstraints() {
        let top = stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        top.priority = UILayoutPriority(rawValue: 999)
        top.isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
    }
    
    func updateWith(exploreItem: ExploreItem) {
        topDescriptionLabel.text = exploreItem.topDescription
        titleLabel.text = exploreItem.title
        promoMessage.text = exploreItem.promoMessage
        bottomDescription.text = exploreItem.bottomDescription?.htmlToString
        if let contents = exploreItem.content {
            exploreContentView.updateWith(contents: contents)
        }
    }
}
