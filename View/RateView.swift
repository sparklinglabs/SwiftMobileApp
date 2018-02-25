//
//  RateView.swift
//  devoxxApp
//
//  Created by maxday on 07.03.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit



class RateView : UITableViewCell {
    
    
    let label = UILabel()
    let review = UITextField()
    var key : String?
    
    var delegate : RatingDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(label)
        addSubview(review)
        
        
        label.translatesAutoresizingMaskIntoConstraints = false
        review.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["label": label, "review" : review] as [String : Any]
        
        
        let constH0 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[label(150)]-10-[review]-0-|", options: .alignAllLastBaseline, metrics: nil, views: views)
        
        let constV0 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[label]-0-|", options: .alignAllCenterX, metrics: nil, views: views)
        
        let constV1 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[review]-0-|", options: .alignAllCenterX, metrics: nil, views: views)
        
        addConstraints(constH0)
        addConstraints(constV0)
        addConstraints(constV1)
        
        
        label.font = UIFont(name: "Roboto", size: 17)
        label.textAlignment = .right
        label.textColor = ColorManager.grayImageColor
        review.font = UIFont(name: "Roboto", size: 17)
 
       
        review.addTarget(self, action: #selector(RateView.textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
   

    
    func textFieldDidChange(_ textView: UITextField) {
        delegate?.updateReview(key, review: textView.text!)
    }
    
    
    func updateBackgroundColor(_ isFavorited : Bool) {
        if(isFavorited) {
            backgroundColor = ColorManager.favoriteBackgroundColor
        }
        else {
            backgroundColor = UIColor.white
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
        
        
        
    }
    
    
    
    
}
