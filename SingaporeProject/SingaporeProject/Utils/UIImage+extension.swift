//
//  UIImage+extension.swift
//  SingaporeProject
//
//  Created by 塗木冴 on 2019/09/29.
//  Copyright © 2019 塗木冴. All rights reserved.
//

//import UIKit
//import VideoToolbox
//
//extension UIImage {
//    func croppingToCenterSquare() -> UIImage {
//        let cgImage = self.cgImage!
//        var newWidth = CGFloat(cgImage.width)
//        var newHeight = CGFloat(cgImage.height)
//        if newWidth > newHeight {
//            newWidth = newHeight
//        } else {
//            newHeight = newWidth
//        }
//        let x = (CGFloat(cgImage.width) - newWidth)/2
//        let y = (CGFloat(cgImage.height) - newHeight)/2
//        let rect = CGRect(x: x, y: y, width: newWidth, height: newHeight)
//        let croppedCGImage = cgImage.cropping(to: rect)!
//        return UIImage(cgImage: croppedCGImage, scale: self.scale, orientation: self.imageOrientation)
//    }
//
//    func configureData() -> Data? {
//        let image = self.resize(size: CGSize(width: 224, height: 224))
//        let resizedImageData = UIImage.jpegData(image)
////            UIImageJPEGRepresentation(image, 1.0) else { return nil }
//        return resizedImageData.
////        base64EncodedData(options: .lineLength64Characters)
//    }
//
//    func resize(size: CGSize) -> UIImage {
//        let widthRatio = size.width / self.size.width
//        let heightRatio = size.height / self.size.height
//        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
//        let resizeSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
//        UIGraphicsBeginImageContextWithOptions(resizeSize, false, 0.0)
//        draw(in: CGRect(origin: .zero, size: resizeSize))
//        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return resizedImage ?? self
//    }
//
//    /**
//     Resizes the image to width x height and converts it to an RGB CVPixelBuffer.
//     */
//    public func pixelBuffer(width: Int, height: Int) -> CVPixelBuffer? {
//        return pixelBuffer(width: width, height: height,
//                           pixelFormatType: kCVPixelFormatType_32ARGB,
//                           colorSpace: CGColorSpaceCreateDeviceRGB(),
//                           alphaInfo: .noneSkipFirst)
//    }
//
//    /**
//     Resizes the image to width x height and converts it to a grayscale CVPixelBuffer.
//     */
//    public func pixelBufferGray(width: Int, height: Int) -> CVPixelBuffer? {
//        return pixelBuffer(width: width, height: height,
//                           pixelFormatType: kCVPixelFormatType_OneComponent8,
//                           colorSpace: CGColorSpaceCreateDeviceGray(),
//                           alphaInfo: .none)
//    }
//
//    func pixelBuffer(width: Int, height: Int, pixelFormatType: OSType,
//                     colorSpace: CGColorSpace, alphaInfo: CGImageAlphaInfo) -> CVPixelBuffer? {
//        var maybePixelBuffer: CVPixelBuffer?
//        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
//                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue]
//        let status = CVPixelBufferCreate(kCFAllocatorDefault,
//                                         width,
//                                         height,
//                                         pixelFormatType,
//                                         attrs as CFDictionary,
//                                         &maybePixelBuffer)
//
//        guard status == kCVReturnSuccess, let pixelBuffer = maybePixelBuffer else {
//            return nil
//        }
//
//        let flags = CVPixelBufferLockFlags(rawValue: 0)
//        guard kCVReturnSuccess == CVPixelBufferLockBaseAddress(pixelBuffer, flags) else {
//            return nil
//        }
//        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, flags) }
//
//        guard let context = CGContext(data: CVPixelBufferGetBaseAddress(pixelBuffer),
//                                      width: width,
//                                      height: height,
//                                      bitsPerComponent: 8,
//                                      bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
//                                      space: colorSpace,
//                                      bitmapInfo: alphaInfo.rawValue)
//            else {
//                return nil
//        }
//
//        UIGraphicsPushContext(context)
//        context.translateBy(x: 0, y: CGFloat(height))
//        context.scaleBy(x: 1, y: -1)
//        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
//        UIGraphicsPopContext()
//
//        return pixelBuffer
//    }
//}
