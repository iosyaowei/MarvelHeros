//
//  MHSearchSectionReusableView.swift
//  MarvelHeroes
//
//  Created by 姚巍 on 2018/3/17.
//  Copyright © 2018年 姚巍. All rights reserved.
//

import UIKit

class MHSearchSectionReusableView: UICollectionReusableView {
    
    var searchBarSearchButtonClickedBlock:((_ text: String) -> ())?
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar(frame: CGRect(x: 0, y: 2, width: kScreenW, height: 36))
        bar.searchBarStyle = .minimal
        bar.placeholder = "search by name ..."
        bar.setBackgroundImage(UIImage(), for: .any, barMetrics: UIBarMetrics.default)
        bar.delegate = self
        return bar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        addSubview(searchBar)
    }
}

extension MHSearchSectionReusableView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            searchBarSearchButtonClickedBlock?(text)
        }
    }
}
