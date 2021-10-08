//
//  CoreDataManager.swift
//  ToDoApp
//
//  Created by ulas on 29.09.2021.
//

import UIKit
import CoreData

class CoreDataManager {
    
    struct TodoItem {
        var title: String?
        var detail: String?
        var completionTime: Date?
        var modifyTime: Date?
    }
    
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    //save object into Core Data
    class func saveObject(title: String, detail: String?, completionTime: Date?, modifyTime: Date?) {
        
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: K.CoreData.entityName, in: context)
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObject.setValue(title, forKey: K.CoreData.forKeyTitle)
        managedObject.setValue(detail, forKey: K.CoreData.forKeyDetail)
        managedObject.setValue(completionTime, forKey: K.CoreData.forKeyCompletionTime)
        managedObject.setValue(modifyTime, forKey: K.CoreData.forKeyModifyTime)
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    //fetch all the objects from Core Data
    class func fetchObject(selectedScopeIndex: Int? = nil, targetText: String? = nil) -> [TodoItem] {
        
        var todoArray = [TodoItem]()
        
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        
        if let index = selectedScopeIndex, let text = targetText {
            
            if index == K.CoreData.SearchFilters.titleSearchIndex {
                
                let predicate = NSPredicate(format: "\(K.CoreData.SearchFilters.titleFilter) \(K.CoreData.SearchFilters.filterRule)", text)
                fetchRequest.predicate = predicate
                
            } else if index == K.CoreData.SearchFilters.timeSearchIndex {
                
                let sortDate = NSSortDescriptor(key: K.CoreData.SearchFilters.modifyTimeFilter, ascending: false)
                fetchRequest.sortDescriptors = [sortDate]
                
            }
        }
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            
            for item in fetchResult {
                let todo = TodoItem(title: item.title, detail: item.detail, completionTime: item.completionTime, modifyTime: item.modifyTime)
                todoArray.append(todo)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return todoArray
    }
    
}
