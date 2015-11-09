//
//  CircularProgressView.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/20.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol CircularProgressViewDelegate <NSObject>

@optional

- (void)updateProgressViewWithPlayer:(AVAudioPlayer *)player;
- (void)playerDidFinishPlaying;

@end

@interface CircularProgressView : UIView

//@property (nonatomic) UIColor *backColor;
@property (nonatomic) UIColor *progressColor;
@property (nonatomic, strong) NSString * imgName;
@property (nonatomic, strong) UIImageView *imgView;
@property (assign, nonatomic) float progress;
@property (assign, nonatomic) float updateprogress;

@property (assign, nonatomic) CGFloat lineWidth;
@property (assign, nonatomic) NSTimeInterval duration;
@property (assign, nonatomic) BOOL playOrPauseButtonIsPlaying;
@property (assign, nonatomic) id <CircularProgressViewDelegate> delegate;

-(void)updateProgress:(float) vaules;

- (id)initWithFrame:(CGRect)frame
          backColor:(UIColor *)backColor
      progressColor:(UIColor *)progressColor
          lineWidth:(CGFloat)lineWidth
          audioPath:(NSString *)path;


@end