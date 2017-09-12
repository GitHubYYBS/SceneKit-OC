//
//  ParticleSystemsHeadView.h
//  2.Particle Systems粒子系统
//
//  Created by 严兵胜 on 17/9/12.
//  Copyright © 2017年 严兵胜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParticleSystemsHeadView : UIView

@property (nonatomic, copy) void(^headViewDateBlock)(NSInteger lifenNum,NSInteger clickNodeNun);

@property (nonatomic, assign) NSInteger lifeNum;
@property (nonatomic, assign) NSInteger clickNodeNum;

+ (instancetype)headVeiw;

@end
