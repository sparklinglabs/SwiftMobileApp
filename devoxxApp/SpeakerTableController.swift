//
//  SpeakerTableController.swift
//  devoxxApp
//
//  Created by got2bex on 2015-12-14.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation
import UIKit
import CoreData

//TODO make CellData optional

public class SpeakerTableController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var cellDataArray:[CellDataPrococol]?
    
    func fetchSpeaker() {

    
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Speaker")
        fetchRequest.includesSubentities = true
        fetchRequest.returnsObjectsAsFaults = false

        let sort = NSSortDescriptor(key: "firstName", ascending: true)
        fetchRequest.sortDescriptors = [sort]

        
        cellDataArray = try! managedContext.executeFetchRequest(fetchRequest) as! [CellDataPrococol]
        

        
        
       
    
    }
    
    func back() {
        print("BACK")
        self.parentViewController!.parentViewController?.view!.removeFromSuperview()
        self.parentViewController?.parentViewController?.removeFromParentViewController()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        self.tableView.separatorStyle = .None
        
        
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: Selector("searchSchedule"))
        searchButton.tintColor = UIColor.whiteColor()
        
        
        fetchAll()
        
        
        
        
        self.navigationItem.title = "Speakers"
        
        
        let backLeftButton = UIBarButtonItem(barButtonSystemItem: .Reply, target: self, action: Selector("back"))
        self.navigationItem.leftBarButtonItem = backLeftButton

    }
    
    
    
    public func fetchAll() {
        fetchSpeaker()
        self.tableView.reloadData()
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL_1") as? SpeakerCell
        
        
        if cell == nil {
            cell = SpeakerCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL_1")
            cell?.selectionStyle = .None
            cell!.configureCell()
        }
        
        
        
        
        let cellData = cellDataArray![indexPath.row]
        cell!.firstInformation.text = cellData.getFirstInformation()
        
        var shouldDisplay = false
        if indexPath.row == 0 {
            shouldDisplay = true
        }
        else {
            let previousCellDataInfo = cellDataArray![indexPath.row - 1].getFirstInformation()
            if cellData.getFirstInformation().characters.first == previousCellDataInfo.characters.first {
                shouldDisplay = false
            }
            else {
                 shouldDisplay = true
            }
        }
        
        
        
      
        if shouldDisplay {
            cell!.initiale.text = "\(cellData.getFirstInformation().characters.first!)"
        }
        else {
            cell!.initiale.text = ""
        }
        
        cell!.initiale.textColor = ColorManager.topNavigationBarColor
        cell!.initiale.font = UIFont(name: "Pirulen", size: 25)
        
        cell!.accessoryView = UIImageView(image: UIImage(named: "speaker.png"))
        cell!.accessoryView!.layer.cornerRadius = cell!.accessoryView!.frame.size.width/2
        cell!.accessoryView!.layer.masksToBounds = true
        
        
        
        
        
        
        return cell!
        
    }
    
    
    
    
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cellDataArray == nil {
            return 0
        }
        return cellDataArray!.count
    }
    
    public override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    
    
}