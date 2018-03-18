//
//  MHHeroDetailViewController.swift
//  MarvelHeroes
//
//  Created by 姚巍 on 2018/3/16.
//  Copyright © 2018年 姚巍. All rights reserved.
//

import UIKit

private let kMHHeroDetailTableViewCell = "MHHeroDetailTableViewCell"

class MHHeroDetailViewController: UIViewController {
    
    var heroDetail = MHDetailCharacter()
    
    lazy var tableHeadView = MHHeroDetailTableHeadView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenW))
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.contentInset = UIEdgeInsetsMake(kNavBarHeight, 0, 0, 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = tableHeadView
        tableView.register(MHHeroDetailTableViewCell.self, forCellReuseIdentifier: kMHHeroDetailTableViewCell)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = heroDetail.name
        setupUI()
        loadData()        
    }
    
    func setupUI(){
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        view.addSubview(tableView)
        tableHeadView.likeBtnActionBlock = {[weak self] (btn: UIButton) in
            if btn.isSelected {
                self?.deleteLikeHeroData(heroId: self!.heroDetail.id)
            }else {
                self?.saveLikeHeroData()
            }
        }
    }
    
    func loadData() {
        MHProgressHudManager.shared.showLoadingView()
        self.heroDetail.items.removeAll()
        heroDetail.isLike = currentHeroIsLike(heroId: heroDetail.id)
        
        let group = DispatchGroup()
        
        group.enter()
        MHNetworkManager.shared.requestHeroComicsData(characterId: heroDetail.id) { (data, code, isSuccess) in
            if let tempArr = try? JSONDecoder().decode([MHDetailComics].self, from: data!){
                if tempArr.count > 0 {
                    self.heroDetail.items.append(MHItemsDetail(title: "comics", dataArr: tempArr))
                }
            }
            
            group.leave()
        }
        
        group.enter()
        MHNetworkManager.shared.requestHeroEventsData(characterId: heroDetail.id) { (data, code, isSuccess) in
            if let tempArr = try? JSONDecoder().decode([MHDetailEvent].self, from: data!){
                if tempArr.count > 0 {
                    self.heroDetail.items.append(MHItemsDetail(title: "events", dataArr: tempArr))
                }
            }
            
            group.leave()
        }
        
        group.enter()
        MHNetworkManager.shared.requestHeroSeriesData(characterId: heroDetail.id) { (data, code, isSuccess) in
            if let tempArr = try? JSONDecoder().decode([MHDetailSeries].self, from: data!){
                if tempArr.count > 0 {
                    self.heroDetail.items.append(MHItemsDetail(title: "series", dataArr: tempArr))
                }
            }
            
            group.leave()
        }
        
        group.enter()
        MHNetworkManager.shared.requestHeroStoriesData(characterId: heroDetail.id) { (data, code, isSuccess) in
            if let tempArr = try? JSONDecoder().decode([MHDetailStory].self, from: data!){
                if tempArr.count > 0 {
                    self.heroDetail.items.append(MHItemsDetail(title: "stories", dataArr: tempArr))
                }
            }
            
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            MHProgressHudManager.shared.hiddenLoadingView()
            self.tableHeadView.heroDetail = self.heroDetail
            self.tableView.reloadData()
        }
    }
}

// MARK: - CoreData
extension MHHeroDetailViewController {
    func currentHeroIsLike(heroId: Int) -> Bool {
        let likeHeroArr = MHCoreDataManager.shared.selectLikeHeroData(heroId: heroId)
        return likeHeroArr.count > 0 ? true: false
    }
    
    func saveLikeHeroData() {
        let isSuccess = MHCoreDataManager.shared.insertLikeHeroData(heroDetail: heroDetail)
        if isSuccess {
            heroDetail.isLike = true
            tableHeadView.heroDetail = heroDetail
            NotificationCenter.default.post(name: .MHLikeHeroListChanged, object: nil, userInfo: nil)
        }
    }
    
    func deleteLikeHeroData(heroId: Int){
        MHCoreDataManager.shared.deleteLikeHeroData(heroId: heroId)
        heroDetail.isLike = false
        tableHeadView.heroDetail = heroDetail
        NotificationCenter.default.post(name: .MHLikeHeroListChanged, object: nil, userInfo: nil)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MHHeroDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return heroDetail.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroDetail.items[section].dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeadView = MHHeroDetailSectionHeadView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 45))
        sectionHeadView.title = heroDetail.items[section].title
        return sectionHeadView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  kMargin + 95
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kMHHeroDetailTableViewCell, for: indexPath) as! MHHeroDetailTableViewCell
        cell.itemProtocol = heroDetail.items[indexPath.section].dataArr[indexPath.row]
        return cell
    }
}
