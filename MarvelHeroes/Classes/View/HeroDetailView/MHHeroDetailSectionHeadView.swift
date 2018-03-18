//
//  MHHeroDetailSectionHeadView.swift
//  MarvelHeroes
//
//  Created by 姚巍 on 2018/3/16.
//  Copyright © 2018年 姚巍. All rights reserved.
//

import UIKit

class MHHeroDetailSectionHeadView: UIView {
    
    private lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return lab
    }()
    
    var title: String? {
        didSet{
            titleLab.text = title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        addSubview(titleLab)
        titleLab.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: titleLab, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: titleLab, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: kMargin))
    }
    
}
