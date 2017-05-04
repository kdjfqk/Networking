//
//  ViewController.swift
//  Networking
//
//  Created by ldy on 17/3/15.
//  Copyright © 2017年 BJYN. All rights reserved.
//

import UIKit
import Alamofire

let ImaggaAuthorization = "替换为从imagga官网获取的Authorization"

class ViewController: UIViewController {

    var books:[Book] = [Book]()
    var req:NWDownloadRequest?
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var uploadResultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loadUsers(_ sender: AnyObject) {
        
//        do{
//            let req = try BookSearchReq.sendReq(keyword: "理财") { (succ:Bool,result:[Book]?, err:Error?) in
//                if succ && result != nil{
//                    let books = result!
//                    //TODO:添加业务逻辑
//                    print(books)
//                }
//            }
//        }catch{
//            print("\(error.localizedDescription)")
//        }
        
        do{
            let req = try AppServerReq.sendUserQueryReq(userID: "wl") { (succ:Bool,result:User?, err:Error?) in
                if succ && result != nil{
                    let user = result!
                    //TODO:添加业务逻辑
                    print(user.username)
                }
            }
        }catch{
            print("\(error.localizedDescription)")
        }
//        do{
//            let req = try AppServerReq.sendChangePwdReq(old: "111", new: "222", complete: { (succ:Bool,result:Bool?, err:Error?) in
//                if succ && result != nil{
//                    let succ = result!
//                    //TODO:添加业务逻辑
//                    print(succ == true ? "修改成功" : "修改失败")
//                }
//            })
//        }catch{
//            print("\(error.localizedDescription)")
//        }
    }
    
    @IBAction func download(_ sender: AnyObject) {
        do{
            let url = "http://localhost:10108/rest/user/download?fileName=img1.jpg"
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
                let req = try NWUrlReqFactory.createUploadReq(reqName: "upload")
                NWUploadRequest().doUploadResp(req, multDataBlock: { () -> ([(data: Data, name: String, fileName: String?, mimeType: String?)]) in
                    
                    //文件必须传fileName和mimeType
                    //普通键值对参数可以只传data和name
                    return [(imgData,"cover","img1","image/png"),
                            ("param1 value".data(using: String.Encoding.utf8, allowLossyConversion: false)!,"param1",nil,nil)]
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
