//
//  ItemDetailViewController.swift
//  HackerPiper
//
//  Created by mohan on 9/21/17.
//  Copyright © 2017 mohan. All rights reserved.
//

import UIKit
import RealmSwift



class ItemDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
        makeCommentInRealm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBOutlet weak var articleDetailTableView: UITableView!
    
    var comments = [Item]()
    var itemModel: Item!
    
    func setupTableView(){
        articleDetailTableView.estimatedRowHeight = 90.0
        articleDetailTableView.rowHeight = UITableViewAutomaticDimension
        articleDetailTableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentTableViewCell")
    }
    
    func loadDataFromRealm(){
        let realm = try! Realm()
        comments = Array(realm.objects(Item.self).filter("parent = \(itemModel.id)"))
        articleDetailTableView.reloadData()
        //print("result from realm: \(result)")
    }
    
    func makeCommentInRealm(){
        if Item.initItemsWithId(ids: itemModel.kids.map{$0.value}, parent: itemModel.id){
            self.loadDataFromRealm()
        }
    }
}


extension ItemDetailViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        cell.indexPath = indexPath
        cell.delegate = self
        cell.itemModel = comments[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
}

extension ItemDetailViewController: ItemFetchedProtocol{
    func itemFetched(at: IndexPath){
        articleDetailTableView.reloadRows(at: [at], with: .none)
    }
}









