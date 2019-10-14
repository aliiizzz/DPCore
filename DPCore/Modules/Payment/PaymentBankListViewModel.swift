//
//  PaymentBankListViewModel.swift
//  DPCore
//
//  Created by Farshad Mousalou on 7/2/19.
//  Copyright © 2019 DigiPay. All rights reserved.
//

import Foundation

struct PaymentBankListViewModel: ViewModel {
    
    let ticket: Input
    private let networkService: Service
    
    let items: Observable<[BankModel]?>
    let isFetching: Observable<Bool>
    
    init(ticket: Input) {
        self.ticket = ticket
        isFetching = Observable(false)
        networkService = Service(ticket: ticket)
        items = Observable(nil)
    }
    
    func fetchBankList() {
        isFetching.value = true
        networkService
            .run()
            .subscribeOn(queue: .main)
            .map { (response) -> [BankModel] in
                return response.banks
            }.subscribe(onNext: { (cards) in
                self.isFetching.value = false
                self.items.value = cards
            }, onError: { (error) in
                self.handle(error: error)
            }) { (error, response) in
                
                guard let response = response as? Service.responseType else {
                    self.handle(error: error)
                    return
                }
                
                self.handle(error: error, data: response)
                
        }
        
    }
    
    private func handle(error: Error, data: Service.responseType? = nil) {
        
        self.isFetching.value = false
        
    }
    
}

extension PaymentBankListViewModel {
    
    typealias Input = String
    typealias Output = Any?
    typealias Service = GetBankListService
    
    func transform(input: String) -> Any? {
        return nil
    }
}
