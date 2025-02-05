//
//  MyCollectionViewCell.swift
//  MyUIkit2025
//
//  Created by Willy Hsu on 2025/2/4.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var theImageView: UIImageView!
    
    var viewerAction: (()->())? = nil
    
    func setCellUI(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        theImageView.isUserInteractionEnabled = true
        theImageView.addGestureRecognizer(gesture)
    }
    @objc func tapAction(_ sender: Any?){
        print("ok")
        viewerAction?()
    }
    
}
