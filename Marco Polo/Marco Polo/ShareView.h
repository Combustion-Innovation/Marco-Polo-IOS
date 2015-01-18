//
//  ShareView.h
//  Marco Polo
//
//  Created by Daniel Nasello on 1/9/15.
//  Copyright (c) 2015 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareViewDelegate.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>
@interface ShareView : UIView{
    id<ShareViewDelegate>delegate;
}
@property(nonatomic,strong)UIButton *b;
-(void)createSubViews;

@property(nonatomic,weak)id delegate;
@property(nonatomic,strong)UIButton *facebookButton;
@property(nonatomic,strong)UIButton *twitterButton;
@property(nonatomic,strong)UIButton *textMessageButton;
@property(nonatomic,strong)UIButton *emailButton;
@property(nonatomic,strong)UIButton *moreButton;
@property(nonatomic,strong)UIButton *cancelButton;
@property(nonatomic,assign)BOOL isClosed;
@property(nonatomic,assign)BOOL canClick;
@property(nonatomic,strong)MFMessageComposeViewController *messageComposer;
@property(nonatomic,strong)UIViewController *parentController;
-(void)toggleSocialOut;
@end

