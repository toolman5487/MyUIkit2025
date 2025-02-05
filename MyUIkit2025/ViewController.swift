//
//  ViewController.swift
//  MyUIkit2025
//
//  Created by Willy Hsu on 2025/2/3.
//

import UIKit
import SwiftyJSON
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var theCollectionView: UICollectionView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var followedNumber: UILabel!
    @IBOutlet weak var followerNumber: UILabel!
    @IBOutlet weak var postNumber: UILabel!
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userID: UILabel!
    let images = ["swift_001","swift_002","swift_003","swift_004","swift_005"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theCollectionView.dataSource = self
        theCollectionView.delegate = self
        
        headView.clipsToBounds = true
        headView.layer.cornerRadius = headView.frame.width / 2
        headView.layer.borderColor = UIColor.black.cgColor
        headView.layer.borderWidth = 3
        
        headImageView.clipsToBounds = true
        headImageView.layer.cornerRadius = headImageView.frame.width / 2
        
        segmentControl.clipsToBounds = true
        segmentControl.layer.borderWidth = 3
        segmentControl.layer.cornerRadius = 10
        segmentControl.layer.shadowColor = UIColor.black.cgColor
        segmentControl.layer.shadowOffset = CGSize(width: 2, height: 2)
        segmentControl.layer.shadowOpacity = 0.5
        segmentControl.layer.shadowRadius = 4
        
        updateView()
        randomNumber()
        collectionLayout(numberInLine: 3)
        
        
    }
    
    func updateView(){
        indicator.startAnimating()
        getUserdata { user, error in
            if let error = error {
                let alert = UIAlertController(title: "錯誤", message: error.localizedDescription, preferredStyle:.alert)
                alert.addAction(UIAlertAction(title: "確認", style: .default, handler: { alert in
                    self.indicator.stopAnimating()
                }))
                self.present(alert, animated: true)
            }
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: DispatchWorkItem(block: {
                if let user = user {
                    self.headImageView.sd_setImage(with: URL(string:user["picture"]["large"].stringValue)){ image, error, type, url in
                        
                        if let error = error {
                            let alert = UIAlertController(title: "錯誤", message: error.localizedDescription, preferredStyle:.alert)
                            alert.addAction(UIAlertAction(title: "確認", style: .default, handler: { alert in
                                self.indicator.stopAnimating()
                            }))
                            self.present(alert, animated: true)
                        }
                        
                        self.indicator.stopAnimating()
                        self.nameLabel.text = "\(user["name"]["first"].stringValue) \(user["name"]["last"].stringValue)"
                        self.countryLabel.text = "國籍：\(user["location"]["country"].stringValue)"
                        self.yearLabel.text = "年紀：\(user["dob"]["age"].stringValue) 歲"
                        self.userID.text = "\(user["login"]["username"].stringValue)"
                        let gender = user["gender"].stringValue
                        let genderText = (gender == "male") ? "男性" : (gender == "female") ? "女性" : "未知"
                        self.sexLabel.text = "性別：\(genderText)"
                    }
                }
            }))
        }
        
    }
    func getUserdata(_ handler:@escaping(_ user: JSON?, _ error: Error?)->()){
        APIModel.share.queryRandomUser{ data, error in
            if let error = error {
                print("error: \(error)")
                handler(nil, error)
                return
            }
            if let data = data {
                let user = JSON(data)["results"].arrayValue[0]
                handler(user, nil)
                print(user["name"]["first"].stringValue)
                print(user["gender"].stringValue)
                print(user["location"]["country"].stringValue)
                print(user["dob"]["age"].stringValue)
                print(user["login"]["username"].stringValue)
                print(user["picture"]["medium"].stringValue)
            }
        }
    }
    func randomNumber(){
        let post = Int.random(in: 0...100)
        let follower = Int.random(in: 0...999)
        let followed = Int.random(in: 20...200)
        
        postNumber.text = "\(post)"
        followerNumber.text = "\(follower)"
        followedNumber.text = "\(followed)"
    }
    func collectionLayout(numberInLine: CGFloat){
        let width = theCollectionView.frame.width
        let cellWidth = (width - (numberInLine - 1) * 10)/numberInLine
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        theCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    @IBAction func theSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            collectionLayout(numberInLine: 3)
        case 1:
            collectionLayout(numberInLine: 4)
        case 2:
            collectionLayout(numberInLine: 5)
        default:
            break
        }
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! MyCollectionViewCell
        //        cell.backgroundColor = UIColor.secondaryLabel
        //        let image = UIImageView(image: UIImage(named: images[indexPath.row]))
        //        image.frame = cell.bounds
        //        image.contentMode = .scaleAspectFill
        //        cell.addSubview(image)
        
        cell.theImageView.image = UIImage(named: images[indexPath.row])
        cell.setCellUI()
        cell.viewerAction = {
            let imageViewPage =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
            imageViewPage.theImage = UIImage(named: self.images[indexPath.row])
            self.present(imageViewPage, animated: true) {
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerID", for: indexPath)
        cell.backgroundColor = UIColor.black
        return cell
    }
}

