//
//  ViewController.swift
//  CelebrityLookAlikeDemo
//
//  Created by John Henning on 1/11/18.
//  Copyright © 2018 Knock. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var lookAlikeTableView: UITableView!
    
    var imageSearch: ImageSearch?
    var sightEngineClient: SightEngineClient?
    
    var celebrityList: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageSearch = ImageSearch.shared
        sightEngineClient = SightEngineClient.shared
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func findCelebrityLookAlikes() {
        sightEngineClient?.checkImage(image: imageView.image!, check: .celebrities) { response in
            
            if let error = response as? Error {
                print(error.localizedDescription)
            } else {
                let json = response as! [String: Any]
                if let error = json["error"] as? [String:Any] {
                    print(error["message"]!)
                    return
                }
                let faces = json["faces"] as? [[String:Any]]
                let celebrities = faces![0]["celebrity"] as? [[String:Any]]
                self.celebrityList = [String]()
                
                for celebrity in celebrities! {
                    self.celebrityList?.append((celebrity["name"] as? String)!)
                }
            }

        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBAction func onCameraPress(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func onPhotoLibraryPress(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        findCelebrityLookAlikes()
        lookAlikeTableView.reloadData()
        dismiss(animated:true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (celebrityList?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}

