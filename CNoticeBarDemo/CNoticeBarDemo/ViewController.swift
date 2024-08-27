//
//  ViewController.swift
//  CNoticeBarDemo
//
//  Created by toro-ios on 2024/8/27.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let dataArr: [String] = ["text","image+text","top","mid","bottom"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bar_cell")!
        cell.textLabel?.text = dataArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let config = CNoticeBarConfig(content: "CNotice")
        config.margin = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        config.content = dataArr[indexPath.row]
        switch indexPath.row {
        case 1:
            config.icon = "msg_warn"
        case 2:
            config.loction = .top
        case 3:
            config.loction = .middle
        case 4:
            config.loction = .bottom
        default:
            break
        }
        let bar = CNoticeBar(config: config)
        bar.show()
    }

}

