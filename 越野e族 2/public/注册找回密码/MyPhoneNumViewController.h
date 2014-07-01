//
//  MyPhoneNumViewController.h
//  越野e族
//
//  Created by soulnear on 13-12-26.
//  Copyright (c) 2013年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerificationViewController.h"
#import "ATMHud.h"

@interface MyPhoneNumViewController : UIViewController<UITextFieldDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate>
{
    UITextField * phone_textField;
    
    ASIHTTPRequest * myRequest;
    
    ATMHud * hud;
}

@end
