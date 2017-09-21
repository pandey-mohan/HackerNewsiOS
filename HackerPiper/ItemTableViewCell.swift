//
//  ItemTableViewCell.swift
//  HackerPiper
//
//  Created by mohan on 9/20/17.
//  Copyright © 2017 mohan. All rights reserved.
//

import UIKit
import RealmSwift


protocol ItemFetchedProtocol {
    func itemFetched(at: IndexPath)
}

class ItemTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userAndTimeLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    @IBOutlet weak var urlLabel: UILabel!
    
    var indexPath: IndexPath!
    var delegate: ItemFetchedProtocol?
    var model: Item?{
        didSet{
            if let model = model{
                
                if model.isFetched {
                    //setup UI
                    voteCountLabel.text = "\(model.score)"
                    titleLabel.text = model.title
                    commentCountLabel.text = "\(model.descendants)"
                    userAndTimeLabel.text = "\(PiperUtils.getDate(time: model.time)) * \(model.by ?? "")"
                    urlLabel.text = model.url
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
                    self.model?.isFetched = true
                    if let kids = resultDict["kids"] as? [Int]{
                        for kid in kids{
                            let intObject = IntObject()
                            intObject.value = kid
                            self.model?.kids.append(intObject)
                        }
                    }
                    var newDict = resultDict
                    newDict.removeValue(forKey: "kids")
                    realm.create(Item.self, value: newDict, update: true)
                }
                self.delegate?.itemFetched(at: self.indexPath)
            }
            
        }) { (error) in
            //print("error: \(error)")
        }
    }
    
}
