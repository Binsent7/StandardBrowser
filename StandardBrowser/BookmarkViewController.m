//
//  BookmarkViewController.m
//  StandardBrowser
//
//  Created by hishinuma on 2015/11/23.
//  Copyright © 2015年 binsent. All rights reserved.
//

#import "BookmarkViewController.h"

@implementation BookmarkViewController

/*
 閉じるボタンタップ時にコール
 */
- (IBAction)onTapCloseButton:(id)sender {
    // 表示している画面を閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
