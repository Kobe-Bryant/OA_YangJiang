//
//  MainMenuViewController.h
//  BoandaProject
//
//  Created by 张仁松 on 13-7-2.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"

@interface MainMenuViewController : UIViewController<UIScrollViewDelegate,UIAlertViewDelegate,NSURLConnHelperDelegate>{
    BOOL pageControlIsChangingPage;
}
@property(nonatomic,strong)NSDictionary *dicBadgeInfo;
@end
