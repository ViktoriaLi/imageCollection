//
//  CollectionViewController.swift
//  Image Collection
//
//  Created by Viktoriia LIKHOTKINA on 1/14/19.
//  Copyright © 2019 Viktoriia LIKHOTKINA. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var tapGest: UITapGestureRecognizer!
    
    var selectedImage: URL?
    var counter = 0
    var images = [UIImage]()
    
    enum Errors : String {
        case noAccess = "Cannot acces to "
        case indexOut = "There is no URL with index "
        case cannotDownload = "Problems with image download "
    }
    
    var urls : [URL] = [URL(string: "https://images.unsplash.com/photo-1520697165497-c9247d67370e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1534&q=80")!,
                        URL(string: "https://images.unsplash.com/photo-1523544545175-92e04b96d26b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1534&q=80")!,
                        URL(string: "https://images.unsplash.com/photo-1522827263079-bdc20647393d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=3750&q=80")!,
                        URL(string: "https://images.unsplash.com/photo-1528076225979-12893c7d55e4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=3899&q=80")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openImage" {
            let dvc = segue.destination as! FullImageViewController
            dvc.selectedImage = selectedImage
        }
    }
    
    @IBAction func imageTapped(_ sender: ImageTapGesture) {
            selectedImage = urls[sender.imageIndex!]
        performSegue(withIdentifier: "openImage", sender:  self)
    }
    
    func makeAlert(_ problem : String, errorCase : Errors) {
        let alert = UIAlertController(title: "Error", message: "\(errorCase.rawValue)\(problem)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        guard let imCell = cell as? CollectionViewCell else {
            return cell
        }
        imCell.imageLoading.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let tap = ImageTapGesture(target: self, action: #selector(imageTapped(_:)))
        tap.imageIndex = indexPath.row
        imCell.imageInCell.addGestureRecognizer(tap)
        let queue = DispatchQueue.global(qos: .utility)
        queue.async{
            if self.urls.count < indexPath.row + 1 {
                self.makeAlert(String(describing: indexPath.row), errorCase: Errors.indexOut)
            }
                if let data = try? Data(contentsOf: self.urls[indexPath.row])
                {
                    DispatchQueue.main.async {
                        imCell.imageInCell.image = UIImage(data: data)
                        if imCell.imageInCell.image == nil {
                            self.makeAlert(String(describing: self.urls[indexPath.row]), errorCase: Errors.noAccess)
                        }
                        else
                        {
                            self.images.append(imCell.imageInCell.image!)
                            imCell.imageLoading.stopAnimating()
                            self.counter += 1
                            if self.counter == 4 {
                                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            }
                        }
                    }
                }
                else {
                    self.makeAlert(String(describing: self.urls[indexPath.row]), errorCase: Errors.cannotDownload)
                }
        }
        return imCell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 160.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
}

class ImageTapGesture: UITapGestureRecognizer {
    var imageIndex : Int?
}

