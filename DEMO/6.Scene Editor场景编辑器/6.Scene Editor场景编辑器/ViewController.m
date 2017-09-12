//
//  ViewController.m
//  6.Scene Editor场景编辑器
//
//  Created by 严兵胜 on 17/9/12.
//  Copyright © 2017年 严兵胜. All rights reserved.
//

#import "ViewController.h"

#import <SceneKit/SceneKit.h>

@interface ViewController ()<SCNSceneRendererDelegate>

@property (nonatomic, weak) SCNView *scnView;
@property (nonatomic, weak) SCNScene *scene;

@end

@implementation ViewController

- (BOOL)shouldAutorotate{
    
    return true;
}

- (BOOL)prefersStatusBarHidden{
    
    return true;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 创建SCNView 用于管理 维度空间 SCNScene
    SCNView *scnViiew = [[SCNView alloc] initWithFrame:self.view.bounds];
    scnViiew.delegate = self;
    [self.view addSubview:_scnView = scnViiew];
    
    // 场景维度 直接使用我们采用Xcode创建的维度
    SCNScene *scene = [SCNScene sceneNamed:@"SceneEditor.scn"];
    scnViiew.scene = _scene = scene;
    
    
    
    
}


#pragma mark - SCNSceneRendererDelegate

- (void)renderer:(id <SCNSceneRenderer>)renderer updateAtTime:(NSTimeInterval)time API_AVAILABLE(macosx(10.10)){
    
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
