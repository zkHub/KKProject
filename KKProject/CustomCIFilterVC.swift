//
//  CustomCIFilterVC.swift
//  KKProject
//
//  Created by youplus on 2019/5/22.
//  Copyright © 2019 zhangke. All rights reserved.
//

import UIKit

class CustomCIFilterVC: BaseViewController {

    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let filterName = CIFilter.filterNames(inCategory: kCICategoryBuiltIn)
        print("当前系统内嵌了\(filterName.count)种滤镜\(filterName)。")
        
        //1.创建基于CPU的CIContext对象
        let context = CIContext.init(options: [CIContextOption.useSoftwareRenderer : true])
        
        //2.创建基于GPU的CIContext对象
//        let context = CIContext.init(options: nil)
        
        //3.创建基于OpenGL优化的CIContext对象，可获得实时性能
//        let context = CIContext.init(eaglContext: EAGLContext.init(api: .openGLES3)!)
        
        // 将UIImage转换成CIImage
        let ciImg = CIImage.init(image: UIImage.init(named: "avatar.jpg")!)
        // 创建滤镜
        let filter = CIFilter.init(name: "CIPhotoEffectChrome", parameters: [kCIInputImageKey : ciImg!])
        filter?.setDefaults()
        // 渲染并输出CIImage
        let outputImg = filter?.outputImage
        // 创建CGImage句柄
        let cgImg = context.createCGImage(outputImg!, from: outputImg!.extent)
        imgView.image = UIImage.init(cgImage: cgImg!)
        
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
