//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Nick Hella on 11/2/20.
//

import UIKit

class PhotosViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad func called")

        store.fetchInterestingPhotos {
            (photosResult) -> Void in
            
            switch photosResult {
                case let .success(photos):
                    print("Successfully found \(photos.count) photos")
                    if let firstPhoto = photos.first {
                        self.updateImageView(for: firstPhoto)
                    }
                case let .failure(error):
                    print("Error fetching interesting photos: \(error)")
            }
        }
    }
    
    func updateImageView(for photo: Photo) {
        store.fetchImage(for: photo) { (ImageResult) -> Void in
            print("updateImageView func called")

            switch ImageResult {
                case let .success(image):
                    self.imageView.image = image
                case let .failure(error):
                    print("Error downloading image: \(error)")
            }
        }
    }
    
}
