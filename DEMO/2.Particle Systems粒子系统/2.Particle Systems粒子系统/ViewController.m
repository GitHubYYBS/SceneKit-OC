//
//  ViewController.m
//  2.Particle Systems粒子系统
//
//  Created by 严兵胜 on 17/9/11.
//  Copyright © 2017年 严兵胜. All rights reserved.
//

#import "ViewController.h"

#import <SceneKit/SceneKit.h>


/** 颜色相关 */
#define SC_RGBColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)] // RGB
/** 随机颜色 */
#define SC_RandomlyColor SC_RGBColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), 1)




@interface ViewController ()<SCNSceneRendererDelegate>

@property (nonatomic, weak) SCNScene *scene;

@property (nonatomic, assign) NSTimeInterval timeInterval;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // 1.创建一个维度空间
    SCNScene *scene = [SCNScene new];
    scene.background.contents = [UIImage imageNamed:@"Background_Diffuse"];
    
    
    // 2.创建一个承载维度的平台
    SCNView *scnView = [[SCNView alloc] initWithFrame:self.view.bounds];
    // 2.1将维度添加到该平台上
    scnView.scene = _scene = scene;
    // 2.2显示统计数据
    scnView.showsStatistics = true;
    // 2.3打开相机控制
    scnView.allowsCameraControl = true;
    // 2.4 打开默认光源 _  如果该选项不打开 几何体的效果将无法显示
    scnView.autoenablesDefaultLighting = true;
    // 2.
    [self.view addSubview:scnView];
    // 2.5设置代理
    scnView.delegate = self;
    // 2.6默认情况下,如果一个场景中没有任何改变时,Scene Kit会进入"paused"(暂停)状态,渲染循环暂停后代理方法将不会继续调用,为了防止这种情况,需要在创建SCNView实例时设置playing属性为true 这样渲染循环的代理就会一直调用
    scnView.playing = true;
    
    
    //3. 创建一个节点
    SCNNode *node = [SCNNode new];
    // 3.1创建一个相机节点
    node.camera = [SCNCamera new];
    // 3.2设置相机节点的在父控件的位数
    node.position = SCNVector3Make(0, 5, 10);
    // 3.3将其添加到维度的根节点上
    [scene.rootNode addChildNode:node];
    
}

/// 为维度创建更多的节点
- (void)addNode{
    
    
    // 4.0创建一个几何体
    SCNGeometry *geometer = [SCNGeometry geometry];
    
    // 4.1 具体是什么几何体
    switch (arc4random_uniform(8)) {
        case 0:
            geometer = [SCNSphere sphereWithRadius:0.5]; // 球体
            break;
        case 1:
            geometer = [SCNBox boxWithWidth:1.0 height:1.0 length:1.0 chamferRadius:0]; // 长方体
            break;
        case 2:
            geometer = [SCNPyramid pyramidWithWidth:1.0 height:1.0 length:1.0]; // 四棱锥
            break;
        case 3:
            geometer = [SCNTorus torusWithRingRadius:0.5 pipeRadius:0.25]; // 圆环
            break;
        case 4:
            geometer = [SCNCapsule capsuleWithCapRadius:0.3 height:2.5]; // 胶囊
            break;
        case 5:
            geometer = [SCNCylinder cylinderWithRadius:0.3 height:2.5]; // 圆柱体
            break;
        case 6:
            geometer = [SCNCone coneWithTopRadius:0.25 bottomRadius:0.5 height:1.0]; // 圆柱体
        case 7:
            geometer = [SCNTube tubeWithInnerRadius:0.25 outerRadius:0.5 height:1.0]; // 管道
            break;
        default:
            break;
    }
    
    // 4.2设置几何体的颜色
    UIColor *color = SC_RandomlyColor;
    geometer.materials.firstObject.diffuse.contents = color;
    
    // 4.3创建一个节点来承接该几何体
    SCNNode *geometerNode = [SCNNode nodeWithGeometry:geometer];
    // 4.3.1 设置该集合节点的状态 如果不设置 该几何体会静止在初始位置上
    geometerNode.physicsBody = [SCNPhysicsBody bodyWithType:SCNPhysicsBodyTypeDynamic shape:nil];
    
    
    // 4.4给几何体添加一个力 力使用3维向量SCNVector3表示
    // 4.4.1设置 力 的作用点
    NSInteger X = (NSInteger)(arc4random_uniform(5)) - 2;; // [-2 , 2]
    NSInteger Y = 10 + arc4random() % (18 - 10 + 1); // [10 , 18];
    // 4.4.2 applyForce 力的作用点  impluse 脉冲状只作用一次,比如踢一个球,非脉冲状的则可以持续作用.   Position 位置可以影响力的作用效果
    [geometerNode.physicsBody applyForce:SCNVector3Make(X, Y, 0) atPosition:SCNVector3Make(0.05, 0.05, 0.05) impulse:true];
    
    
    // 5.0创建一个粒子
    SCNParticleSystem * parrticleSystem = [self creatParticleSystemWithColor:color geometry:geometer];
    // 5.1 将该粒子 添加到节点上  有时候会发现 粒子未出现在屏幕中  可能的原因之一是 粒子的大小问题(我就遇到了)
    [geometerNode addParticleSystem:parrticleSystem];
    
    
    // 6.0 将该节点添加到维度的根节点上
    [self.scene.rootNode addChildNode:geometerNode];
    
    NSLog(@"当前剩余节点数 _______  = %lu",(unsigned long)self.scene.rootNode.childNodes.count);
    
}
// 移除超出屏幕的节点 - 以防节点越来越多 造成内存的持续增加
- (void)removeFromParentNode{
    
    // 1.遍历根节点中的子节点
    for (SCNNode *node in self.scene.rootNode.childNodes) {
        
        // 2.0判读子节点的 在父节点的位置
        if (node.presentationNode.position.y < 0) {
            // 3.移除超出屏幕额 子节点
            [node removeFromParentNode];
            NSLog(@"___________我移除了一个节点___");
        }
    }
}


// 点击屏幕
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 添加一个几何节点
    [self addNode];
}




//- (void)clickNodeWith:()



#pragma mark - SCNSceneRendererDelegate

/// 维度渲染一次就调用一次
- (void)renderer:(id<SCNSceneRenderer>)renderer updateAtTime:(NSTimeInterval)time{
    
    // 判读时间 控制子节点 控制子节点增加的 个数 及速度
    if (time > self.timeInterval) {
        // 添加 子节点
        [self addNode];
        
        // 延长时间
        self.timeInterval = time + 0.5;
    }
    
    // 检查所有的子节点
    [self removeFromParentNode];
}


#pragma mark - 粒子相关 SCNParticleSystem


/**
 创建粒子
 
 @param color 粒子的颜色
 @param geometry 粒子发射器
 @return
 */
- (SCNParticleSystem *)creatParticleSystemWithColor:(UIColor *)color geometry:(SCNGeometry *)geometry{
    
    
    // 创建粒子 直接使用系统的粒子 具体创建在笔记中有介绍
    SCNParticleSystem *particleSystem = [SCNParticleSystem particleSystemNamed:@"Rain.scnp" inDirectory:nil];
    
    // 设置粒子颜色 保证粒子的颜色与发射器几何体的颜色是一致的
    particleSystem.particleColor = color;
    // 指定发射器的形状 此处将传来的几何体作为粒子的发射器
    particleSystem.emitterShape = geometry;
    
    return particleSystem;
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
