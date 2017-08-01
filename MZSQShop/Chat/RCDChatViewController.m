//
//  RCDChatViewController.m
//  RCloudMessage
//
//  Created by Liv on 15/3/13.
//  Copyright (c) 2015年 胡利武. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RongIMLib.h>
#import "RCDChatViewController.h"
#import "RCDLocationViewController.h"
#import "RCDImagePreviewController.h"
#import "RCDMapViewController.h"
#import <AudioToolbox/AudioToolbox.h>
@interface RCDChatViewController ()<RCLocationPickerViewControllerDelegate,RCIMReceiveMessageDelegate>

@end

@implementation RCDChatViewController
- (void)viewDidLoad {
  self.navigationController.navigationBarHidden=NO;
   // self.navigationController.view.backgroundColor=[UIColor redColor];
  [super viewDidLoad];
    self.enableSaveNewPhotoToLocalSystem = YES;
    //[self setMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
    [self notifyUpdateUnreadMessageCount];
 //  [RCIM sharedRCIM].userInfoDataSource=self;
    [RCIM sharedRCIM].enableMessageAttachUserInfo=YES;
    [[RCIM sharedRCIM]setReceiveMessageDelegate:self];
    [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:104];
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:3];
    [self newNav];
}

#pragma mark - RCIMConnectionStatusDelegate
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{

    dispatch_async(dispatch_get_main_queue(), ^{
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(1007);
    });
}

