//
//  SelectionViewController.swift
//  gen_z_final_project
//
//  Created by Jake Lehmann on 11/11/16.
//  Copyright © 2016 Jake Lehmann, Abrahamn Musalem, And Yang, Dingyu Wang. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate{

    var galleryItems : [GalleryItem] = []
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var enterName: UITextField!
    @IBOutlet weak var playButton: CustomButtonView!
    
    var imageName: String!
    
    var shipSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initGalleryItems()
        self.enterName.delegate = self
        checkValidPlayButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: Selected Cells
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)!
        cell.backgroundColor = UIColor(red: 0, green: 0, blue: 110/255, alpha: 1)
        shipSelected = true
        checkValidPlayButton()
        imageName = galleryItems[indexPath.row].itemImage
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)!
        cell.backgroundColor = UIColor.black
    }
    
    
    //MARK: CollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as! GalleryCell
        cell.setGalleryItem(galleryItems[indexPath.row])
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.green.cgColor
        return cell
    }

    // MARK: CellectionViewFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let picWidth = self.view.frame.size.width / 3.0
        let picHieght = self.view.frame.size.width / 3.0
        return CGSize(width: picWidth, height: picHieght)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let leftRightInset = self.view.frame.size.width / 14
        return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        let commentView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ReusableViewHeader", for: indexPath) 
        return commentView
    }
    
    //MARK: unwind
    
    @IBAction func unwindToSelectionView(for unwindSegue: UIStoryboardSegue) {
        
    }
    
    fileprivate func initGalleryItems() {
        
        var items = [GalleryItem]()
        let inputFile = Bundle.main.path(forResource: "items", ofType: "plist")
        let inputDataArray = NSArray(contentsOfFile: inputFile!)
        
        for inputItem in inputDataArray as! [Dictionary<String, String>] {
            let galleryItem = GalleryItem(dataDictionary: inputItem)
            items.append(galleryItem)
        }
        
        galleryItems = items
    }

    
    //MARK: textfielddelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkValidPlayButton()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        playButton.isEnabled = false
    }
    
    func checkValidPlayButton() {
        // Disable the Save button if the text field is empty.
        let text = enterName.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        playButton.isEnabled = !text!.isEmpty && shipSelected
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "gamePlaySegue"{
            let destinationVC : GamePlayViewController = segue.destination as! GamePlayViewController
            destinationVC.shipImage = imageName
            destinationVC.playerName = enterName.text
        }
        
    }
}
