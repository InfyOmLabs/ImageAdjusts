//
//  AdjustEditorView.swift
//  Flippy
//
//  Created by Infyom on 05/08/17.
//  Copyright © 2017 Infyom. All rights reserved.
//

import UIKit

class ImageAdjustView : UIView, UIGestureRecognizerDelegate {
    
    @IBOutlet var screenSortView: UIView!
    @IBOutlet var mainView: UIView!
    @IBOutlet var sliderView: UIView!
    
    @IBOutlet var backImageView: UIImageView!
    @IBOutlet var colorImageView: UIImageView!
    @IBOutlet var layoutStackView: UIStackView!
    
    @IBOutlet var effectSlider: UISlider!
    
    var selectedShade : Shades?
    var viewFrame : CGRect!
    
    var mainImage : UIImage!
    var tempImage : UIImage!
    
    var selectSaveImageCallback : ((UIImage) -> Void)?
    var selectCancleImageCallback : ((Bool) -> Void)?
    
    var brightnessValue : CGFloat = 0
    var saturationVlue : CGFloat = 1.0
    var contrastValue : CGFloat = 1.0
    var sharpnessValue : CGFloat = 0.40
    var warmthValue : CGFloat = 157.67
    var exposureValue : CGFloat = 0.50
    var highlightValue : CGFloat = 1.0
    var shadowsValue : CGFloat = 0.0
    var vibranceValue : CGFloat = 0.0
    var tintValue : CGFloat = 1.0
    var fadeValue : CGFloat = 0.0
    