-(UIImage *)ImageForColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 10, 10);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(void)newNav{
  dispatch_async(dispatch_get_main_queue(), ^{
      UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      backBtn.frame = CGRectMake(0, 0, 44, 44);
      backBtn.imageEdgeInsets=UIEdgeInsetsMake(0, -15, 0, 15);
      [backBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
      [backBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
     /* UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop_img"]];
      backImg.contentMode=UIViewContentModeScaleAspectFit;
      backImg.frame = CGRectMake(-10, 8, 28, 28);
      [backBtn addSubview:backImg];
      UILabel *backText = [[UILabel alloc] initWithFrame:CGRectMake(12, 11, 65, 22)];
      backText.text = @"返回";
      backText.font = BigFont(1);
      [backText setBackgroundColor:[UIColor clearColor]];
      [backText setTextColor:pinkTextColor];
      [backBtn addSubview:backText];*/
      [backBtn addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
      [self.navigationItem setLeftBarButtonItem: [[UIBarButtonItem alloc] initWithCustomView:backBtn]];
      if(self.conversationType==ConversationType_GROUP){
          
        /*  UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
          [btn setImage:[UIImage imageNamed:@"group_img"] forState:UIControlStateNormal];
          [btn addTarget:self action:@selector(GroupInfoEvent:) forControlEvents:UIControlEventTouchUpInside];
          self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];*/
      }
  });
}

/*-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    if ([userId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
        completion([RCIMClient sharedRCIMClient].currentUserInfo);
    }else{
        AnalyzeObject *analy=[[AnalyzeObject alloc]init];
        [analy GetNickAndAvatarWithUser_ID:userId Block:^(id models, NSString *code, NSString *msg) {
            NSArray *Arr=models;
            if (Arr && Arr.firstObject && [code isEqualToString:@"0"]) {
                NSDictionary *dic = Arr.firstObject;
                RCUserInfo *info = [[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"%@",dic[@"id"]] name:[NSString stringWithFormat:@"%@",dic[@"nick_name"]] portrait:[NSString stringWithFormat:@"%@",dic[@"avatar"]]];
                completion(info);
            }

        }];
    }
}*/
- (void)leftBarButtonItemPressed:(id)sender {
  //需要调用super的实现
  [super leftBarButtonItemPressed:sender];

  [self.navigationController popViewControllerAnimated:YES];
}

- (RCMessageContent *)willSendMessage:(RCMessageContent *)messageCotent{
    
    messageCotent.senderUserInfo=[RCIMClient sharedRCIMClient].currentUserInfo;
    return messageCotent;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

/*- (void)didTapCellPortrait:(NSString *)userId{
    if ([userId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
        return;
    }
    self.hidesBottomBarWhenPushed=YES;
    PresonViewController *presonVC=[[PresonViewController alloc]init];
    presonVC.ID=userId;
    presonVC.conversationType=self.conversationType;
    [self.navigationController pushViewController:presonVC animated:YES];
}*/

- (void)presentImagePreviewController:(RCMessageModel *)model;
{
    RCDImagePreviewController *_imagePreviewVC =
    [[RCDImagePreviewController alloc] init];
    _imagePreviewVC.messageModel = model;
    _imagePreviewVC.title = @"图片预览";
    UINavigationController *nav = [[UINavigationController alloc]
                                   initWithRootViewController:_imagePreviewVC];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)openLocationPicker:(id)sender{
    
    RCDLocationViewController *_imagePreviewVC =   [[RCDLocationViewController alloc] init];
    _imagePreviewVC.title = @"选取位置";
    _imagePreviewVC.delegate=self;
    [self.navigationController pushViewController:_imagePreviewVC animated:YES];
}

- (void)presentLocationViewController:(RCLocationMessage *)locationMessageContent{
    RCDMapViewController *mapVC=[[RCDMapViewController alloc]init];
    mapVC.locationMessageContent=locationMessageContent;
    [self presentViewController:mapVC animated:YES completion:nil];
}


//
//}
/**
 *  此处使用自定义设置，开发者可以根据需求自己实现
 *  不添加rightBarButtonItemClicked事件，则使用默认实现。
 */
/*- (void)rightBarButtonItemClicked:(id)sender {
  if (self.conversationType == ConversationType_PRIVATE) {

    RCDPrivateSettingViewController *settingVC =
        [[RCDPrivateSettingViewController alloc] init];
    settingVC.conversationType = self.conversationType;
    settingVC.targetId = self.targetId;
//    settingVC.conversationTitle = self.userName;
//    //设置讨论组标题时，改变当前聊天界面的标题
//    settingVC.setDiscussTitleCompletion = ^(NSString *discussTitle) {
//      self.title = discussTitle;
//    };
    //清除聊天记录之后reload data
    __weak RCDChatViewController *weakSelf = self;
    settingVC.clearHistoryCompletion = ^(BOOL isSuccess) {
      if (isSuccess) {
        [weakSelf.conversationDataRepository removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
          [weakSelf.conversationMessageCollectionView reloadData];
        });
      }
    };

    [self.navigationController pushViewController:settingVC animated:YES];

  } else if (self.conversationType == ConversationType_DISCUSSION) {

    RCDDiscussGroupSettingViewController *settingVC =
        [[RCDDiscussGroupSettingViewController alloc] init];
    settingVC.conversationType = self.conversationType;
    settingVC.targetId = self.targetId;
    settingVC.conversationTitle = self.userName;
    //设置讨论组标题时，改变当前聊天界面的标题
    settingVC.setDiscussTitleCompletion = ^(NSString *discussTitle) {
      self.title = discussTitle;
    };
    //清除聊天记录之后reload data
    __weak RCDChatViewController *weakSelf = self;
    settingVC.clearHistoryCompletion = ^(BOOL isSuccess) {
      if (isSuccess) {
        [weakSelf.conversationDataRepository removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
          [weakSelf.conversationMessageCollectionView reloadData];
        });
      }
    };

    [self.navigationController pushViewController:settingVC animated:YES];
  }

  //聊天室设置
  else if (self.conversationType == ConversationType_CHATROOM) {
    RCDRoomSettingViewController *settingVC =
        [[RCDRoomSettingViewController alloc] init];
    settingVC.conversationType = self.conversationType;
    settingVC.targetId = self.targetId;
    [self.navigationController pushViewController:settingVC animated:YES];
  }

  //群组设置
  else if (self.conversationType == ConversationType_GROUP) {
    RCSettingViewController *settingVC = [[RCSettingViewController alloc] init];
    settingVC.conversationType = self.conversationType;
    settingVC.targetId = self.targetId;
    //清除聊天记录之后reload data
    __weak RCDChatViewController *weakSelf = self;
    settingVC.clearHistoryCompletion = ^(BOOL isSuccess) {
      if (isSuccess) {
        [weakSelf.conversationDataRepository removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
          [weakSelf.conversationMessageCollectionView reloadData];
        });
      }
    };
    [self.navigationController pushViewController:settingVC animated:YES];
  }
  //客服设置
  else if (self.conversationType == ConversationType_CUSTOMERSERVICE) {
    RCSettingViewController *settingVC = [[RCSettingViewController alloc] init];
    settingVC.conversationType = self.conversationType;
    settingVC.targetId = self.targetId;
    //清除聊天记录之后reload data
    __weak RCDChatViewController *weakSelf = self;
    settingVC.clearHistoryCompletion = ^(BOOL isSuccess) {
      if (isSuccess) {
        [weakSelf.conversationDataRepository removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
          [weakSelf.conversationMessageCollectionView reloadData];
        });
      }
    };
    [self.navigationController pushViewController:settingVC animated:YES];
  }
}*/

/**
 *  打开大图。开发者可以重写，自己下载并且展示图片。默认使用内置controller
 *
 *  @param imageMessageContent 图片消息内容
 */
/*- (void)presentImagePreviewController:(RCMessageModel *)model;
{
  RCImagePreviewController *_imagePreviewVC =
      [[RCImagePreviewController alloc] init];
  _imagePreviewVC.messageModel = model;
  _imagePreviewVC.title = @"图片预览";

  UINavigationController *nav = [[UINavigationController alloc]
      initWithRootViewController:_imagePreviewVC];

  [self presentViewController:nav animated:YES completion:nil];
}

- (void)didLongTouchMessageCell:(RCMessageModel *)model inView:(UIView *)view {
    [super didLongTouchMessageCell:model inView:view];
    NSLog(@"%s", __FUNCTION__);
}*/


/**
 *  更新左上角未读消息数
 */
- (void)notifyUpdateUnreadMessageCount {
 /* __weak typeof(&*self) __weakself = self;
  int count = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
    @(ConversationType_PRIVATE),
    @(ConversationType_DISCUSSION),
    @(ConversationType_APPSERVICE),
    @(ConversationType_PUBLICSERVICE),
    @(ConversationType_GROUP)
  ]];
  dispatch_async(dispatch_get_main_queue(), ^{
      NSString *backString = nil;
    if (count > 0 && count < 1000) {
      backString = [NSString stringWithFormat:@"返回(%d)", count];
    } else if (count >= 1000) {
      backString = @"返回(...)";
    } else {
      backString = @"返回";
    }
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 6, 67, 23);
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigator_btn_back"]];
    backImg.frame = CGRectMake(-10, 0, 22, 22);
    [backBtn addSubview:backImg];
    UILabel *backText = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 65, 22)];
    backText.text = backString;//NSLocalizedStringFromTable(@"Back", @"RongCloudKit", nil);
    backText.font = [UIFont systemFontOfSize:15];
    [backText setBackgroundColor:[UIColor clearColor]];
    [backText setTextColor:[UIColor whiteColor]];
    [backBtn addSubview:backText];
    [backBtn addTarget:__weakself action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [__weakself.navigationItem setLeftBarButtonItem:leftButton];
  });*/
}

//- (void)saveNewPhotoToLocalSystemAfterSendingSuccess:(UIImage *)newImage
//{
//    //保存图片
//    UIImage *image = newImage;
//    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//}
//- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
//    
//}*/

//- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag{
//    [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
//    switch (tag) {
//        case 101: {
//            //这里加你自己的事件处理
//        } break;
//        default:
//            break;
//    }
//}

@end
