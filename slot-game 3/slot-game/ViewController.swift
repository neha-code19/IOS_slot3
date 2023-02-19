//
//  ViewController.swift
//  slot-game
//
//  Created by
//  Sriskandarajah Sayanthan  301279325.
//  Neha Patel  301280513
//  Rutvik Lathiya 301282022
import UIKit
import CoreData


class ViewController: UIViewController {

   
    
    @IBOutlet weak var labelResult: UILabel!
    @IBOutlet weak var pickerView : UIPickerView!
    @IBOutlet weak var buttonSpin : UIButton!
    @IBOutlet weak var reset: UIButton!
    
    @IBOutlet weak var Quit: UIButton!
   
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var dicreases: UILabel!
    
    @IBOutlet weak var increases: UILabel!
    
    var bounds    = CGRect.zero
    var dataArray = [[Int](), [Int](), [Int]()]
    var winSound  = SoundManager()
    var rattle    = SoundManager()
    var stepValue:Int = 10
    var decultValue:Int = 500
    var amount = 0
    
    var winFlag: Bool = false
    var names: String = ""
   
    var userData: [NSManagedObject] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
       
        
        dicreases.text = "\(decultValue)"+"$"
        increases.text = "\(stepValue)"+"$"
        pickerView.delegate   = self
        pickerView.dataSource = self
        loadData()
        setupUIAndSound()
        spinSlots()
    }
    
    func loadPopView(){
        let alert = UIAlertController(title: "New Name",
                                       message: "Add a new name",
                                       preferredStyle: .alert)
         
         let saveAction = UIAlertAction(title: "Save",
                                        style: .default) {
           [unowned self] action in
                                         
           guard let textField = alert.textFields?.first,
             let nameToSave = textField.text else {
               return
           }
           names = nameToSave
            
             self.save(name: names, value: (decultValue))
         }
         
//         let cancelAction = UIAlertAction(title: "Cancel",
//                                          style: .cancel)
         
         alert.addTextField()
         
         alert.addAction(saveAction)
//         alert.addAction(cancelAction)
         
         present(alert, animated: true)
    }
    
    
    func save(name: String,value:Int) {
      
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      
      // 1
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      // 2
      let entity =
        NSEntityDescription.entity(forEntityName: "Entity",
                                   in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      // 3
      person.setValue(name, forKeyPath: "name")
      person.setValue(value, forKeyPath: "value")
      
      // 4
      do {
        try managedContext.save()
        userData.append(person)
//          print(userData)
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
    
    func loadData() {
        for i in 0...2 {
            for _ in 0...100 {
                dataArray[i].append(Int.random(in: 0...K.imageArray.count - 1))
            }
        }
    }
    
    
    
    func setupUIAndSound() {
        // SOUND
        winSound.setupPlayer(soundName: K.sound, soundType: SoundType.m4a)
        rattle.setupPlayer(soundName: K.rattle, soundType: .m4a)
        winSound.volume(1.0)
        rattle.volume(0.1)
        buttonSpin.alpha = 0
        
        // UI
        bounds = buttonSpin.bounds
        bounds = reset.bounds
        bounds = Quit.bounds
        
        setTrim()
        labelResult.layer.cornerRadius  = 10
        labelResult.layer.masksToBounds = true
        pickerView.layer.cornerRadius   = 10
        buttonSpin.layer.cornerRadius   = 10
        reset.layer.cornerRadius   = 10
        Quit.layer.cornerRadius   = 10
    }
    
    func setTrim () {
        labelResult.layer.borderColor = UIColor.label.cgColor
        pickerView.layer.borderColor  = UIColor.label.cgColor
        buttonSpin.layer.borderColor  = UIColor.label.cgColor
        reset.layer.borderColor  = UIColor.label.cgColor
        Quit.layer.borderColor  = UIColor.label.cgColor
        
        labelResult.layer.borderWidth = 2
        pickerView.layer.borderWidth  = 2
        buttonSpin.layer.borderWidth  = 2
        reset.layer.borderWidth  = 2
        Quit.layer.borderWidth  = 2
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle else { return }
        setTrim()
    }
    
    
    func spinSlots() {
        for i in 0...2 {
            pickerView.selectRow(Int.random(in: 3...97), inComponent: i, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration : 0.5,
                       delay        : 0.3,
                       options      : .curveEaseOut,
                       animations   : { self.buttonSpin.alpha = 1 },
                       completion   : nil)
        
    }

    @IBAction func reset(_ sender: Any) {
        stepper.value = 1
        decultValue = 200
        dicreases.text = "\(Int(200))"+"$"
        increases.text = "\(Int(10))"+"$"
    }
    @IBAction func exit(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
             
        }
               
    }
    
    @IBAction func stepperAction(_ sender: UIStepper) {

        if (sender.value*10 <= 0){
            
        }else{
            stepValue = Int(sender.value*10)
            increases.text = "\(Int(sender.value*10).description)"+"$"
//            dicreases.text = "\(500 - Int(sender.value*10))"+"$"
        }
        
    }
    @IBAction func spin(_ sender: AnyObject) {
        winSound.pause()
        rattle.play()
        spinSlots()
       
        checkWinOrLose()
        animateButton()
    }
   

    
    
    
    
    
    func checkWinOrLose() {
        let emoji0 = pickerView.selectedRow(inComponent: 0)
        let emoji1 = pickerView.selectedRow(inComponent: 1)
        let emoji2 = pickerView.selectedRow(inComponent: 2)

        if (dataArray[0][emoji0] == dataArray[1][emoji1]
         && dataArray[1][emoji1] == dataArray[2][emoji2]) {
            labelResult.text = K.win
            winSound.play()
          decultValue = (decultValue)+(stepValue)
            
            dicreases.text = "\(decultValue)"+"$"
            loadPopView()
            
            
        } else {
            decultValue = decultValue - stepValue
            if(decultValue <= 0){
                decultValue = 0
            }
//            print("=======\( decultValue)")
            
            dicreases.text = "\(decultValue)"+"$"
            labelResult.text = K.lose
            
        }
    }

    
    func animateButton(){
        // animate button
        let shrinkSize = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width - 15, height: bounds.size.height)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 5,
                       options: .curveLinear,
                       animations: { self.buttonSpin.bounds = shrinkSize },
                       completion: nil )
    }
} // end of View Controller


// MARK:UIPickerViewDataSource
extension ViewController : UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
}

// MARK:UIPickerViewDelegate
extension ViewController: UIPickerViewDataSource {
    
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 80.0
    }
    
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 120.0
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerLabel = UILabel()
        
        switch component {
            case 0 : pickerLabel.text = K.imageArray[(Int)(dataArray[0][row])]
            case 1 : pickerLabel.text = K.imageArray[(Int)(dataArray[1][row])]
            case 2 : pickerLabel.text = K.imageArray[(Int)(dataArray[2][row])]
            default : print("done")
        }
        
        pickerLabel.font          = UIFont(name : K.emojiFont, size : 75)
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
}


