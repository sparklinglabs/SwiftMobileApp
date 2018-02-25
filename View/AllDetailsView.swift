//
//  AllDetailsView.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-24.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

class AllDetailsView : UIView {
    
    
    let simpleDetailView1 = SimpleDetailView()
    let simpleDetailView2 = SimpleDetailView()
    let simpleDetailView3 = SimpleDetailView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //backgroundColor = UIColor.purpleColor()
        
        
        
        
        
        
        
        
        //simpleDetailView1.backgroundColor = UIColor.greenColor()
        simpleDetailView1.translatesAutoresizingMaskIntoConstraints = false
        simpleDetailView1.iconView.image = UIImage(named: "ic_place.png")?.withRenderingMode(.alwaysTemplate)
        addSubview(simpleDetailView1)
        
        
        simpleDetailView2.translatesAutoresizingMaskIntoConstraints = false
        //simpleDetailView2.backgroundColor = UIColor.blueColor()
        simpleDetailView2.iconView.image = UIImage(named: "ic_microphone.png")?.withRenderingMode(.alwaysTemplate)
        addSubview(simpleDetailView2)
        
        
        simpleDetailView3.translatesAutoresizingMaskIntoConstraints = false
        //simpleDetailView3.backgroundColor = UIColor.redColor()
        simpleDetailView3.iconView.image = UIImage(named: "ic_star.png")?.withRenderingMode(.alwaysTemplate)
        addSubview(simpleDetailView3)
        
        
        
        
        let views = ["simpleDetailView1": simpleDetailView1, "simpleDetailView2" : simpleDetailView2, "simpleDetailView3" : simpleDetailView3]
        
        
        let height = NSLayoutConstraint(item: simpleDetailView1,
            attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.height,
            multiplier: 0.33,
            constant: 0)
        
        addConstraint(height)
        
        //view 2
        
        
        
        let height2 = NSLayoutConstraint(item: simpleDetailView2,
            attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.height,
            multiplier: 0.33,
            constant: 0)
        
        
        
        addConstraint(height2)
        
        //view 3
        
        
        
        let height3 = NSLayoutConstraint(item: simpleDetailView3,
            attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.height,
            multiplier: 0.34,
            constant: 0)
        
        
        addConstraint(height3)
        
        
        
        
        
        let constH1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[simpleDetailView1]-0-|", options: .alignAllLastBaseline, metrics: nil, views: views)
        let constH2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[simpleDetailView2]-0-|", options: .alignAllLastBaseline, metrics: nil, views: views)
        let constH3 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[simpleDetailView3]-0-|", options: .alignAllLastBaseline, metrics: nil, views: views)
        
        let constV = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[simpleDetailView1]-0-[simpleDetailView2]-0-[simpleDetailView3]-0-|", options: .alignAllCenterX, metrics: nil, views: views)
        
        
        addConstraints(constH1)
        addConstraints(constH2)
        addConstraints(constH3)
        
        addConstraints(constV)
        
        
        
        /*
        simpleDetailView1.backgroundColor = UIColor.redColor()
        simpleDetailView2.backgroundColor = UIColor.yellowColor()
        simpleDetailView3.backgroundColor = UIColor.purpleColor()
        */
        
        
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
