//
//  MHHeroCollectionViewCell.swift
//  MarvelHeroes
//
//  Created by 姚巍 on 2018/3/15.
//  Copyright © 2018年 姚巍. All rights reserved.
//

import UIKit

let HERO_CELL_WIDTH = (kScreenW - 3 * kMargin) / 2

class MHHeroCollectionViewCell: UICollectionViewCell {
    
    private lazy var coverIV: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    private lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 14)
        return lab
    }()
    
    var hero: MHCharacter? {
        didSet{
            if let hero = hero {
                nameLab.text = hero.name
                coverIV.setWebImage(URLStr: "\(hero.thumbnail.path).\(hero.thumbnail.exten)")
            }
        }
    }
    
    var likeHero: MHLikeHero? {
        didSet {
            if let hero = likeHero {
                nameLab.text = hero.name
                coverIV.setWebImage(URLStr: hero.image)
            }
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
        contentView.addSubview(coverIV)
        coverIV.translatesAutoresizingMaskIntoConstraints = false
        let coverTopCons = NSLayoutConstraint(item: coverIV, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0)
        let coverLeftCons = NSLayoutConstraint(item: coverIV, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0)
        let coverRightCons = NSLayoutConstraint(item: coverIV, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 0)
        let coverHeightCons = NSLayoutConstraint(item: coverIV, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: HERO_CELL_WIDTH)
        let coverConsArr = [coverTopCons, coverLeftCons, coverRightCons, coverHeightCons]
        contentView.addConstraints(coverConsArr)
        
        contentView.addSubview(nameLab)
        nameLab.translatesAutoresizingMaskIntoConstraints = false
        let nameCenterXCons = NSLayoutConstraint(item: nameLab, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0)
        let nameBottomCons = NSLayoutConstraint(item: nameLab, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -2.5)
        let nameCons = [nameCenterXCons, nameBottomCons]
        contentView.addConstraints(nameCons)
    }
    
}