    var shadesArray = [Shades.Brightness, Shades.Saturation, Shades.Contrast, Shades.Sharpness, Shades.Warmth, Shades.Exposure, Shades.Vibrance, Shades.Highlights, Shades.Shadows, Shades.Tint, Shades.Fade]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.sliderView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        self.addGestures()
    }
    
    static func create(image : UIImage) -> ImageAdjustView {
        let selectView =  Bundle.main.loadNibNamed("ImageAdjustView", owner: self, options: nil)?[0] as! ImageAdjustView
        let window = UIApplication.shared.keyWindow
        if #available(iOS 11.0, *) {
            let topPadding = window?.safeAreaInsets.top
            let bottomPadding = window?.safeAreaInsets.bottom
            selectView.viewFrame = CGRect(x: 0, y: topPadding!, width: getScreenWidth(), height:
                getScreenHeight() - (topPadding! + bottomPadding!))
        } else {
            selectView.viewFrame = CGRect(x: 0, y: 0, width: getScreenWidth(), height: getScreenHeight())
        }
        selectView.mainImage = image
        selectView.didInit()
        
        if #available(iOS 11.0, *) {
            let topPadding = window?.safeAreaInsets.top
            let bottomPadding = window?.safeAreaInsets.bottom
            selectView.frame = CGRect(x: 0, y: getScreenHeight(), width: getScreenWidth(), height: getScreenHeight() - (topPadding! + bottomPadding!))
        } else {
            selectView.frame = CGRect(x: 0, y: getScreenHeight(), width: getScreenWidth(), height: getScreenHeight())
        }
        
        window!.addSubview(selectView)
        UIView.animate(withDuration: 0.35) {
            if #available(iOS 11.0, *) {
                let topPadding = window?.safeAreaInsets.top
                let bottomPadding = window?.safeAreaInsets.bottom
                selectView.frame = CGRect(x: 0, y: topPadding!, width: getScreenWidth(), height:
                    getScreenHeight() - (topPadding! + bottomPadding!))
            } else {
                selectView.frame = CGRect(x: 0, y: 0, width: getScreenWidth(), height: getScreenHeight())
            }
            selectView.setAllData()
        }
        return selectView
    }
    
    func didInit() {
        self.frame = self.viewFrame
    }
    
    func addGestures() {
        let taptouchGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGesture))
        taptouchGesture.minimumPressDuration = 0.0
        taptouchGesture.delegate = self
        self.backImageView.addGestureRecognizer(taptouchGesture)
    }
    
    @objc func longPressGesture(pinchGesture: UILongPressGestureRecognizer) {
        if(pinchGesture.state == .began) {
            self.colorImageView.isHidden = false
        }
        if (pinchGesture.state == .changed) {
            self.colorImageView.isHidden = false
        }
        if pinchGesture.state == .ended {
            self.colorImageView.isHidden = true
        }
    }
    
    func setAllData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400)) {
            UIView.animate(withDuration: 0.35, animations:  {
                self.backImageView.image = self.mainImage
                self.tempImage = self.mainImage
                print(self.mainView.frame)
                print(self.mainView.bounds)
                let frame = self.getSize(imageSize : self.mainImage.size , frameSize: self.mainView.frame.size)
                print(frame)
                self.screenSortView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
                self.screenSortView.center = CGPoint(x : self.mainView.getWidth / 2 , y: self.mainView.getHeight / 2)
                self.backImageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
                self.colorImageView.frame = CGRect(x: 0, y: 0, width: frame.width  , height: frame.height)
                self.colorImageView.image = self.mainImage
            }, completion: { finished in
                self.setEffecList()
            })
        }
    }
    
    func setEffecList() {
        UIView.animate(withDuration: 0.35, animations: {
            var count = -1
            for layoutData in self.shadesArray {
                count += 1
                let layoutView = AdjustImageView.create(frame : CGRect(x: 0, y: 0, width: self.layoutStackView.getHeight , height: self.layoutStackView.getHeight), effectCase: layoutData)
                layoutView.tag = count
                layoutView.frame = CGRect(x: 0, y: 0, width: self.layoutStackView.getHeight , height: self.layoutStackView.getHeight)
                layoutView.selectEffectCallback = { effect in
                    self.setSlider(effecName : effect)
                }
                self.layoutStackView.addArrangedSubview(layoutView)
                layoutView.setLayoutView()
            }
        }, completion: { finished in
        })
    }
    
    func getSize(imageSize: CGSize, frameSize: CGSize) -> CGSize {
        if imageSize.width >= frameSize.width{
            let newWidth = frameSize.width / imageSize.width
            let newSize = CGSize(width: imageSize.width * newWidth , height: imageSize.height * newWidth)
            if newSize.height >= frameSize.height{
                let newHeight = frameSize.height / newSize.height
                return CGSize(width: newSize.width * newHeight , height: newSize.height * newHeight)
            }else{
                return newSize
            }
        } else {
            let newHeight = frameSize.height / imageSize.height
            let newSize = CGSize(width: imageSize.width * newHeight , height: imageSize.height * newHeight)
            if newSize.width >= frameSize.width {
                let newWidth = frameSize.width / newSize.width
                return CGSize(width: newSize.width * newWidth , height: newSize.height * newWidth)
            }else{
                return newSize
            }
        }
    }
    
    func setSliderValue(float: Float) {
        if self.selectedShade == .Brightness {
            let ciContext = CIContext(options: nil)
            brightnessValue = CGFloat(float)
            print(float)
            
            var coreImage = CIImage()
            if mainImage.cgImage != nil{
                coreImage = CIImage(cgImage: mainImage.cgImage!)
            } else {
                coreImage = mainImage.ciImage!
            }
            
            let filter = CIFilter(name: "CIColorControls")
            filter?.setValue(float, forKey: kCIInputBrightnessKey)
            filter?.setValue(coreImage, forKey: kCIInputImageKey)
            
            if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
                let cgimgresult = ciContext.createCGImage(output, from: output.extent)
                self.backImageView.image = UIImage(cgImage: cgimgresult!)
            } else {
                print("image filtering failed")
            }
        }
        
        if self.selectedShade == .Saturation {
            let ciContext = CIContext(options: nil)
            saturationVlue = CGFloat(float)
            print(float)
            var coreImage = CIImage()
            if mainImage.cgImage != nil{
                coreImage = CIImage(cgImage: mainImage.cgImage!)
            } else {
                coreImage = mainImage.ciImage!
            }
            
            let filter = CIFilter(name: "CIColorControls")
            filter?.setValue(float, forKey: kCIInputSaturationKey)
            filter?.setValue(coreImage, forKey: kCIInputImageKey)
            
            if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
                let cgimgresult = ciContext.createCGImage(output, from: output.extent)
                self.backImageView.image = UIImage(cgImage: cgimgresult!)
            } else {
                print("image filtering failed")
            }
        }
        
        if self.selectedShade == .Contrast {
            let ciContext = CIContext(options: nil)
            contrastValue = CGFloat(float)
            print(float)
            
            var coreImage = CIImage()
            if mainImage.cgImage != nil{
                coreImage = CIImage(cgImage: mainImage.cgImage!)
            } else {
                coreImage = mainImage.ciImage!
            }
            
            let filter = CIFilter(name: "CIColorControls")
            filter?.setValue(float, forKey: kCIInputContrastKey)
            filter?.setValue(coreImage, forKey: kCIInputImageKey)
            
            if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage{
                let cgimgresult = ciContext.createCGImage(output, from: output.extent)
                self.backImageView.image = UIImage(cgImage: cgimgresult!)
            } else {
                print("image filtering failed")
            }
        }
        
        if self.selectedShade == .Sharpness {
            let ciContext = CIContext(options: nil)
            sharpnessValue = CGFloat(float)
            print(float)
            var coreImage = CIImage()
            
            if mainImage.cgImage != nil {
                coreImage = CIImage(cgImage: mainImage.cgImage!)
            } else {
                coreImage = mainImage.ciImage!
            }
            
            let filter = CIFilter(name: "CISharpenLuminance")
            filter?.setValue(float, forKey: kCIInputSharpnessKey)
            filter?.setValue(coreImage, forKey: kCIInputImageKey)
            
            if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage{
                let cgimgresult = ciContext.createCGImage(output, from: output.extent)
                self.backImageView.image = UIImage(cgImage: cgimgresult!)
            } else {
                print("image filtering failed")
            }
        }
        
        if self.selectedShade == .Warmth {
            let ciContext = CIContext(options: nil)
            warmthValue = CGFloat(float)
            print(float)
            
            var coreImage = CIImage()
            if mainImage.cgImage != nil {
                coreImage = CIImage(cgImage: mainImage.cgImage!)
            } else {
                coreImage = mainImage.ciImage!
            }
            
            var number = CGFloat(float)
            if number > 157.9 {
                let minus = 172 - number
                number = 165 + minus
            } else {
                let minus = 157.9 - number
                number = 130 + minus
            }
            
            let vector0 = CIVector(x: 4000, y: number)
            let vector1 = CIVector(x: 5000, y: number)
            
            let filter = CIFilter(name: "CITemperatureAndTint")
            filter?.setValue(coreImage, forKey: kCIInputImageKey)
            filter?.setValue(vector0, forKey: "inputNeutral")
            filter?.setValue(vector1, forKey: "inputTargetNeutral")
            
            if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
                let cgimgresult = ciContext.createCGImage(output, from: output.extent)
                self.backImageView.image = UIImage(cgImage: cgimgresult!)
            } else {
                print("image filtering failed")
            }
        }
        
        if self.selectedShade == .Exposure {
            let ciContext = CIContext(options: nil)
            exposureValue = CGFloat(float)
            print(float)
            
            var coreImage = CIImage()
            if mainImage.cgImage != nil {
                coreImage = CIImage(cgImage: mainImage.cgImage!)
            } else {
                coreImage = mainImage.ciImage!
            }
            
            let filter = CIFilter(name: "CIExposureAdjust")
            filter?.setValue(float, forKey: kCIInputEVKey)
            filter?.setValue(coreImage, forKey: kCIInputImageKey)
            
            if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
                let cgimgresult = ciContext.createCGImage(output, from: output.extent)
                self.backImageView.image = UIImage(cgImage: cgimgresult!)
            } else {
                print("image filtering failed")
            }
        }
        
        if self.selectedShade == .Vibrance {
            let ciContext = CIContext(options: nil)
            vibranceValue = CGFloat(float)
            print(float)
            var coreImage = CIImage()
            if mainImage.cgImage != nil {
                coreImage = CIImage(cgImage: mainImage.cgImage!)
            } else {
                coreImage = mainImage.ciImage!
            }
            
            let filter = CIFilter(name: "CIVibrance")
            filter?.setValue(float, forKey: "inputAmount")
            filter?.setValue(coreImage, forKey: kCIInputImageKey)
            
            if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
                let cgimgresult = ciContext.createCGImage(output, from: output.extent)
                self.backImageView.image = UIImage(cgImage: cgimgresult!)
            } else {
                print("image filtering failed")
            }
        }
        
        if self.selectedShade == .Highlights {
            let ciContext = CIContext(options: nil)
            highlightValue = CGFloat(float)
            print(float)
            
            var coreImage = CIImage()
            if mainImage.cgImage != nil {
                coreImage = CIImage(cgImage: mainImage.cgImage!)
            } else {
                coreImage = mainImage.ciImage!
            }
            
            let filter = CIFilter(name: "CIHighlightShadowAdjust")
            filter?.setValue(float, forKey: "inputHighlightAmount")
            filter?.setValue(coreImage, forKey: kCIInputImageKey)
            
            if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
                let cgimgresult = ciContext.createCGImage(output, from: output.extent)
                self.backImageView.image = UIImage(cgImage: cgimgresult!)
            } else {
                print("image filtering failed")
            }
        }
        
        if self.selectedShade == .Shadows {
            let ciContext = CIContext(options: nil)
            shadowsValue = CGFloat(float)
            print(float)
            var coreImage = CIImage()
            if mainImage.cgImage != nil{
                coreImage = CIImage(cgImage: mainImage.cgImage!)
            } else {
                coreImage = mainImage.ciImage!
            }
            let filter = CIFilter(name: "CIHighlightShadowAdjust")
            filter?.setValue(float, forKey: "inputShadowAmount")
            filter?.setValue(coreImage, forKey: kCIInputImageKey)
            if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage{
                let cgimgresult = ciContext.createCGImage(output, from: output.extent)
                self.backImageView.image = UIImage(cgImage: cgimgresult!)
            } else {
                print("image filtering failed")
            }
        }
        
        if self.selectedShade == .Tint {
            let ciContext = CIContext(options: nil)
            tintValue = CGFloat(float)
            print(float)
            
            var coreImage = CIImage()
            if mainImage.cgImage != nil {
                coreImage = CIImage(cgImage: mainImage.cgImage!)
            } else {
                coreImage = mainImage.ciImage!
            }
            
            let vector0 = CIVector(x: 4000, y: CGFloat(float))
            let filter = CIFilter(name: "CITemperatureAndTint")
            filter?.setValue(coreImage, forKey: kCIInputImageKey)
            filter?.setValue(vector0, forKey: "inputNeutral")
            
            if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
                let cgimgresult = ciContext.createCGImage(output, from: output.extent)
                self.backImageView.image = UIImage(cgImage: cgimgresult!)
            } else {
                print("image filtering failed")
            }
        }
        
        if self.selectedShade == .Fade {
            let ciContext = CIContext(options: nil)
            fadeValue = CGFloat(float)
            print(float)
            var coreImage = CIImage()
            if mainImage.cgImage != nil {
                coreImage = CIImage(cgImage: mainImage.cgImage!)
            } else {
                coreImage = mainImage.ciImage!
            }
            
            let filter = CIFilter(name: "CIPhotoEffectFade")
            filter?.setValue(float, forKey: "inputImage")
            filter?.setValue(coreImage, forKey: kCIInputImageKey)
            
            if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
                let cgimgresult = ciContext.createCGImage(output, from: output.extent)
                let image = UIImage(cgImage: cgimgresult!)
                let filter = CIFilter(name: "CIHighlightShadowAdjust")
                filter?.setValue(float, forKey: "inputShadowAmount")
                filter?.setValue(CIImage(cgImage: image.cgImage!), forKey: kCIInputImageKey)
                if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage
                {
                    let cgimgresult = ciContext.createCGImage(output, from: output.extent)
                    self.backImageView.image = UIImage(cgImage: cgimgresult!)
                }
            } else {
                print("image filtering failed")
            }
        }
    }
    
    func setSlider(effecName : Shades) {
        self.sliderView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        self.backImageView.image = tempImage
        UIView.animate(withDuration: 0.35) {
            self.sliderView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            if effecName == .Brightness {
                self.effectSlider.isHidden = false
                self.effectSlider.minimumValue = -0.5
                self.effectSlider.maximumValue = 0.5
                self.effectSlider.value = Float(self.brightnessValue)
                self.selectedShade = .Brightness
                self.setSliderValue(float : Float(self.brightnessValue))
            }
            if effecName == .Saturation {
                self.effectSlider.isHidden = false
                self.effectSlider.minimumValue = 0
                self.effectSlider.maximumValue = 2
                self.effectSlider.value = Float(self.saturationVlue)
                self.selectedShade = .Saturation
                self.setSliderValue(float : Float(self.saturationVlue))
            }
            if effecName == .Contrast {
                self.effectSlider.isHidden = false
                self.effectSlider.minimumValue = 0.5
                self.effectSlider.maximumValue = 1.5
                self.effectSlider.value = Float(self.contrastValue)
                self.selectedShade = .Contrast
                self.setSliderValue(float : Float(self.contrastValue))
            }
            if effecName == .Sharpness {
                self.effectSlider.isHidden = false
                self.effectSlider.minimumValue = -1.2
                self.effectSlider.maximumValue = 2.0
                self.effectSlider.value = Float(self.sharpnessValue)
                self.selectedShade = .Sharpness
                self.setSliderValue(float : Float(self.sharpnessValue))
            }
            if effecName == .Warmth {
                self.effectSlider.isHidden = false
                self.effectSlider.minimumValue = 145
                self.effectSlider.maximumValue = 172
                self.effectSlider.value = Float(self.warmthValue)
                self.selectedShade = .Warmth
                self.setSliderValue(float : Float(self.warmthValue))
            }
            if effecName == .Exposure {
                self.effectSlider.isHidden = false
                self.effectSlider.minimumValue = -2
                self.effectSlider.maximumValue = 2
                self.effectSlider.value = Float(self.exposureValue)
                self.selectedShade = .Exposure
                self.setSliderValue(float : Float(self.exposureValue))
            }
            if effecName == .Vibrance {
                self.effectSlider.isHidden = false
                self.effectSlider.minimumValue = -1
                self.effectSlider.maximumValue = 1
                self.effectSlider.value = Float(self.vibranceValue)
                self.selectedShade = .Vibrance
                self.setSliderValue(float : Float(self.vibranceValue))
            }
            if effecName == .Highlights {
                self.effectSlider.isHidden = false
                self.effectSlider.minimumValue = 0
                self.effectSlider.maximumValue = 2
                self.effectSlider.value = Float(self.highlightValue)
                self.selectedShade = .Highlights
                self.setSliderValue(float : Float(self.highlightValue))
            }
            if effecName == .Shadows {
                self.effectSlider.isHidden = false
                self.effectSlider.minimumValue = -1
                self.effectSlider.maximumValue = 1
                self.effectSlider.value = Float(self.shadowsValue)
                self.selectedShade = .Shadows
                self.setSliderValue(float : Float(self.shadowsValue))
            }
            if effecName == .Tint {
                self.effectSlider.isHidden = false
                self.effectSlider.minimumValue = -170
                self.effectSlider.maximumValue = 95
                self.effectSlider.value = Float(self.tintValue)
                self.selectedShade = .Tint
                self.setSliderValue(float : Float(self.tintValue))
            }
            if effecName == .Fade {
                self.effectSlider.isHidden = false
                self.effectSlider.minimumValue = -1
                self.effectSlider.maximumValue = 1
                self.effectSlider.value = Float(self.fadeValue)
                self.selectedShade = .Fade
                self.setSliderValue(float : Float(self.fadeValue))
            }
        }
    }
    
    @IBAction func onEffectApply(_ sender: Any) {
        for view in layoutStackView.subviews{
            if let View = view as? AdjustImageView {
                View.setDefaultView()
            }
        }
        UIView.animate(withDuration: 0.35, animations: {
            self.sliderView.alpha = 0.0
        }, completion: { finished in
            self.sliderView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            self.sliderView.alpha = 1.0
        })
        self.mainImage =  self.backImageView.image
    }
    
    @IBAction func onCancleClick(_ sender: Any) {
        
        UIView.animate(withDuration: 0.35, animations: {
            self.frame = CGRect(x: 0, y: getScreenHeight(), width: getScreenWidth(), height: getScreenHeight())
        }, completion: { finished in
            self.removeFromSuperview()
        })
    }
    
    @IBAction func onSaveClick(_ sender: Any) {
        selectSaveImageCallback!(self.backImageView.image!)
        
        UIView.animate(withDuration: 0.35, animations: {
            self.frame = CGRect(x: 0, y: getScreenHeight(), width: getScreenWidth(), height: getScreenHeight())
        }, completion: { finished in
            self.removeFromSuperview()
        })
    }
    
    @IBAction func slider(_ sender: UISlider) {
        self.setSliderValue(float : sender.value)
    }
}

enum Shades : String {
    case Brightness = "Brightness"
    case Saturation = "Saturation"
    case Contrast = "Contrast"
    case Sharpness = "Sharpness"
    case Warmth = "Warmth"
    case Exposure = "Exposure"
    case Vibrance = "Vibrance"
    case Highlights = "Highlights"
    case Shadows = "Shadows"
    case Tint = "Tint"
    case Fade = "Fade"
}

extension UIView {
    
    //  Get width of View
    public var getWidth : CGFloat {
        return frame.width
    }
    
    //  Get height of view
    public var getHeight : CGFloat {
        return frame.height
    }
    
    //  Get Origin.x
    public var startX : CGFloat {
        return frame.origin.x
    }
    
    //  Get Origin.y
    public var startY : CGFloat {
        return frame.origin.y
    }
}
