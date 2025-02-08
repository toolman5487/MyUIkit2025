//
//  ImageViewController.swift
//  MyUIkit2025
//
//  Created by Willy Hsu on 2025/2/5.
//

import UIKit

class ImageViewController: UIViewController {
    @IBOutlet weak var imageViewer: UIImageView!
    var theImage: UIImage! = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageViewer.image = theImage
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
