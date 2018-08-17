//
//  RoundedButtonView.swift
//  DropBoxer
//
//  Created by Zack Falgout on 8/16/18.
//  Copyright © 2018 Zack Falgout. All rights reserved.
//

import UIKit

class RoundedButtonView: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Round the edges so it forms a pill.
        layer.cornerRadius = frame.height / 2
        layer.borderWidth = 2 / UIScreen.main.nativeScale
        layer.borderColor = UIColor.white.cgColor
    }
    
}
