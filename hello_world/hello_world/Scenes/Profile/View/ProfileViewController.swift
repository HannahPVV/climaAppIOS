//
//  ProfileViewController.swift
//  hello_world
//
//  Created by Hannah Valencia on 27/03/26.
//

import UIKit
import AVKit
import AVFoundation

class ProfileViewController: UIViewController {
    
    var player: AVPlayer? //Reproductor de música
    
    @IBOutlet weak var image: UIImageView!
    
    
    //MARK: - DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let helpButton = UIBarButtonItem(title: "Help", style: .plain, target: self, action: #selector(didTapHelp))
        
        let audioButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(didTapAudio))
        audioButton.tintColor = .green
        
        let stopButton = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(didTapStop))
        stopButton.tintColor = .red
        
        navigationItem.setRightBarButtonItems([helpButton], animated: false)
        navigationItem.setLeftBarButtonItems( [stopButton, audioButton], animated: false)
        
    }
    
    //Desapaerzca el audio después de que se quite
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        didTapStop()
    }
    
    @objc func didTapHelp() {
        let videoURLString = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
        guard let videoURL = URL(string: videoURLString) else {
            print("Invalid video URL")
            return
        }
        
        let player = AVPlayer(url: videoURL)
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        //guard let navigation = navigationController else { return }
        
        present(playerViewController, animated: true)
        
        
    }
    
    @objc func didTapAudio() {
        let audioURLString = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"
        
        guard let audioURL = URL(string: audioURLString)else{
            print("Invalid URL")
            return
        }
        do{
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            self.player = AVPlayer(url:audioURL)
            
            guard let player = self.player else{
                print("Player is nil")
                return
            }
            player.play()
            
        }
        
        catch{
            print(error.localizedDescription)
        }
    
    }
    
    @objc func didTapStop() {
        guard let player = self.player else{
            print("Player is nil")
            return
        }
        player.play()
        self.player = nil
        
    }
    
    @IBAction func photTapped(){
        let alert = UIAlertController(title: "Select image from:", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "camera", style: .default)
        {(action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let vc = UIImagePickerController()
                vc.sourceType = .camera
                vc.allowsEditing = true
                vc.delegate = self
                self.present(vc, animated: true)
            }
            
        }
        
        let fototecaAction = UIAlertAction(title: "Photo library", style: .default)
        {(action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let vc = UIImagePickerController()
                vc.sourceType = .photoLibrary
                vc.allowsEditing = true
                vc.delegate = self
                self.present(vc, animated: true)
            }
            
        }
        
        alert.addAction(cameraAction)
        alert.addAction(fototecaAction)
        
        present(alert, animated: true)
        
    }
}

// MARK: -
extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { //diccionario de valor para la llave
        picker.dismiss(animated: true)
        
        //validar que sea una imagen
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        self.image.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
