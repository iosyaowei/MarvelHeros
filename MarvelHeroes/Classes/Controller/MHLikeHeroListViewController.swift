//
//  MHLikeHeroListViewController.swift
//  MarvelHeroes
//
//  Created by 姚巍 on 2018/3/17.
//  Copyright © 2018年 姚巍. All rights reserved.
//

import UIKit

private let kMHHeroCollectionViewCell = "MHHeroCollectionViewCell"

class MHLikeHeroListViewController: UIViewController {
    
    var dataArr = [MHLikeHero]()
    
    private lazy var collectonView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = kMargin
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: kMargin, bottom: 0, right: kMargin)
        flowLayout.itemSize = CGSize (width: HERO_CELL_WIDTH, height: HERO_CELL_WIDTH + 14 + 8)
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsetsMake(kNavBarHeight, 0, 0, 0)
        collectionView.scrollIndicatorInsets = collectionView.contentInset
        collectionView.register(MHHeroCollectionViewCell.self, forCellWithReuseIdentifier: kMHHeroCollectionViewCell)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Like Hero List"
        setupUI()
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: .MHLikeHeroListChanged, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        TCLog(NSStringFromClass(self.classForCoder) + "--------- deinit")
    }
    
    func setupUI(){
        if #available(iOS 11.0, *) {
            collectonView.contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        view.addSubview(collectonView)
    }
    
    @objc func loadData() {
        dataArr = MHCoreDataManager.shared.selectLikeHeroData(heroId: nil)
        collectonView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MHLikeHeroListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kMHHeroCollectionViewCell, for: indexPath) as! MHHeroCollectionViewCell
        cell.likeHero = dataArr[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hero = dataArr[indexPath.row]
        let heroDetailVc = MHHeroDetailViewController()
        heroDetailVc.heroDetail = MHDetailCharacter(id: Int(hero.id), name: hero.name, image: hero.image, isLike: false, items: [MHItemsDetail]())
        navigationController?.pushViewController(heroDetailVc, animated: true)
    }
}
