//
//  DragAndDropVC.swift
//  KKProject
//
//  Created by youplus on 2019/5/16.
//  Copyright © 2019 zhangke. All rights reserved.
//

import UIKit

class DragAndDropVC: BaseViewController {
    @IBOutlet weak var dragImgView: UIImageView!
    @IBOutlet weak var dropImgView: UIImageView!
    @IBOutlet weak var pasteImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dragImgView.isUserInteractionEnabled = true
        self.dropImgView.isUserInteractionEnabled = true
        self.pasteImgView.isUserInteractionEnabled = true
        
        if #available(iOS 11.0, *) {
            let dragInteraction = UIDragInteraction(delegate: self)
            dragInteraction.isEnabled = true
            self.dragImgView.addInteraction(dragInteraction)
            
            self.dropImgView.addInteraction(UIDropInteraction(delegate: self))
            
            self.pasteImgView.pasteConfiguration = UIPasteConfiguration(forAccepting: UIImage.self)
        }
        
        
        // Do any additional setup after loading the view.
    }

    
    // MARK: - paste 对 Drag 的支持（iOS 11.0支持并重写pasteItemProviders）
    @available(iOS 11.0, *)
    override func paste(itemProviders: [NSItemProvider]) {
        for item in itemProviders {
            if item.canLoadObject(ofClass: UIImage.self) {
                item.loadObject(ofClass: UIImage.self) { (image, error) in
                    if image != nil {
                        DispatchQueue.main.async {
                            UIView.animate(withDuration: 0.5, animations: {
                                self.dragImgView.image = self.pasteImgView.image
                                self.pasteImgView.image = image as? UIImage
                            })
                        }
                    }
                }
            }
        }
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

@available(iOS 11.0, *)
extension DragAndDropVC: UIDragInteractionDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        //session.items - 0
        if interaction.view == self.dragImgView {
            let dragImage = self.dragImgView.image
            let itemProvider = NSItemProvider(object: dragImage!)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            return [dragItem]
        } else {
            return []
        }
    }
 
    
    /**
     
     // MARK: -设置drag时抬起的view
     func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
     return UITargetedDragPreview(view: interaction.view!, parameters: UIDragPreviewParameters())
     }
     
     */
}

@available(iOS 11.0, *)
extension DragAndDropVC: UIDropInteractionDelegate {
    
    // MARK: -Drop的状态提示 如右上角的加号
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let dropLocation = session.location(in: self.view)
        let operation: UIDropOperation
        if self.dropImgView.frame.contains(dropLocation) {
            operation = .copy
        } else {
            operation = .cancel
        }
        return UIDropProposal(operation: operation)
    }
    
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        if session.canLoadObjects(ofClass: UIImage.self) {
            session.loadObjects(ofClass: UIImage.self) { (images) in
                if interaction.view?.isKind(of: UIImageView.self) ?? false {
                    let imageView = interaction.view as! UIImageView
                    self.dragImgView.image = imageView.image
                    imageView.image = images.first as? UIImage
                }
            }
        }
    }
}
