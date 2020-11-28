//
//  ItemStore.swift
//  Homepwner
//
//  Created by Nick Hella on 10/24/20.
//

import UIKit

class ItemStore{
    
    var allItems = [Item]()
    
    // @discardableResult means the caller can ignore the return object 
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
    }
    
    // Loading up allItems list
    init() {
        for _ in 0..<5 {
            createItem()
        }
    }
    
}


