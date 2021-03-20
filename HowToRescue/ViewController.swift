//
//  ViewController.swift
//  HowToRescue
//
//  Created by TakahashiTsubasa on 2021/03/18.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var captureView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rescueBarView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("コミットテスト")
        rescueBarView.backgroundColor = UIColor(red: 160 / 255, green: 51 / 255, blue: 34 / 255, alpha: 1)
    }
    
    @IBAction func tapSelectImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true)
    }
    
    @IBAction func tapSave(_ sender: Any) {
        //viewを合成して画像を生成
        UIGraphicsBeginImageContextWithOptions(captureView.frame.size, false, 1)
        captureView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let rescuedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let image = rescuedImage else { return }
        //カメラロールに保存
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(didFinishSaving(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func didFinishSaving(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeMutableRawPointer) {
        //保存状況をアラートで表示
        if error != nil {
            showAlert(title: "失敗", message: "画像の保存に失敗しました")
        } else {
            showAlert(title: "成功", message: "画像を保存しました")
        }
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            imageView.image = image
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}

