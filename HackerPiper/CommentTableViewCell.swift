//
//  CommentTableViewCell.swift
//  HackerPiper
//
//  Created by mohan on 9/21/17.
//  Copyright © 2017 mohan. All rights reserved.
//

import UIKit
import RealmSwift

class CommentTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var timeUserLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    var indexPath: IndexPath!
    var delegate: ItemFetchedProtocol?
    
    var itemModel: Item?{
        didSet{
            if let model = itemModel{
                if model.isFetched {
                    //setup UI
                    timeUserLabel.text = "\(PiperUtils.getDate(time: model.time)) * \(model.by ?? "")"
                    commentLabel.text = model.text
                }else{
                    //hit API to fetch item detail
                    fetchItemDetail(id: model.id)
                }
            }
        }
    }
    
    func fetchItemDetail(id: Int){
        WebRequestManager.requestGETURL(strURL: itemDetail+"\(id).json", params: nil, headers: nil, isLoader: false, success: { (result) in
            print("detail success : \(result)")
            if let resultDict = result as? Dictionary<String, Any>{
                let realm = try! Realm()
                try! realm.write {
                    self.itemModel?.isFetched = true
                    var newDict = resultDict
                    newDict.removeValue(forKey: "kids")
                    // just removung kids as we are not looking at sub comments
                    realm.create(Item.self, value: newDict, update: true)
                }
                self.delegate?.itemFetched(at: self.indexPath)
            }
            
        }) { (error) in
            //print("error: \(error)")
        }
    }
    
}
