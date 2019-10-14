//
//  PaymentBankCardListViewModel.swift
//  DPCore
//
//  Created by Farshad Mousalou on 7/2/19.
//  Copyright © 2019 DigiPay. All rights reserved.
//

import Foundation

struct PaymentBankCardListViewModel: ViewModel {
    
    let ticket: Input
    private let networkService: Service
    
    let cards: Observable<[Card]>
    let isFetchingCards: Observable<Bool>
    
    init(ticket: Input) {
        self.ticket = ticket
        isFetchingCards = Observable(false)
        networkService = Service(ticket: ticket)
        cards = Observable([])
    }
    
    func fetchCardList() {
        isFetchingCards.value = true
        networkService
            .run()
            .subscribeOn(queue: .main)
            .map { (response) -> [Card] in
                return response.cards
            }.subscribe(onNext: { (cards) in
                self.isFetchingCards.value = false
                self.cards.value = cards
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
        
        self.isFetchingCards.value = false
        self.cards.value = []
    }
    
}

extension PaymentBankCardListViewModel {
    
    typealias Input = String
    typealias Output = Any?
    typealias Service = GetCardListService
    
    func transform(input: String) -> Any? {
        return nil
    }
}
