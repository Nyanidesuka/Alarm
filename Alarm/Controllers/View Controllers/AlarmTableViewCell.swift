//
//  AlarmTableViewCell.swift
//  Alarm
//
//  Created by Haley Jones on 5/6/19.
//  Copyright © 2019 HaleyJones. All rights reserved.
//

import UIKit

protocol AlarmTableViewCellDelegate: class{
    func switchCellSwitchValueChanged(cell: AlarmTableViewCell)
}

class AlarmTableViewCell: UITableViewCell {

    //MARK: Outlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var toggleSwitch: UISwitch!
    
    var alarm: Alarm?{
        didSet{
            updateViews()
        }
    }
    
    weak var delegate: AlarmTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateViews(){
        timeLabel.text = alarm?.fireTimeAsString
        nameLabel.text = alarm?.name
        guard let switchIsOn = alarm?.enabled else {return}
        toggleSwitch.isOn = switchIsOn
    }
    
    //MARK: IB Actions
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        guard let boss = delegate else {return}
        boss.switchCellSwitchValueChanged(cell: self)
    }
}
