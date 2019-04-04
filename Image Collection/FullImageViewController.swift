//
//  FullImageViewController.swift
//  Image Collection
//
//  Created by Viktoriia LIKHOTKINA on 1/16/19.
//  Copyright © 2019 Viktoriia LIKHOTKINA. All rights reserved.
//

import UIKit

class FullImageViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var fullImage: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var selectedImage: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
            if selectedImage != nil {
            if let imagedata = try? Data(contentsOf: self.selectedImage!)
            {
                self.fullImage.image = UIImage(data : imagedata)
                fullImage.sizeToFit()
                scrollView?.contentSize = fullImage.frame.size
                }
                scrollView.addSubview(fullImage)
            }
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        view.addSubview(scrollView)
        scrollView.delegate = self
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return fullImage
    }
    
    @IBAction func handlePinchTap(_ sender: UIPinchGestureRecognizer) {
        if fullImage != nil {
            fullImage.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
        }
    }
}
