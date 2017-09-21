//
//  ArticleListViewController.swift
//  HackerPiper
//
//  Created by mohan on 9/19/17.
//  Copyright © 2017 mohan. All rights reserved.
//

import UIKit
import RealmSwift

class ArticleListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialSetup()
        loadDataFromRealm()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var itemListTableView: UITableView!
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    var items = [Item]()
    
    func initialSetup(){
        self.navigationItem.title = "Top Stories"
        setupTableView()
    }
    
    func setupTableView(){
        itemListTableView.estimatedRowHeight = 90.0
        itemListTableView.rowHeight = UITableViewAutomaticDimension
        itemListTableView.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "ItemTableViewCell")
    }
    
    func loadDataFromRealm(){
        let realm = try! Realm()
        items = Array(realm.objects(Item.self).filter("type != 'comment'"))
        itemListTableView.reloadData()
        //print("result from realm: \(result)")
        if items.count == 0 {
            hitForTopStories()
        }
    }
}


extension ArticleListViewController{
    //all api calls
    func hitForTopStories(){
        WebRequestManager.requestGETURL(strURL: topStoryURL, params: nil, headers: nil, isLoader: true, success: { (result) in
            print("detail success : \(result)")
            if let topStoriesIds = result as? [Int]{
                if Item.initItemsWithId(ids: topStoriesIds){
                    self.loadDataFromRealm()
                }
            }
            
        }) { (error) in
            //print("error: \(error)")
        }
    }
}


extension ArticleListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as! ItemTableViewCell
        cell.indexPath = indexPath
        cell.delegate = self
        cell.model = items[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let containorController = UIStoryboard.containerViewController()
        containorController.itemModel = items[indexPath.row]
        self.navigationController?.pushViewController(containorController, animated: true)
    }
}

extension ArticleListViewController: ItemFetchedProtocol{
    func itemFetched(at: IndexPath){
        itemListTableView.reloadRows(at: [at], with: .none)
    }
}




