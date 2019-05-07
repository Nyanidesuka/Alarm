//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by Haley Jones on 5/6/19.
//  Copyright © 2019 HaleyJones. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {

    //MARK: Outlets
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var enableDisableButton: UIButton!
    
    var alarm: Alarm?{
        didSet{
            loadView()
            updateViews()
        }
    }
    
    var alarmIsOn: Bool {
        get{
            guard let targetAlarm = alarm else {return false}
            return targetAlarm.enabled
        }
        set{
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func updateViews(){
        guard let updateAlarm = alarm else {return}
        guard isViewLoaded == true else {return}
        print("alarm is not nil")
        print(updateAlarm.name)
        print(updateAlarm.enabled)
        enableDisableButton.setTitle(updateAlarm.enabled ? "Enabled" : "Disabled", for: .normal)
        enableDisableButton.backgroundColor = updateAlarm.enabled ? UIColor.green : UIColor.red
        alarmIsOn = updateAlarm.enabled
        datePicker.date = updateAlarm.fireDate
        nameTextField.text = updateAlarm.name
    }

    // MARK: - Table view data source
    //dont need those

    //MARK: IBActions
    @IBAction func enableButtonPressed(_ sender: UIButton) {
        if let targetAlarm = alarm{
            AlarmController.shared.toggleEnabled(forAlarm: targetAlarm)
        }
        updateViews()
    }
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if let saveAlarm = alarm{
            AlarmController.shared.update(alarm: saveAlarm, fireDate: datePicker.date, name: nameTextField.text ?? "", enabled: alarmIsOn)
            if alarmIsOn {AlarmController.shared.scheduleUserNotifications(forAlarm: saveAlarm)}
        } else{
            let newAlarm = AlarmController.shared.addAlarm(fireDate: datePicker.date, name: nameTextField.text ?? "", enabled: true)
            if alarmIsOn {AlarmController.shared.scheduleUserNotifications(forAlarm: newAlarm)}
        }
        navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
