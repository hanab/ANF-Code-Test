//
//  ExploreItemTableViewCell.swift
//  ANF Code Test
//
//  Created by Hana on 1/23/25.
//

import UIKit

class ExploreItemTableViewCell: UITableViewCell {
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var topDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17).bold()
        return label
    }()
    
    lazy var promoMessage: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    lazy var bottomDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var exploreContentView: ContentButtonsStackView = {
        let contentView = ContentButtonsStackView()
        return contentView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
     }
     
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(stackView)
        contentView.addSubview(exploreContentView)
        setBackgroundImageViewConstraints()
        
        exploreContentView.translatesAutoresizingMaskIntoConstraints = false
        exploreContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        exploreContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        
        stackView.addArrangedSubview(topDescriptionLabel)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(promoMessage)
        stackView.addArrangedSubview(bottomDescription)
        stackView.addArrangedSubview(exploreContentView)
        
        setStackViewConstraints()
    }
    
    func setBackgroundImageViewConstraints() {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 4/5).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
    }
    
    func setStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: 10).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true

    }
    
    func updateWith(exploreItem: ExploreItem) {
        if let image = UIImage(named: exploreItem.backgroundImage) {
            backgroundImageView.image = image
        }
        topDescriptionLabel.text = exploreItem.topDescription
        titleLabel.text = exploreItem.title
        promoMessage.text = exploreItem.promoMessage
        if let bottomText = exploreItem.bottomDescription?.htmlToString {
            bottomDescription.text = bottomText
        }
        if let contents = exploreItem.content {
            exploreContentView.updateWith(contents: contents)
        }
    }
}
