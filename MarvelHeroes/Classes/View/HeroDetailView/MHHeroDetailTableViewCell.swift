//
//  MHHeroDetailTableViewCell.swift
//  MarvelHeroes
//
//  Created by 姚巍 on 2018/3/16.
//  Copyright © 2018年 姚巍. All rights reserved.
//

import UIKit

class MHHeroDetailTableViewCell: UITableViewCell {
    
    private lazy var coverIV: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    private lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 14)
        return lab
    }()
    
    private lazy var descLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 12)
        lab.numberOfLines = 0
        return lab
    }()
    
    var itemProtocol: MHDetailItemProtocol? {
        didSet {
            coverIV.setWebImage(URLStr: itemProtocol?.itemImgURL)
            titleLab.text = itemProtocol?.itemTitle
            descLab.text = itemProtocol?.itemDesc
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        contentView.addSubview(coverIV)
        coverIV.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: coverIV, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: kMargin))
        addConstraint(NSLayoutConstraint(item: coverIV, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: coverIV, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -kMargin))
        addConstraint(NSLayoutConstraint(item: coverIV, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 95))
        addConstraint(NSLayoutConstraint(item: coverIV, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 95))
        
        contentView.addSubview(titleLab)
        titleLab.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: titleLab, attribute: .left, relatedBy: .equal, toItem: coverIV, attribute: .right, multiplier: 1, constant: kMargin))
        addConstraint(NSLayoutConstraint(item: titleLab, attribute: .top, relatedBy: .equal, toItem: coverIV, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: titleLab, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -kMargin))
        
        contentView.addSubview(descLab)
        descLab.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: descLab, attribute: .top, relatedBy: .equal, toItem: titleLab, attribute: .bottom, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: descLab, attribute: .left, relatedBy: .equal, toItem: titleLab, attribute: .left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: descLab, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -kMargin))
        addConstraint(NSLayoutConstraint(item: descLab, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: coverIV, attribute: .bottom, multiplier: 1, constant: 0))
    }
    
}
