# ImageAdjusts

[![CI Status](http://img.shields.io/travis/Dhvl-Golakiya/ImageAdjusts.svg?style=flat)](https://travis-ci.org/Dhvl-Golakiya/ImageAdjusts)
[![Version](https://img.shields.io/cocoapods/v/ImageAdjusts.svg?style=flat)](http://cocoapods.org/pods/ImageAdjusts)
[![License](https://img.shields.io/cocoapods/l/ImageAdjusts.svg?style=flat)](http://cocoapods.org/pods/ImageAdjusts)
[![Platform](https://img.shields.io/cocoapods/p/ImageAdjusts.svg?style=flat)](http://cocoapods.org/pods/ImageAdjusts)

Adjust properties of image like Brightness, Saturation etc.

## Features

You can adjust all properties of image like:

### Brightness & Saturation
<a href="https://ibb.co/kaND7Q"><img src="https://image.ibb.co/d9Z4E5/Brightness.png" alt="Brightness" border="0"></a>
<a href="https://ibb.co/iuTaMk"><img src="https://image.ibb.co/fxzRSQ/Sarturation.png" alt="Sarturation" border="0"></a>

### Contrast & Sharpness
<a href="https://ibb.co/eSHVnQ"><img src="https://image.ibb.co/dnzzgk/Contrast.png" alt="Contrast" border="0"></a>
<a href="https://ibb.co/dLTEE5"><img src="https://image.ibb.co/d52Kgk/Sharpness.png" alt="Sharpness" border="0"></a>

### Warmth & Exposure
<a href="https://ibb.co/c7U4E5"><img src="https://image.ibb.co/jpi9gk/Warmth.png" alt="Warmth" border="0"></a>
<a href="https://ibb.co/jdJ9gk"><img src="https://image.ibb.co/mLLN1k/Exposure.png" alt="Exposure" border="0"></a>

### Vibrance & Highlights
<a href="https://ibb.co/i2auE5"><img src="https://image.ibb.co/mz337Q/Vibrance.png" alt="Vibrance" border="0"></a>
<a href="https://ibb.co/f4RC1k"><img src="https://image.ibb.co/imTQMk/Highlights.png" alt="Highlights" border="0"></a>

### Shadows & Tint
<a href="https://ibb.co/iwyv45"><img src="https://image.ibb.co/fyVmBk/Shadows.png" alt="Shadows" border="0"></a>
<a href="https://ibb.co/gy08P5"><img src="https://image.ibb.co/jf2Nj5/Tint.png" alt="Tint" border="0"></a>

### Fade
<a href="https://ibb.co/cnZDrk"><img src="https://image.ibb.co/mRGRBk/Fade.png" alt="Fade" border="0"></a>

## Requirements

Require iOS 9.0 and above.

## Installation

ImageAdjusts is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ImageAdjusts"
```

## How to use

```
let imageAdjustView = ImageAdjustView.create(image : self.editImageView.image!)
    imageAdjustView.selectSaveImageCallback = { image in
    self.setframeImageUI(image : image , isChanges : true)
} 
```

## Author

Dhvl-Golakiya, dhvl.golakiya@gmail.com

## License

ImageAdjusts is available under the MIT license. See the LICENSE file for more info.
