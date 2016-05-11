//
//  INIPayWebViewViewController.swift
//  healthjjak_guest
//
//  Created by 이가람 on 2016. 5. 10..
//  Copyright © 2016년 이가람. All rights reserved.
//

import UIKit

class INIPayWebViewViewController: UIViewController, UIWebViewDelegate {
	
	let user = UserSession.sharedInstance
	
	var INIPayBaseURL = "https://mobile.inicis.com/smart/"
	var payMethod = ""
	
	//이니시스에 넘겨줘야할 정보들
	var P_NOTI = ""
	var P_OID = ""
	var P_GOODS = ""
	var P_AMT = 0
	var P_TAX = 0

	@IBOutlet weak var INIPayWebView: UIWebView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		INIPayWebView.scrollView.scrollEnabled = false
		getOid()
		loadRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func URLEncode(s: String) -> String {
		return (s as NSString).stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
	}
	
	func loadRequest() {
		//let postURL = NSURL(string: "\(self.INIPayBaseURL)\(payMethod)")
		
		//한글 또는 복합필드는 URLEncode()함수로 처리 후  \()로 wrapping 하여 사용
		var body = "P_NOTI=\(self.P_NOTI)"
		body += "&P_OID=\(URLEncode(self.P_OID))"
		body += "&P_GOODS=\(URLEncode(self.P_GOODS))"
		body += "&P_AMT=\(self.P_AMT)"
		body += "&P_UNAME=\(URLEncode(self.user.info["name"] as! String))"
		body += "&P_MNAME=\(URLEncode("헬스짝"))"
		body += "&P_MOBILE=\(URLEncode((self.user.info["phone"] as! String).stringByReplacingOccurrencesOfString("-", withString: "")))"
		body += "&P_EMAIL=\(URLEncode(self.user.info["email"] as! String))"
		body += "&P_MID=INIpayTest"
		//가상계좌시
		body += "&P_NEXT_URL=\(URLEncode("http://211.253.24.190/webview/#/reserve/cancel"))"
		body += "&P_NOTI_URL=\(URLEncode("http://ts.inicis.com/~esjeong/mobile_rnoti/rnoti.php"))"
		//body += "&P_HPP_METHOD=1"
		body += "&P_TAX=\(self.P_TAX)"
		body += "&P_QUOTABASE=01:02:03"
		body += "&P_CHARSET=utf8"
		body += "&P_CANCEL_URL=\(URLEncode("http://211.253.24.190/webview/#/reserve/cancel"))"
		body += "&P_APP_BASE=ON"
		//계좌이체시
		//body += "&P_RETURN_URL=\(URLEncode("https://mobile.inicis.com/smart/testmall/return_url_test.php?OID=\(self.P_OID)"))"
		//취소버튼 작동 시 리다이렉트 주소
		body += "&P_RETURN_URL=\(URLEncode("http://211.253.24.190/webview/#/reserveCancel"))"
		body += "&P_RESERVED=\(URLEncode("twotrs_isp=Y&block_isp=Y&twotrs_isp_noti=N&cp_yn=Y&apprun_check=Y&ismart_use_sign=Y& mall_app_name=healthjjakguest&app_scheme=healthjjakguest://"))"
		print(body)
		
		let postURL = NSURL(string: "\(self.INIPayBaseURL)\(payMethod)?\(body)")
		//euc-kr로 인코딩
		//let bodyData = (body as NSString).dataUsingEncoding(CFStringConvertEncodingToNSStringEncoding(0x0422))
		
		let request = NSMutableURLRequest(URL: (postURL!))
		request.HTTPMethod = "GET"
		request.setValue("text/html;charset=euc-kr", forHTTPHeaderField:"Content-Type")
		//request.HTTPBody = bodyData
		
		INIPayWebView.loadRequest(request)
	}
	
	func getOid(){
		let baseURL = NSURL(string: "http://211.253.24.190/api/index.php/reserve/oid/get")
		
		do{
			let JSONData = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: baseURL!)!, options: .MutableContainers) as! NSDictionary
			
			if JSONData["state"] as! Int == 200 {
				self.P_OID = JSONData["res"] as! String
				print(self.P_OID)
			}else{
				let alertView = UIAlertController.init(title: "결제오류", message: "주문번호 생성에 문제가 생겼습니다. 다시 시도해 주시기 바랍니다.", preferredStyle: .Alert)
				alertView.addAction(UIAlertAction(title: "확인", style: .Default, handler: { (action:UIAlertAction!) -> Void in self.dismissViewControllerAnimated(true, completion: nil)
				}))
				self.presentViewController(alertView, animated: true, completion: nil)
			}
		}catch{
			let alertView = UIAlertController.init(title: "결제오류", message: "주문번호 생성에 문제가 생겼습니다. 다시 시도해 주시기 바랍니다.", preferredStyle: .Alert)
			alertView.addAction(UIAlertAction(title: "확인", style: .Default, handler: { (action:UIAlertAction!) -> Void in self.dismissViewControllerAnimated(true, completion: nil)
			}))
			self.presentViewController(alertView, animated: true, completion: nil)
		}
	}
	
	func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		
		let scheme:String = (request.URL?.absoluteString)!
		let schemeManager = schemeManage(scheme)
		
		for (functionName, functionParam) in schemeManager.functions {
			switch functionName {
			case "cancel":
				self.cancel(functionParam)
				break
			default:
				return false
			}
		}
		
		return true
	}
	
	func webViewDidStartLoad(webView: UIWebView) {
		
	}
	
	func webViewDidFinishLoad(webView: UIWebView) {
		
	}
	
	func cancel(params : Dictionary<String,String>) {
		print("작동")
		self.dismissViewControllerAnimated(true, completion: nil)
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
