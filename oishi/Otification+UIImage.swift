//
//  Otification+UIImage.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/18/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import Foundation

extension UIImage {
    
    func tintWithColor(color:UIColor) -> UIImage {
        
        UIGraphicsBeginImageContext(self.size)
        let context = UIGraphicsGetCurrentContext()
        
        // flip the image
        CGContextScaleCTM(context, 1.0, -1.0)
        CGContextTranslateCTM(context, 0.0, -self.size.height)
        
        // multiply blend mode
        CGContextSetBlendMode(context, CGBlendMode.Multiply)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height)
        CGContextClipToMask(context, rect, self.CGImage)
        color.setFill()
        CGContextFillRect(context, rect)
        
        // create uiimage
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
        
    }
    
    func darkerColor() -> UIImage {
        let context = CIContext()
        let inputImage = CoreImage.CIImage(image: self)
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(inputImage, forKey: "inputImage")
        filter?.setValue(Float(0.1), forKey: "inputBrightness")
        
        let resultImage = UIImage(CGImage: context.createCGImage((filter?.outputImage)!, fromRect: (filter?.outputImage?.extent)!))
        return resultImage
    }
    
    func alpha(value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        
        let ctx = UIGraphicsGetCurrentContext();
        let area = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height);
        
        CGContextScaleCTM(ctx, 1, -1);
        CGContextTranslateCTM(ctx, 0, -area.size.height);
        CGContextSetBlendMode(ctx, CGBlendMode.Multiply);
        CGContextSetAlpha(ctx, value);
        CGContextDrawImage(ctx, area, self.CGImage);
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
    }
    
}