//
//  MHHeroDetailTableHeadView.swift
//  MarvelHeroes
//
//  Created by 姚巍 on 2018/3/16.
//  Copyright © 2018年 姚巍. All rights reserved.
//

import UIKit

class MHHeroDetailTableHeadView: UIView {
    
    var likeBtnActionBlock:((_ btn: UIButton) -> ())?
    
    private lazy var coverIV: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    private lazy var likeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.white
        btn.isHidden = true
        btn.setImage(UIImage(named: "detail_like"), for: .normal)
        btn.setImage(UIImage(named: "detail_like_selected"), for: .selected)
        btn.addTarget(self, action: #selector(likeBtnAction(btn:)), for: .touchUpInside)
        btn.isAccessibilityElement = true
        btn.accessibilityIdentifier = "HeroLikeBtn"
        btn.accessibilityLabel = "HeroLikeBtn"
        return btn
    }()
    
    var heroDetail: MHDetailCharacter? {
        didSet {
            if let heroDetail = heroDetail {
                likeBtn.isHidden = false
                likeBtn.isSelected = heroDetail.isLike
                coverIV.setWebImage(URLStr: heroDetail.image)
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
    
    @objc private func likeBtnAction(btn: UIButton) {
        likeBtnActionBlock?(btn)
    }
    
    private func setupUI(){
        addSubview(coverIV)
        coverIV.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: coverIV, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: coverIV, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: coverIV, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: coverIV, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: kScreenW))
        
        addSubview(likeBtn)
        likeBtn.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: likeBtn, attribute: .bottom, relatedBy: .equal, toItem: coverIV, attribute: .bottom, multiplier: 1, constant: -kMargin))
        addConstraint(NSLayoutConstraint(item: likeBtn, attribute: .right, relatedBy: .equal, toItem: coverIV, attribute: .right, multiplier: 1, constant: -kMargin))
    }
}
