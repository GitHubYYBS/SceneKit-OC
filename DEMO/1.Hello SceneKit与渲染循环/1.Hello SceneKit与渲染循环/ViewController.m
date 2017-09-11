//
//  ViewController.m
//  1.Hello SceneKit与渲染循环
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

- (BOOL)shouldAutorotate{
    
    return true;
}

- (BOOL)prefersStatusBarHidden{
    
    return true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    
    
    // SCNView
    SCNView *scenView = [SCNView new];
    scenView.backgroundColor = [UIColor redColor];
    scenView.frame = self.view.bounds;
    scenView.showsStatistics = true; // 显示统计数据
    scenView.allowsCameraControl = true; // 打开相机控制
    scenView.autoenablesDefaultLighting = true; // 打开默认光源 _  如果该选项不打开 几何体的效果将无法显示
    [self.view addSubview:scenView];
    
    scenView.delegate = self;
    
    /*
     注意
     默认情况下,如果一个场景中没有任何改变时,Scene Kit会进入"paused"(暂停)状态,渲染循环暂停后代理方法将不会继续调用,为了防止这种情况,需要在创建SCNView实例时设置playing属性为true 这样渲染循环的代理就会一直调用
     */
    scenView.playing = true;
    
    
    // SCNScene - 默认有一个根节点 Scene Kit中的scene默认打开了重力,当设定过动态形体后,物体就会受到重力影响下落
    SCNScene *scene = [SCNScene new];
    scenView.scene = _scene = scene; // 将该场景添加到 SCNView 上 否侧该场景无法显示
    scene.background.contents = [UIImage imageNamed:@"Background_Diffuse"];
    
    // 创建一个相机节点
    SCNNode *node = [SCNNode new];
    node.camera = [SCNCamera new];
    node.position = SCNVector3Make(0, 5, 10);
    // 将其添加到根节点上
    [scene.rootNode addChildNode:node];
    
    //
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self addChilNode];
    
}




- (void)addChilNode{
    
    
    // 创建一个几何体
    SCNGeometry *geometer = [SCNGeometry geometry];
    
    // 具体是什么几何体
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
    
    geometer.materials.firstObject.diffuse.contents = SC_RandomlyColor; // 设置几何体的颜色
    
    
    
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"红包"]];
    [imageView sizeToFit];
    
    
    
    SCNNode *node = [SCNNode nodeWithGeometry:geometer];
    
    /* 知识点:physics body物理形体
     
     Static(静态的):形体不移动:当其他物体能够与该类型碰撞时,该类型自身不受任何力和碰撞的影响,该类型用于墙壁和大质量不可移动的岩石;
     Dynamic(动态的):可以被力和碰撞影响,用于可移动的桌椅,杯子;
     Kinematic(运动学的):类型于静态形体,不受力和碰撞影响.但你可以移动该类型,移动过程中与其他动态形体碰撞.用于移动的电梯或可以开关的门;
     physics shapes物理形状
     
     
     物理形状决定了物理引擎在处理碰撞时的形状检测.
     为了让物理模拟器运行的更快,最好将物理形状设定为简单的方形,球形或其他系统提供的原始形状,大略匹配节点外观就行了
     
     
     如果想要添加更多细节到物理形状,可以手动创建SCNPhysicsShape并传入,否则可使用nil
     
     */
    
    node.physicsBody = [SCNPhysicsBody bodyWithType:SCNPhysicsBodyTypeDynamic shape:nil];
    
    
    
    
    
    
    // 给几何体添加一个力 力使用3维向量SCNVector3表示
    /*
     
     添加一个力,并指定位置.一个力可以同时影响线速度和角速度.
     impluse 脉冲状只作用一次,比如踢一个球,非脉冲状的则可以持续作用.
     Position 位置可以影响力的作用效果
     */
    
    // 设置 力 的作用点
    NSInteger X = (NSInteger)(arc4random_uniform(5)) - 2;; // [-2 , 2]
    NSInteger Y = 10 + arc4random() % (18 - 10 + 1); // [10 , 18];
    
    [node.physicsBody applyForce:SCNVector3Make(X, Y, 0) atPosition:SCNVector3Make(0.05, 0.05, 0.05) impulse:true];
    
    [self.scene.rootNode addChildNode:node];
    
    
    //查看维度中有多少个节点
    NSLog(@"self.scene.rootNode.childNodes.count = %lu",(unsigned long)self.scene.rootNode.childNodes.count);
    
    
    
}


// 移除已离开屏幕的节点 避免内存的持续上涨
- (void)cleanScene{
    
    
    for (SCNNode *node in self.scene.rootNode.childNodes) {
        
        if (node.presentationNode.position.y < -2){
            [node removeFromParentNode];
            
            NSLog(@"___________我移除了一个小兔崽子___");
        }
    }
}

#pragma mark - SCNSceneRendererDelegate


/*
 该方法调用非常频繁 - 一般是 屏幕渲染一次就会调用一次 具体你可以打印看一下
 可以在这里写一些基础逻辑,比如添加或移除node节点.
 */

- (void)renderer:(id<SCNSceneRenderer>)renderer updateAtTime:(NSTimeInterval)time{
    
    
    if (time > self.timeInterval) {
        
        // 在屏幕上增加节点
        [self addChilNode];
        
        // 延长时间
        self.timeInterval = time + 0.5;
    }
    
    [self cleanScene];
    
}



/*!
 时场景中所有节点在这一帧的actions(动作)和animations(动画)都已经更新完成.
 */
- (void)renderer:(id <SCNSceneRenderer>)renderer didApplyAnimationsAtTime:(NSTimeInterval)time API_AVAILABLE(macosx(10.10)){
    
}

/*!
 此时物理效果模拟已经完成,可以在这里添加和物理效果有关的代码,比如node在受到一个力影响后改
 */
- (void)renderer:(id <SCNSceneRenderer>)renderer didSimulatePhysicsAtTime:(NSTimeInterval)time API_AVAILABLE(macosx(10.10)){}

/*!
 此时即将要渲染场景,可以在这里对场景做最后的更改
 */
- (void)renderer:(id <SCNSceneRenderer>)renderer willRenderScene:(SCNScene *)scene atTime:(NSTimeInterval)time{
    
}

/*!
 它标识着一个渲染循环的结束,可以写一些逻辑更新代码在这里,比如游戏中血量增减
 */
- (void)renderer:(id <SCNSceneRenderer>)renderer didRenderScene:(SCNScene *)scene atTime:(NSTimeInterval)time{
    
    
}



@end
