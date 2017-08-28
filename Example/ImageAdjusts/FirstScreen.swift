//
//  FirstScreen.swift
//  ImageAdjust
//
//  Created by HIren's iMac on 26/08/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class FirstScreen: UIViewController {
    
    @IBOutlet weak var editImageView: UIImageView!
    
    var editorImageListArray = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setframeImageUI(image : UIImage , isChanges : Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(350)) {
            UIView.animate(withDuration: 0.30, animations:  {
                self.editImageView.image = image
                if isChanges{
                    self.editorImageListArray.append(image)
                }
            }, completion: { finished in
            })
        }
    }
    
    @IBAction func onClickAdjust(_ sender: Any) {
        
        if #available(iOS 9.0, *) {
            let selectLayoutView = AdjustEditorView.create(image : self.editImageView.image!)
            selectLayoutView.selectSaveImageCallback = { image in
                self.setframeImageUI(image : image , isChanges : true)
            }
        }
    }
}
