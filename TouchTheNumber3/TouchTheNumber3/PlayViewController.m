//
//  PlayViewController.m
//  TouchTheNumber3
//
//  Created by seo hideki on 2013/08/18.
//  Copyright (c) 2013年 seo hideki. All rights reserved.
//

#import "PlayViewController.h"
#import "CircleDownCounter.h"


//ボタンの大きさ
static const CGFloat kNumberImageSize = 62;
static const CGFloat kNumberImageOriginX = 0;
static const CGFloat kNumberImageOriginY = 80;


@interface PlayViewController ()

@end

@implementation PlayViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *filePath;
        NSURL *fileURL;
        
        //正解時の音
        filePath = [bundle pathForResource:@"Right"
                                    ofType:@"aiff"];
        fileURL = [NSURL fileURLWithPath:filePath];
        AudioServicesCreateSystemSoundID((CFURLRef)fileURL,
                                         &_rightSound);
        
        //不正解時の音
        filePath = [bundle pathForResource:@"NotRight"
                                    ofType:@"aiff"];
        fileURL = [NSURL fileURLWithPath:filePath];
        AudioServicesCreateSystemSoundID((CFURLRef)fileURL,
                                         &_notRightSound);
    }
    return self;
}

- (void)countDown{
    //アニメーションの設定
    CircleCounterView *circle = [CircleDownCounter showCircleDownWithSeconds:3.0f onView:self.view withSize:CGSizeMake(320,320) andType:CircleDownCounterTypeOneDecimalDecre];
    circle.delegate = self;
    
}

- (void)dealloc{
    AudioServicesDisposeSystemSoundID(_rightSound);
    AudioServicesDisposeSystemSoundID(_notRightSound);
    [_originalArray release];
    [_time release];
    [_randomArray release];
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self countDown];
//    _nowNumber = 1;
//    [self createOriginalArray];
//    [self createRandomButton];
//    [self envalidButton];
//    [self startTimeAtack];
}


- (void)reset{
    _startTime = 0;
    _nowNumber = 1;
    self.originalArray = nil;
    self.randomArray = nil;
    self.time.text = @"00:00:000";
}

- (void)start{
    [self reset];
    [self createOriginalArray];
    [self createRandomButton];
    [self envalidButton];
    [self startTimeAtack];
}

- (void)startTimeAtack{
    _startTime = [NSDate timeIntervalSinceReferenceDate];
    self.time.text = @"00:00:000";
    if (_timer && [_timer isValid]) {
        [_timer invalidate];
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                              target:self
                                            selector:@selector(update:) userInfo:nil
                                             repeats:YES];
}

- (void)update:(NSTimer*)timer{
    NSTimeInterval time = [NSDate timeIntervalSinceReferenceDate] - _startTime;
    int sec = time;
    int msec = (time - sec) * 1000;
    
    self.time.text = [NSString stringWithFormat:@"%02d:%02d:%03d",sec/60,sec%60,msec];
}

//ボタンの配列を作る
- (void)createOriginalArray{
    NSInteger i;
    NSMutableArray *array = [NSMutableArray array];
    for (i=0; i<25; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchDown];
        btn.tag = i+1;
        [array addObject:btn];
    }
    self.originalArray = array;
}

//ランダムにボタンを配置する
- (void)createRandomButton{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *remainArray = [NSMutableArray arrayWithArray:self.originalArray];
    NSInteger i = 0;
    while ([remainArray count] > 0) {
        NSInteger rand = random() % [remainArray count];
        UIButton *btn = [remainArray objectAtIndex:rand];
        btn.frame = CGRectMake(kNumberImageOriginX + kNumberImageSize *(i%5),kNumberImageOriginY + kNumberImageSize * (i/5),kNumberImageSize,kNumberImageSize);
        [array addObject:btn];
        [remainArray removeObjectAtIndex:rand];
        i++;
    }
    self.randomArray = array;
}
//ボタンを有効にする
- (void)envalidButton{
    NSArray *array = self.randomArray;
    for (UIButton *btn in array){
        [self.view addSubview:btn];
    }
}
//ボタンが押されたときの反応
- (void)check:(id)sender{
    UIButton *btn = (UIButton*)sender;
    NSInteger now = _nowNumber;
    
    if (btn.tag == now) {
        AudioServicesPlayAlertSound(_rightSound);
        btn.enabled = NO;
        //ボタンを360°回転
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat:360.0 * (M_PI / 180.0)];
        rotationAnimation.duration = 0.5;
        rotationAnimation.repeatCount = 1;
        [btn.layer addAnimation:rotationAnimation forKey:@"rotateAnimation"];
        
        btn.alpha = 0.3;
        if (now == 25) [self clearGame];
        now += 1;
        _nowNumber = now;
    }else{
        AudioServicesPlayAlertSound(_notRightSound);
    }
}

- (void)clearGame{
    [_timer invalidate];
    _timer =nil;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"クリア！！"
                                                   message:self.time.text
                                                  delegate:self
                                         cancelButtonTitle:@"終わる"
                                         otherButtonTitles:@"もう一回", nil];
    [alert show];
    [alert release];
    
}

//アラートボタンが押されたときの処理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case 1:
            [self countDown];
            break;
            
        default:
            break;
    }
}

//カウントダウンが終わったときの処理
- (void)counterDownFinished:(CircleCounterView *)circleView{
    [circleView removeFromSuperview ];
    [self start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

