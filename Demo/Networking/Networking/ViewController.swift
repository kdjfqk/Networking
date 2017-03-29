//
//  ViewController.swift
//  Networking
//
//  Created by ldy on 17/3/15.
//  Copyright © 2017年 BJYN. All rights reserved.
//

import UIKit

let ImaggaAuthorization = "替换为从imagga官网获取的Authorization"

class ViewController: UIViewController {

    var books:[Book] = [Book]()
    var req:NWDownloadRequest?
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var uploadResultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NWHttpConfigManager.configFilePath = Bundle.main.path(forResource: "DouBan", ofType: "plist")!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loadUsers(_ sender: AnyObject) {
        
        do{
            let req = try BookSearchReq.sendReq(keyword: "理财") { (succ:Bool,result:[Book]?, err:Error?) in
                if succ && result != nil{
                    let books = result!
                    //TODO:添加业务逻辑
                }
            }
        }catch{
            print("\(error.localizedDescription)")
        }
    }
    
    @IBAction func download(_ sender: AnyObject) {
        do{
            let url = "http://img13.poco.cn/mypoco/myphoto/20120828/15/55689209201208281549023849547194135_001.jpg"
            var path = FileUtil.documentsPath()!
            path.append("/imgs/firstImg.jpg")
            self.req = NWDownloadRequest()
            self.req!.doDownload(url, destPath: path, progress: { (recived:Int64, total:Int64) in
                print("完成：\(Float(recived)/Float(total)*100)%")
                }, success: { (result:Data?) in
                    print("下载完成")
                    if let imgData = result {
                        self.imgView.image = UIImage(data: imgData)
                    }
                }, failure: { (err:Error?) in
                    print("下载失败：\(err?.localizedDescription)")
            })
        }catch{
            print("\(error.localizedDescription)")
        }
        
    }
    
    @IBAction func pauseDownload(_ sender: UIButton) {
        if sender.titleLabel?.text == "暂停下载" {
            //暂停
            self.req?.stop()
            sender.setTitle("继续下载", for: .normal)
        }else if sender.titleLabel?.text == "继续下载" {
            //继续
            sender.setTitle("暂停下载", for: .normal)
            self.req?.resume()
        }
    }
    
    @IBAction func upload(_ sender: UIButton) {
        if let imgData = UIImagePNGRepresentation(self.imgView.image!) {
            do{
                let req = try NWUrlReqFactory.createUploadReq(reqName: "imagga_upload", header: ["Authorization":ImaggaAuthorization,"Content-Type":"multipart/form-data"])
                NWUploadRequest().doUploadResp(req, multDataBlock: { () -> ([(data: Data, name: String)]) in
                    return [(imgData,"img1")]
                    }, progress: { (recived:Int64, total:Int64) in
                        print("完成：\(Float(recived)/Float(total)*100)%")
                    }, success: { (resp:ImaggaUploadResp) in
                        print("已成功上传")
                        self.uploadResultLabel.text = "已成功上传"
                    }, failure: { (err:Error) in
                        print("上传失败：\(err.localizedDescription)")
                        self.uploadResultLabel.text = "上传失败：\(err.localizedDescription)"
                })
            }catch{
                print(error.localizedDescription)
                self.uploadResultLabel.text = error.localizedDescription
            }
            
        }else{
            self.uploadResultLabel.text = "图片数据为空，请先下载"
        }
    }

}

