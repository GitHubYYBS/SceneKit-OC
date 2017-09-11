# SceneKit--OC
###```OC```-系列 
- 本系列Demo 是对SceneKit框架的解读与练习,具体知识来自于<3D iOS Games by Tutorials>一书和许海峰大神的系列文章.这里提供OC版的学习笔记和系列Demo
- [学习笔记地址](http://www.jianshu.com/nb/16248275)
- [OC代码地址](https://github.com/GitHubYYBS/SceneKit--OC)

###```Swift```--系列
- 另外在这里也提供来自 许海峰同学的Swift版笔记和系列代码
- [学习笔记地址](http://www.jianshu.com/nb/11408621)
- [Swift代码地址](https://github.com/XanderXu/3D-iOS-Games-by-Tutorials-code)

## 01 Hello SceneKit与渲染循环
![image](https://github.com/GitHubYYBS/SceneKit-OC/blob/master/1.Hello%20SceneKit%E4%B8%8E%E6%B8%B2%E6%9F%93%E5%BE%AA%E7%8E%AF.gif?raw=true)

- [Hello SceneKit与渲染循环学习笔记_之_Hello SceneKit](http://www.jianshu.com/p/e0ef96c54980)
- [Hello SceneKit与渲染循环学习笔记_之_physics物理效果](http://www.jianshu.com/p/9a98da14bde0)
- [Hello SceneKit与渲染循环学习笔记_之_Render Loop渲染循环](http://www.jianshu.com/p/7f832554b8b4)


## 02Particle Systems粒子系统
- ![Particle Systems粒子系统](https://github.com/GitHubYYBS/SceneKit-OC/blob/master/2.Particle%20Systems%E7%B2%92%E5%AD%90%E7%B3%BB%E7%BB%9F.gif?raw=true)

- [02Particle Systems粒子系统学习笔记](http://www.jianshu.com/p/6bae9414e0db)

关键代码:
````
- 1
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

- 2
 // 5.0创建一个粒子
    SCNParticleSystem * parrticleSystem = [self creatParticleSystemWithColor:color geometry:geometer];
    // 5.1 将该粒子 添加到节点上  有时候会发现 粒子未出现在屏幕中  可能的原因之一是 粒子的大小问题(我就遇到了)
    [geometerNode addParticleSystem:parrticleSystem];

````
