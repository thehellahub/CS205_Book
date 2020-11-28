//
//  PhotoStore.swift
//  Photorama
//
//  Created by Nick Hella on 11/2/20.
//

import UIKit


enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

enum PhotoError: Error {
    case imageCreationError
}

enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

class PhotoStore {
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    private func processPhotosRequest(data: Data?, error: Error?) -> PhotosResult {
        print("processPhotosRequest func called")
        guard let jsonData = data else {
            print("Failed at point Elon")
            return .failure(error!) // from PhotosResult enum
        }
        return FlickrAPI.photos(fromJSON: jsonData)
    }
    
    func fetchInterestingPhotos(completion: @escaping (PhotosResult) -> Void) {
        print("fetchInterestingPhotos func called")
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data,response,error) -> Void in

            let result = self.processPhotosRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        
//        let task = session.dataTask(with: request) { (data,response,error) -> Void in
//
//            if let jsonData = data {
//                do {
//                    let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
//                    print(jsonObject)
//                } catch let error {
//                    print("Error creating JSON object: \(error)")
//                }
//
//            } else if let requestError = error {
//                print("Error fetching interesting photos: \(requestError)")
//            } else {
//                print("Unexpected error with the request")
//            }
//        }
        task.resume()
    }
    
    func fetchImage(for photo: Photo, completion: @escaping (ImageResult) -> Void) {
        print("fetchImage func called")
        let photoURL = photo.remoteURL
        let request = URLRequest(url: photoURL)
        
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            let result = self.processImageRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
    
    private func processImageRequest(data: Data?, error: Error?) -> ImageResult {
        print("processImageRequest func called")
        guard
            let imageData = data,
            let image = UIImage(data: imageData) else {
            
            // Couldn't create an image
            if data == nil {
                return .failure(error!)
            } else {
                return .failure(PhotoError.imageCreationError)
            }
        }
        return .success(image)
    }
}
