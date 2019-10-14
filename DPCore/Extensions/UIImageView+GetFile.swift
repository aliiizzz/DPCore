//
//  UIImageView+GetFile.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-14.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

extension UIImageView {
    func load(_ imageId: String) {
        let service = GetFileService(ticket: GlobalInput.ticket, fileId: imageId)
        service.run().subscribe(onNext: {[weak self] in
            self?.setImage($0)
        }, onError: {[weak self] in
            
            self?.onErrorHandler($0)
        })
    }
    
    fileprivate func setImage(_ data: Data) {
        
        DispatchQueue.main.async {
            let img = UIImage(data: data, scale: UIScreen.main.scale)
            self.image = img
        }
        
    }
    
    fileprivate func onErrorHandler(_ err: Error) {
        print(err)
    }
}
