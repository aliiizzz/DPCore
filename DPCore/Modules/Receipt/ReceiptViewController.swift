//
//  ReceiptViewController.swift
//  DPCore
//
//  Created by Farshad Mousalou on 11/11/18.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

class ReceiptViewController: DPBaseViewController, UITableViewDataSource {

    private static let cellId = "receiptCellID"
    
    @IBOutlet private(set) weak var headerView: ReceiptHeaderView!
    @IBOutlet private(set) weak var dataView: ReceiptDataView!
    @IBOutlet private(set) weak var actionButton: BorderedButton!
    @IBOutlet private(set) weak var moreDescriptionLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView! {
        didSet {
             logoImageView.image = UIImage(named: "digipayLogo", in: Bundle(for: type(of: self)), compatibleWith: nil)
        }
    }
    
    private var viewModel: ReceiptViewModel?
    
    var dismissHandler: ((GlobalResponse) -> Void)?
    
    var receipt: ReceiptInput?
    override func viewDidLoad() {
        super.viewDidLoad()
        enableInteraction()
        
        initiliazeViews()
        initiliazeViewModel()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Initiliaze Methods
    
    func initiliazeViewModel() {
        
        //TODO: log or do somthing when reciept not assign or nil
        guard let receipt = self.receipt else { return }
        if receipt.status == .failure {
            self.logoImageView.isHidden = true
        }
        self.viewModel = ReceiptViewModel(input: receipt, bindViewController: self)
        
    }
    
    func initiliazeViews() {
        
        // config tableView
        self.dataView.tableView.rowHeight = UITableViewAutomaticDimension
        self.dataView.tableView.estimatedRowHeight = 44.0
        
        var separatorInset: UIEdgeInsets = .init(top: 0, left: self.dataView.tableView.layoutMargins.left,
                                                  bottom: 0, right: self.dataView.tableView.layoutMargins.right)
        
        if #available(iOS 11.0, *) {
            separatorInset = .init(top: 0, left: self.dataView.tableView.layoutMargins.left,
                                   bottom: 0, right: self.dataView.tableView.layoutMargins.right)
        }
        
        self.dataView.tableView.separatorInset = separatorInset
        
        // assign ReceiptViewController as tableView DataSource
        self.dataView.tableView.dataSource = self
        
        // register receipt cell nib with reuse identifier
        self.dataView.tableView.register(ReceiptCell.nib(), forCellReuseIdentifier: ReceiptViewController.cellId)
        
        // hide footer layouts
        self.actionButton.isHidden = true
        self.actionButton.isEnabled = true
        self.moreDescriptionLabel.isHidden = true
        
    }
    
    /// On Next or Return Action
    @IBAction func nextAction() {
        
        printDebug("Next Action")
        guard let viewModel = viewModel else { return }
        
        //TODO: Refactor
        printDebug("Receipt Data: ", viewModel)
        
        var data: [String: Any] = [:]
        if case .pay(let value) = viewModel.input.data, let payInfo = value.payInfo {
            data = ["payInfo": payInfo]
        }
        
        self.dismissHandler?(GlobalResponse(status: viewModel.input.status,
                                            data: data,
                                            error: viewModel.input.error))
        
    }
    
    @IBAction func cancelAction() {
        //self.dismissHandler?()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.rowsData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReceiptViewController.cellId, for: indexPath) as! ReceiptCell
        
        guard let data = self.viewModel?.rowsData[safe:indexPath.row] else { return cell }
        cell.titleLabel.text = data.title
        cell.valueLabel.text = data.value
        return cell
    }
    
    @available(iOS 11.0, *)
    override func viewSafeAreaInsetsDidChange() {
        
        super.viewSafeAreaInsetsDidChange()
        
        let separatorInset = UIEdgeInsets.init(top: 0, left: self.dataView.tableView.layoutMargins.left,
                                   bottom: 0, right: self.dataView.tableView.layoutMargins.right)
        
        self.dataView.tableView.separatorInset = separatorInset
        self.dataView.tableView.reloadData()
    }
    
}
