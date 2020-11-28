//
//  FlickrAPI.swift
//  Photorama
//
//  Created by Nick Hella on 11/2/20.
//

import Foundation


enum FlickrError: Error {
    case invalidJSONData
}

enum Method: String  {
    case interestingPhotos = "flickr.interestingness.getList"
}

struct FlickrAPI {
    
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let apiKey = "a6d819499131071f158fd740860a5a88"
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    
    private static func flickrURL(method: Method, parameters: [String:String]?) -> URL {
        
        print("flickrURL func called")

        var components = URLComponents(string: baseURLString)!
        
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method": method.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": apiKey
        ]
        
        for (key,value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for (key,value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        
        return components.url!
    }
    
    // Calls the function above, "flickrURL"
    static var interestingPhotosURL: URL {
        print("interestingPhotosURL static var called")
        return flickrURL(method: .interestingPhotos, parameters: ["extras": "url_h,date_taken"])
    }
    
    static func photos(fromJSON data: Data) -> PhotosResult {
        print("photos func called")

        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            guard
                let jsonDictionary = jsonObject as? [AnyHashable:Any],
                let photos = jsonDictionary["photos"] as? [String:Any],
                let photosArray = photos["photo"] as? [[String:Any]]
            else {
                // The JSON structure doesn't match our expectations
                print("Failed at point alpha")
                return .failure(FlickrError.invalidJSONData)
            }
            
            var finalPhotos = [Photo]()
            for photoJSON in photosArray {
                if let photo = FlickrAPI.photo(fromJSON: photoJSON) {
                    finalPhotos.append(photo)
                }
            }
            
            if finalPhotos.isEmpty && !photosArray.isEmpty {
                // We weren't able to parse any of the photos
                // Maybe JSON format for photos has changed??
                print("Failed at point bravo")
                return .failure(FlickrError.invalidJSONData)
            }
            return .success(finalPhotos)
        } catch {
            //print("Failed at point Charlie")
            return .failure(error)
        }
    }
    
    private static func photo(fromJSON json: [String: Any]) -> Photo? {
        
        print("photo func called")

        guard
            let photoID = json["id"] as? String,
            let title = json["title"] as? String,
            let dateString = json["datetaken"] as? String,
            let photoURLString = json["url_h"] as? String,
            let url = URL(string: photoURLString),
            let dateTaken = dateFormatter.date(from: dateString)
        else {
            // Don't have enough info to contruct a photo
            //print("Failed at point delta")
            return nil
        }
        return Photo(title: title, photoID: photoID, remoteURL: url, dateTaken: dateTaken)
    }
    
    
}


