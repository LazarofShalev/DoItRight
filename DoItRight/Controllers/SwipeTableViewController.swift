//
//  SwipeTableViewController.swift
//  DoItRight
//
//  Created by Shalev Lazarof on 11/07/2019.
//  Copyright © 2019 Shalev Lazarof. All rights reserved.
//

import UIKit
import SwipeCellKit
import ViewAnimator

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    // MARK: ViewAnimator
    private let animations = [AnimationType.from(direction: .bottom, offset: 100.0)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
                
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.updateModels(at: indexPath)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        
        return options
    }
    
    func updateModels(at indexPath: IndexPath) {
        // MARK: update our data model
    }
    
    func animate() {
        //tableView.reloadData()
        UIView.animate(views: tableView.visibleCells, animations: animations, completion: {
        })
    }
}

