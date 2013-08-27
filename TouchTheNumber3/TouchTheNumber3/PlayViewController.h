//
//  PlayViewController.h
//  TouchTheNumber3
//
//  Created by seo hideki on 2013/08/18.
//  Copyright (c) 2013年 seo hideki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>
#import "CircleCounterView.h"

@interface PlayViewController : UIViewController<UIAlertViewDelegate,CircleCounterViewDelegate>{
    NSTimeInterval _startTime;
    NSTimer *_timer;
    NSInteger _nowNumber;
    SystemSoundID _rightSound;
    SystemSoundID _notRightSound;
}


//UIBottonの配列をもつ
@property (retain,nonatomic)NSArray *originalArray;
//現在のタイムを表示
@property (retain)IBOutlet UILabel *time;
@property (retain,nonatomic)NSArray *randomArray;
//ランダムにボタンを配置する
- (void)createRandomButton;
//ボタンが押されたときの反応
- (void)check:(id)sender;

@end
