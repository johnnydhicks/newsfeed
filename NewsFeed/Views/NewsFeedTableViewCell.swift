//
//  NewsFeedTableViewCell.swift
//  NewsFeed
//
//  Created by Johnny Hicks on 4/9/21.
//

import UIKit

class NewsFeedTableViewCell: UITableViewCell {
    
    var article: Article? {
        didSet {
            if let article = article {
               updateViews(with: article)
            }
        }
    }
        
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .systemGray
        label.numberOfLines = 2
        return label
    }()
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textColor = .systemGray2
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private let favoriteView: UIView = {
        let imageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        imageView.tintColor = .systemRed
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 14).isActive = true
        return imageView
    }()
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "placeholder"))
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 88).isActive = true
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(heroImageView)
        heroImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        heroImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        heroImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        addSubview(favoriteView)
        favoriteView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        favoriteView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        let verticalStackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, sourceLabel])
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fill
        verticalStackView.spacing = 3
        verticalStackView.alignment = .top
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(verticalStackView)
        verticalStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        verticalStackView.leadingAnchor.constraint(equalTo: heroImageView.trailingAnchor, constant: 8).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: favoriteView.leadingAnchor, constant: -8).isActive = true
    }
    
    func updateViews(with article: Article) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        sourceLabel.text = article.source
        favoriteView.isHidden = !article.favorite
        heroImageView.image = article.articleImage ?? UIImage(named: "placeholder")
    }
}
