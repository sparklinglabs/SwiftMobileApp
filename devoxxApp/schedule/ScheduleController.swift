//
//  ScheduleController.swift
//  devoxxApp
//
//  Created by maxday on 09.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import UIKit

public class ScheduleController : UINavigationController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
//, DevoxxAppScheduleDelegate, DevoxxAppFilter {
    
    
    var favoriteSwitcher : UISegmentedControl!
    var pageViewController : UIPageViewController?
    
    var overlay = UIView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteSwitcher = UISegmentedControl(frame: CGRectMake(0, 0, 200, 30))
        favoriteSwitcher.insertSegmentWithTitle("Schedule", atIndex: 0, animated: true)
        favoriteSwitcher.insertSegmentWithTitle("My schedule", atIndex: 1, animated: true)
        favoriteSwitcher.selectedSegmentIndex = 0
        favoriteSwitcher.tintColor = UIColor.whiteColor()
        favoriteSwitcher.addTarget(self, action: Selector("changeSchedule:"), forControlEvents: .ValueChanged)
        
        let filterRightButton = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: Selector("filterMe"))
        
        
        self.navigationBar.translucent = false
        
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        
        pageViewController?.dataSource = self
        
        let demo = viewControllerAtIndex(0)
        let controls = [demo]
        
        pageViewController?.setViewControllers(controls, direction: .Forward, animated: false, completion: nil)
        
        pushViewController(pageViewController!, animated: false)
        
        self.view.backgroundColor = ColorManager.bottomDotsPageController
        self.topViewController?.navigationItem.titleView = favoriteSwitcher
        self.topViewController?.navigationItem.rightBarButtonItem = filterRightButton
    
        //addChildViewController(pageViewController!)
        //view.addSubview((pageViewController?.view)!)
    }
    
    func filterMe() {
        if pageViewController != nil && pageViewController!.viewControllers != nil{
            
            
            let t = FilterTableViewController()
            overlay.backgroundColor = UIColor.redColor()
            pageViewController!.viewControllers![0].view.addSubview(overlay)
            //overlay.addSubview(t)

            overlay.translatesAutoresizingMaskIntoConstraints = false
            
            
            
            let widthTalkTitleConstraint = NSLayoutConstraint(item: overlay, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: overlay.superview, attribute: NSLayoutAttribute.Width, multiplier: 0.5, constant: 0)
            widthTalkTitleConstraint.identifier = "widthTalkTitleConstraint"
            
            let heightTalkTitleConstraint = NSLayoutConstraint(item: overlay, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: overlay.superview, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
            heightTalkTitleConstraint.identifier = "heightTalkTitleConstraint"
            
            let topTalkTitleConstraint = NSLayoutConstraint(item: overlay, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: overlay.superview, attribute: NSLayoutAttribute.Top, multiplier: 0.5, constant: 0)
            topTalkTitleConstraint.identifier = "topTalkTitleConstraint"
            
            let leadingTalkTitleConstraint = NSLayoutConstraint(item: overlay, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: overlay.superview, attribute: NSLayoutAttribute.Right, multiplier: 0.5, constant: 0)
            leadingTalkTitleConstraint.identifier = "leadingTalkTitleConstraint"
            
            
            overlay.superview!.addConstraint(widthTalkTitleConstraint)
            overlay.superview!.addConstraint(heightTalkTitleConstraint)
            overlay.superview!.addConstraint(topTalkTitleConstraint)
            overlay.superview!.addConstraint(leadingTalkTitleConstraint)

            
            
            
        
            
        }
    }
    
    func changeSchedule(sender : UISegmentedControl) {
        if pageViewController != nil && pageViewController!.viewControllers != nil{
            if let switchable = pageViewController!.viewControllers![0] as? SwitchableProtocol {
                switchable.updateSwitch(sender.selectedSegmentIndex == 1)
                switchable.performSwitch()
            }
        }
    }

    
    
    public func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var currentIndex = 0
        if let demoController = viewController as? SchedulerTableViewController {
            currentIndex = demoController.index
        }
        
        if currentIndex == 0 {
            return nil
        }
        
        currentIndex--
    
        return viewControllerAtIndex(currentIndex)
    }
    
    public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var currentIndex = 0
        if let demoController = viewController as? SchedulerTableViewController {
            currentIndex = demoController.index
        }
        
        currentIndex++
        
        
        if currentIndex == 3 {
            return nil
        }
        
        return viewControllerAtIndex(currentIndex)
    }
    
    
    public func viewControllerAtIndex(index : NSInteger) -> SchedulerTableViewController {
        
        let demoController = SchedulerTableViewController()
        demoController.index = index
        return demoController
    }
    
    
    public func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 3
    }
    
    public func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

    
    
    
    
    /*
    var seg : UISegmentedControl!
    var pageView : UIPageViewController?
    var pageViewControllers = [UIViewController]()
    
    var constH:[NSLayoutConstraint]!
    
    
    var t = FilterTableViewController()
    
    func initPageViewController() {
        pageView = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        //pageView!.view.frame = CGRectMake(0,(self.navigationController?.navigationBar.frame.size.height)!,380,575)
        pageView?.dataSource = self
        pageView?.delegate = self
        pageView?.setViewControllers(pageViewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        
        //pageView?.view.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.navigationBar.translucent = false
        
        let views = ["pageView": pageView!.view]
        
        //let constH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[pageView]-|", options: .AlignAllCenterX, metrics: nil, views: views)
        //view.addConstraints(constH)
        
        //let constV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[pageView]-|", options: .AlignAllCenterY, metrics: nil, views: views)
        //view.addConstraints(constV)

        
        
        pushViewController(pageView!, animated: false)
        
        
        //self.view.addSubview(pageView!.view)
        self.view.backgroundColor = ColorManager.bottomDotsPageController
        
        //pageView!.view.translatesAutoresizingMaskIntoConstraints = false
        //let views = ["pageView": pageView!.view, "filterView" : t.tableView]
        
        //constH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[pageView]|", options: .AlignAllCenterY, metrics: nil, views: views)
        //view.addConstraints(constH)
        
        
        
        //heightConstant = self.navigationController!.navigationBar.frame.size.height + self.navigationController!.navigationBar.frame.origin.y
        
        //constW = NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(heightConstant)-[pageView]-\(self.tabBarController!.tabBar.frame.height)-|", options: .AlignAllTrailing, metrics: nil, views: views)
        //constW2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(heightConstant)-[filterView]-\(self.tabBarController!.tabBar.frame.height)-|", options: .AlignAllTrailing, metrics: nil, views: views)
        //view.addConstraints(constW)
        //view.addConstraints(constW2)
        
        
        
    }
    
    
    /*
    func completionMethod(isFinished:Bool) {
        if(isFinished) {
            //menuView.removeFromSuperview()
            let finalCenter = CGPointMake(t.tableView.center.x + t.tableView.frame.width, t.tableView.center.y)
            t.tableView.center = finalCenter
        }
    }
    */
    func filterMe() {

        let schedule = pageViewControllers[0] as! SchedulerTableViewController
        schedule.tableView.reloadData()
        
        
        if constH != nil  {
            pageViewControllers[0].view.removeConstraints(constH)
        }
        
        
        if schedule.areFilterOpened {

            //view.removeConstraints(constH)
            
            
            //view.addSubview(t)
           
            t.devoxxAppFilterDelegate = self
            
            
            
            let schedule = pageViewControllers[0] as! SchedulerTableViewController
            let views = ["pageView": schedule.tableView, "filterView" : t.tableView]
            
            
            
            
            
            constH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[pageView]-0-[filterView(150)]-0-|", options: [], metrics: nil, views: views)
            
        }
        else {
            let schedule = pageViewControllers[0] as! SchedulerTableViewController
            let views = ["pageView": schedule.tableView, "filterView" : t.tableView]
            
            

            
            
            constH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[pageView]-0-|", options: [], metrics: nil, views: views)
            
          
            
            
          
        }
        
        pageViewControllers[0].view.addConstraints(constH)
        schedule.areFilterOpened = !schedule.areFilterOpened
        
    }
    
    override public func viewDidLoad() {
        seg = UISegmentedControl(frame: CGRectMake(0, 0, 200, 30))
        seg.insertSegmentWithTitle("Schedule", atIndex: 0, animated: true)
        seg.insertSegmentWithTitle("My schedule", atIndex: 1, animated: true)
        seg.selectedSegmentIndex = 0
        seg.tintColor = UIColor.whiteColor()
        seg.addTarget(self, action: Selector("changeSchedule:"), forControlEvents: .ValueChanged)
        
        
        
        
        
        view.addSubview(t)
        //t.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        configure()
        
        
        
        //t.delegate = self
        
        
        
        
        
        
        
    }
    
    
    public override func viewWillAppear(animated: Bool) {
        
        
        view.tag = 0
        
        
        let filterRightButton = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: Selector("filterMe"))
        

        self.topViewController?.navigationItem.rightBarButtonItem = filterRightButton
        self.topViewController?.navigationItem.titleView = seg
        
        
        
        
        
    }
    
    
    public func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        if pageViewController.viewControllers?.count == 0 {
            return 0
        }
        
        if let pvc = pageViewControllers[0] as? UIViewController {
            return pvc.view.tag
        }
        return 0
        
    }
    
    
    public func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 3
    }
    
    public func configure() {
        buildConc(0)
        initPageViewController()
    }
    
    public func buildConc(index : Int) -> UIViewController {
        let childViewController = SchedulerTableViewController()
    
        
        
        //let nc = UINavigationController(rootViewController: childViewController)
        childViewController.view.tag = index
        childViewController.title = "Day \(index+1)"
        pageViewControllers = [childViewController]
        pageView?.addChildViewController(childViewController)
    
        
        childViewController.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        pageViewControllers[0].view.addSubview(t.tableView)
        let schedule = pageViewControllers[0] as! SchedulerTableViewController
        let views = ["pageView": schedule.tableView, "filterView" : t.tableView]
        
        t.tableView.translatesAutoresizingMaskIntoConstraints = false
        t.translatesAutoresizingMaskIntoConstraints = false
        schedule.tableView.translatesAutoresizingMaskIntoConstraints = false

        
        
        
        let constV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[pageView]-|", options: .AlignAllCenterX, metrics: nil, views: views)
        let constV2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[filterView]-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        pageViewControllers[0].view.addConstraints(constV)
        pageViewControllers[0].view.addConstraints(constV2)

        
        filterMe()
  
    
        return childViewController
    }
    
    
    
    public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = viewController.view.tag as Int
        if(index == NSNotFound) {
            return nil
        }
        index++
        if (index == 5) {
            return nil
        }
        return viewControllerAtIndex(index)
    }
    
    public func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = viewController.view.tag as Int
        if(index == 0  || index == NSNotFound) {
            return nil
        }
        index--
        
        return viewControllerAtIndex(index)
    }
    
    public func viewControllerAtIndex(index : NSInteger) -> UIViewController {
        /*let childViewController = SchedulerTableViewController()
        childViewController.title = "OK \(index)"
        childViewController.delegate = self
        childViewController.view.tag = index
        
        print("set current in viewControllerAtIndex \(index)")
        let nc = UINavigationController(rootViewController: childViewController)
        pageView?.addChildViewController(nc)
        return nc*/
        
        return buildConc(index)
        
    }
    
    
 
    
    public func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if(!completed) {
            return
        }
        //let aa = pageViewController.viewControllers![0] as! SchedulerTableViewController
        //print(aa.view.tag)
    }
    
    public func isMySheduleSelected() -> Bool {
        return false
        //return (seg.selectedSegmentIndex == 1)
    }
    
    public func getNavigationController() -> UINavigationController? {
        return navigationController
    }
    
    public override func viewDidLayoutSubviews() {
     /*   let views = ["pageView": pageView!.view]
        heightConstant = self.navigationController!.navigationBar.frame.size.height + self.navigationController!.navigationBar.frame.origin.y
        view.removeConstraints(constW)
        constW = NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(heightConstant)-[pageView]-\(self.tabBarController!.tabBar.frame.height)-|", options: .AlignAllTrailing, metrics: nil, views: views)
        view.addConstraints(constW)
        */
        
    }
    
    
    
    func filter(filterName : [String: [Attribute]]) -> Void {


        
        let aa = pageView!.viewControllers![0] as! SchedulerTableViewController
        
        aa.searchPredicates.removeAll()
        
        for key in filterName.keys {
            
            aa.searchPredicates[key] = [NSPredicate]()
            
            for attribute in filterName[key]! {
                let predicate = NSPredicate(format: "\(attribute.filterPredicateLeftValue()) = %@", attribute.filterPredicateRightValue())
                aa.searchPredicates[key]?.append(predicate)
            }
            
        }
        
        aa.fetchAll()

    }
    
    func changeSchedule(sender : UISegmentedControl) {
        let aa = pageView!.viewControllers![0] as! SchedulerTableViewController
        aa.isFavorite = sender.selectedSegmentIndex == 1
        aa.fetchAll()
    }
    
    public override func prefersStatusBarHidden() -> Bool {
        return true
    }*/
}
