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
    @IBOutlet weak var rescueBarViewWidth: NSLayoutConstraint!
    @IBOutlet weak var rescueBarViewCenterX: NSLayoutConstraint!
    @IBOutlet weak var rescueBarViewWidthSlider: UISlider!
    @IBOutlet weak var rescueBarViewCenterXSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rescueBarView.backgroundColor = UIColor(red: 160 / 255, green: 51 / 255, blue: 34 / 255, alpha: 1)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showColorPicker))
        rescueBarView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let movableRangeX = Float(captureView.bounds.width - rescueBarView.center.x - rescueBarView.bounds.width)
        rescueBarViewCenterXSlider.maximumValue = movableRangeX
        rescueBarViewCenterXSlider.minimumValue = -movableRangeX
        rescueBarViewCenterXSlider.value = 0
        
        let maximumWidth = Float(captureView.frame.width - rescueBarView.frame.width)
        rescueBarViewWidthSlider.maximumValue = maximumWidth
        rescueBarViewWidthSlider.minimumValue = 0
        rescueBarViewWidthSlider.value = Float(rescueBarView.frame.width)
    }
    
    @IBAction private func tapSelectImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true)
    }
    
    @objc private func showColorPicker(){
        let colorPicker = UIColorPickerViewController()
        colorPicker.selectedColor = UIColor.black // 初期カラー
        colorPicker.delegate = self
        colorPicker.supportsAlpha = false
        self.present(colorPicker, animated: true, completion: nil)
    }
    
    @IBAction private func didChangeRescueBarCenterX(_ sender: UISlider) {
        rescueBarViewCenterX.constant = CGFloat(sender.value)
    }
    
    @IBAction func didChangeRescueBarWidth(_ sender: UISlider) {
        rescueBarViewWidth.constant = CGFloat(sender.value)
    }
    
    @IBAction private func tapSave(_ sender: Any) {
        //viewを合成して画像を生成
        UIGraphicsBeginImageContextWithOptions(captureView.frame.size, false, 0)
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

extension ViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        rescueBarView.backgroundColor = viewController.selectedColor
    }
}

