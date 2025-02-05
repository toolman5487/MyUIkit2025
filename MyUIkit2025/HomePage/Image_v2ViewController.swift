//
//  Image_v2ViewController.swift
//  MyUIkit2025
//
//  Created by Willy Hsu on 2025/2/5.
//

import UIKit

class Image_v2ViewController: UIViewController {

    @IBOutlet weak var thePageController: UIPageControl!
    @IBOutlet weak var myCollectionView: UICollectionView!
    let images = ["swift_001","swift_002","swift_003","swift_004","swift_005"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.isPagingEnabled = true
        
        thePageController.numberOfPages = images.count
        
        collectionLayout(numberInLine: 1)
        
    }
    func collectionLayout(numberInLine: CGFloat){
        let width = myCollectionView.frame.width
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        myCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    @IBAction func pageChanged(_ sender: Any) {
        let theindexPath = IndexPath(row: thePageController.currentPage, section: 0)
        myCollectionView.scrollToItem(at: theindexPath, at: .centeredHorizontally, animated: true)
    }
    
}

extension Image_v2ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! My_v2CollectionViewCell
        cell.thePicture.image = UIImage(named: images[indexPath.row])
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let cell = myCollectionView.visibleCells.first{
            if let indexPath = myCollectionView.indexPath(for: cell){
                thePageController.currentPage = indexPath.row
            }
        }
    }
    
}
