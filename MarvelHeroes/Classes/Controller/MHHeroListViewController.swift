//
//  ViewController.swift
//  MarvelHeroes
//
//  Created by 姚巍 on 2018/3/14.
//  Copyright © 2018年 姚巍. All rights reserved.
//

import UIKit

private let kMHHeroCollectionViewCell = "MHHeroCollectionViewCell"
private let kMHSearchSectionReusableView = "MHSearchSectionReusableView"

class MHHeroListViewController: UIViewController {
    
    var isPullup: Bool = false
    
    var dataArr = [MHCharacter]()
    
    lazy var refreshCtrl: UIRefreshControl = {
        let ctrl = UIRefreshControl()
        ctrl.addTarget(self, action: #selector(pullDownLoadData), for: .valueChanged)
        return ctrl
    }()
    
    var currentCount = 20
    
    private lazy var collectonView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = kMargin
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: kMargin, bottom: 0, right: kMargin)
        flowLayout.itemSize = CGSize (width: HERO_CELL_WIDTH, height: HERO_CELL_WIDTH + 14 + 8)
        flowLayout.headerReferenceSize = CGSize(width: kScreenW, height: 40)
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsetsMake(kNavBarHeight, 0, 0, 0)
        collectionView.scrollIndicatorInsets = collectionView.contentInset
        collectionView.register(MHHeroCollectionViewCell.self, forCellWithReuseIdentifier: kMHHeroCollectionViewCell)
        collectionView.register(MHSearchSectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kMHSearchSectionReusableView)
        collectionView.addSubview(refreshCtrl)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hero List"
        setupUI()
        loadData()
    }
    
    func setupUI(){
        if #available(iOS 11.0, *) {
            collectonView.contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        view.addSubview(collectonView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "detail_like_selected"), style: .plain, target: self, action: #selector(likeRightItemAction))
    }
    
    @objc func loadData(name: String? = nil) {
        var offset = 0
        if isPullup {
            offset = dataArr.count
        }else {
            refreshCtrl.beginRefreshing()
        }
        
        MHNetworkManager.shared.requestHeroListData(name: name, offset: offset) { (result, code, isSuccess) in
            if !self.isPullup {
                self.refreshCtrl.endRefreshing()
            }
            
            if let tempArr = try? JSONDecoder().decode([MHCharacter].self, from: result!){
                self.currentCount = tempArr.count
                if self.isPullup {
                    self.dataArr.append(contentsOf: tempArr)
                }else {
                    self.dataArr = tempArr
                }
                self.collectonView.reloadData()
            }
            
            self.isPullup = false
        }
    }
    
    @objc private func likeRightItemAction() {
        let likeHeroVc = MHLikeHeroListViewController()
        navigationController?.pushViewController(likeHeroVc, animated: true)
    }
    
    private func searchLoadData(text: String) {
        isPullup = false
        loadData(name: text)
    }
    
    @objc private func pullDownLoadData() {
        isPullup = false
        loadData(name: nil)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MHHeroListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kMHSearchSectionReusableView, for: indexPath) as! MHSearchSectionReusableView
            headView.searchBarSearchButtonClickedBlock = {[weak self] (text: String) in
                self?.searchLoadData(text: text)
            }
            
            return headView
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kMHHeroCollectionViewCell, for: indexPath) as! MHHeroCollectionViewCell
        cell.hero = dataArr[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hero = dataArr[indexPath.row]
        let heroDetailVc = MHHeroDetailViewController()
        heroDetailVc.heroDetail = MHDetailCharacter(id: hero.id, name: hero.name, image: hero.thumbnail.fullPath, isLike: false, items: [MHItemsDetail]())
        self.navigationController?.pushViewController(heroDetailVc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let item = indexPath.item
        let section = collectionView.numberOfSections - 1
        if item < 0 || section < 0 {
            return
        }
        
        let count = collectionView.numberOfItems(inSection: section)
        if (item == count - 1) && !isPullup  && currentCount == 20{
            TCLog("pullup item:\(item)")
            isPullup = true
            loadData()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

