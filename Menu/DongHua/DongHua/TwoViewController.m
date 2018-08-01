//
//  TwoViewController.m
//  DongHua
//
//  Created by mac on 14-8-26.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "TwoViewController.h"

@interface TwoViewController ()
{
    //拖动时用到的属性，记录最后的选中button的tag
    int tmptag ;
    
}

@property(nonatomic,strong)NSMutableArray * myRects;//存放所有的view
@property(nonatomic,strong)NSMutableArray * frames;//存放view的标准位置
@property(nonatomic,assign)int flag;
@end

@implementation TwoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.flag = 3;
    
    //设置特殊标志，若是tmptag为100，则
    tmptag = 100;
    
    
    //初始化两个数组
    self.myRects = [NSMutableArray arrayWithCapacity:10];
    self.frames = [NSMutableArray arrayWithCapacity:10];
    
    
    //初始化页面，加9宫格
    for (int i = 0; i < 9; i++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(30 + i%3 * 85, 100 + i/3 * 85, 80, 80 );
        button.layer.cornerRadius = 5;
        button.tag = i;
        button.backgroundColor = [UIColor brownColor];
        
        [button setTitle:[NSString stringWithFormat:@"btn %d",i] forState:UIControlStateNormal];
        [self.myRects addObject:button];
        
        NSString * str = [NSString stringWithFormat:@"%@",NSStringFromCGRect(button.frame)];
        [self.frames addObject:str];

        
        [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        
        //长按手势
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressTap:)];
        [button addGestureRecognizer:longPress];
        
//        //拖动手势
//        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragButton:)];
//        [button addGestureRecognizer:pan];
        
        
        [self.view addSubview:button];
        
        
        //给背景view加点击事件，用于终止选中动画
        UITapGestureRecognizer * tapView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
        [self.view addGestureRecognizer:tapView];
    }

}


/*
//拖动手势的回调方法
-(void)dragButton:(UIPanGestureRecognizer*)pan
{
    //NSLog(@"drag");
    //获取手势在该视图上得偏移量
    CGPoint translation = [pan translationInView:self.view];
    
    //一下分别为拖动时的三种状态：开始，变化，结束
    if (pan.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"drag begin");
        //开始时拖动的view更改透明度
        pan.view.alpha = 0.7;
        NSLog(@"ppppp %d",pan.view.tag);
        //若是拖动自动填充，加了一个开始拖动的时候缩小的效果
        if (self.flag ==3)
        {
            CGAffineTransform t = CGAffineTransformMakeScale(0.5,0.5);
            pan.view.transform = t;
        }


        [self.view bringSubviewToFront:pan.view];
    }
    else if(pan.state == UIGestureRecognizerStateChanged)
    {
        NSLog(@"drag change");
        //使拖动的view跟随手势移动
        pan.view.center = CGPointMake(pan.view.center.x + translation.x,
                                      pan.view.center.y + translation.y);
        [pan setTranslation:CGPointZero inView:self.view];
        
        //遍历9个view看移动到了哪个view区域，使其为选中状态.并更新选中view的tag值，使其永远为最新的
        for (int i = 0; i< self.myRects.count; i++)
        {
            UIButton * btn = self.myRects[i];
            NSString* tmprect = self.frames[i];
            if (CGRectContainsPoint(CGRectFromString(tmprect), pan.view.center))
            {
                
                tmptag = btn.tag;
                NSLog(@"tmptag ==> %d",tmptag);
                btn.layer.borderWidth = 3;
                btn.layer.borderColor = [[UIColor redColor]CGColor];
                //return;
                
                //自动换
                if (self.flag == 3)
                {
                    [UIView animateWithDuration:1 animations:^{
                        if (pan.view.tag != tmptag)
                        {
                            pan.view.alpha = 1;
                            NSString * rect2 = self.frames[pan.view.tag];
                            btn.frame = CGRectFromString(rect2);
                            int tmp = pan.view.tag;
                            pan.view.tag = tmptag;
                            btn.tag = tmp;
                            [self.myRects exchangeObjectAtIndex:pan.view.tag withObjectAtIndex:btn.tag];
                        }
                    } completion:^(BOOL finished)
                     {
                         NSLog(@"中间步骤");
                     }];
                    
                }
                
                
            }
            else
            {
                btn.layer.borderWidth = 0;
                btn.layer.borderColor = [[UIColor clearColor]CGColor];
            }
        }
        
        
    }
    else if (pan.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"drag end");
        //拖动结束的时候，将拖动的view的透明度还原
        pan.view.alpha = 1;
        
        //若是拖动自动填充，加了一个开始拖动的时候缩小的效果，此处为还原
        if (self.flag == 3)
        {
            CGAffineTransform t = CGAffineTransformMakeScale(1,1);
            pan.view.transform = t;
        }
        
        [UIView animateWithDuration:1 animations:^
         {
             //结束时将选中view的边框还原
             UIButton * btn = self.myRects[tmptag];
             btn.layer.borderWidth = 0;
             btn.layer.borderColor = [[UIColor clearColor]CGColor];
             
             //获取需要交换的两个view的frame，并交换
             NSString * rect1 = self.frames[btn.tag];
             NSString * rect2 = self.frames[pan.view.tag];
             NSLog(@"rect1 %d  %d",btn.tag,pan.view.tag);
             //自动换
             if (self.flag == 3)
             {
                 pan.view.frame = CGRectFromString(rect1);
                 
                 //并交换其tag值及在数组中得位置
                 pan.view.tag = tmptag;
                 //NSLog(@"%d  %d",pan.view.tag,btn.tag);
             }
             else
             {
                 pan.view.frame = CGRectFromString(rect1);
                 btn.frame = CGRectFromString(rect2);
                 
                 //并交换其tag值及在数组中得位置
                 int tmp = pan.view.tag;
                 pan.view.tag = tmptag;
                 btn.tag = tmp;
                 NSLog(@"%d  %d",pan.view.tag,btn.tag);
                 
             }
             
             
             
             [self.myRects exchangeObjectAtIndex:pan.view.tag withObjectAtIndex:btn.tag];
             
             
         } completion:^(BOOL finished)
         {
             NSLog(@"已交换");
             //完成动画后还原btn的状态
             for (int i = 0; i< self.myRects.count; i++)
             {
                 
                 UIButton * btn = self.myRects[i];
                 btn.layer.borderColor = [[UIColor clearColor]CGColor];
                 btn.layer.borderWidth = 0;
                 NSLog(@"ttttr%d",btn.tag);
             }
         }];
        
    }
    
}
*/

//点击view的时候，所有button都收回去
-(void)tapView
{
    NSLog(@"tapview");
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^
     {
         CGAffineTransform t = CGAffineTransformMakeScale(1,1);
         for (UIView * view in self.view.subviews)
         {
             view.transform = t;
             [view.layer removeAnimationForKey:@"long"];
         }
     } completion:^(BOOL finished)
     {
         NSLog(@"完成");
     }];
}


//当点击button的时候放大，凸出来
-(void)tapButton:(UIButton *)button
{
    NSLog(@"%d",button.tag);
    
    
    //当点击的button时，使其他已经凸出来的button缩回去
    for (UIView * view in self.view.subviews)
    {
        if (view.frame.size.height != 80)
        {
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^
             {
                 //视图缩放矩阵
                 CGAffineTransform t = CGAffineTransformMakeScale(1,1);
                 view.transform = t;
             } completion:^(BOOL finished)
             {
                 NSLog(@"完成！");
             }];
        }
        
    }
    
    
    
    //当点击button的时候放大，凸出来
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^
     {
         //视图缩放矩阵
         CGAffineTransform t2 = CGAffineTransformMakeScale(1.1,1.1);
         button.transform = t2;
         
     } completion:^(BOOL finished)
     {
         NSLog(@"完成！");
     }];
    
    
    
}


 
//长按手势的回调
-(void)longPressTap:(UILongPressGestureRecognizer  *)recognizer
{
    
    CGPoint translation = [recognizer locationInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"begin");
        NSLog(@"tagtag ==>%d",recognizer.view.tag);
        //抖动
        for (UIView * view in self.view.subviews)
        {
            CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            shake.fromValue = [NSNumber numberWithFloat:- 0.03];
            shake.toValue   = [NSNumber numberWithFloat:+ 0.03];
            shake.duration = 0.1;
            shake.autoreverses = YES;
            shake.repeatCount = MAXFLOAT;
            [view.layer addAnimation:shake forKey:@"long"];
        }
        
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        NSLog(@"changed");
        
        //使拖动的view跟随手势移动
        recognizer.view.center = translation;
        //遍历9个view看移动到了哪个view区域，使其为选中状态.并更新选中view的tag值，使其永远为最新的
        for (int i = 0; i< self.myRects.count; i++)
        {
            UIButton * btn = self.myRects[i];
            NSString* tmprect = self.frames[i];
            if (CGRectContainsPoint(CGRectFromString(tmprect), recognizer.view.center))
            {
                
                tmptag = btn.tag;
                NSLog(@"tmptag ==> %d",tmptag);
                btn.layer.borderWidth = 3;
                btn.layer.borderColor = [[UIColor redColor]CGColor];
                //return;
                
                //自动换
                if (self.flag == 3)
                {
                    [UIView animateWithDuration:1 animations:^{
                        if (recognizer.view.tag != tmptag)
                        {
                            recognizer.view.alpha = 1;
                            NSString * rect2 = self.frames[recognizer.view.tag];
                            btn.frame = CGRectFromString(rect2);
                            int tmp = recognizer.view.tag;
                            if (tmptag != 100)
                            {
                                recognizer.view.tag = tmptag;
                                btn.tag = tmp;
                                [self.myRects exchangeObjectAtIndex:recognizer.view.tag withObjectAtIndex:btn.tag];
                            }
                            
                            
                        }
                    } completion:^(BOOL finished)
                     {
                         NSLog(@"中间步骤");
                     }];
                    
                }
                
                
                
            }
            else
            {
                btn.layer.borderWidth = 0;
                btn.layer.borderColor = [[UIColor clearColor]CGColor];
            }
        }

        
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"end");
        
        //若是100则是没有移动的，不进行处理
        if (tmptag != 100)
        {
            [UIView animateWithDuration:1 animations:^
             {
                 //结束时将选中view的边框还原
                 UIButton * btn = self.myRects[tmptag];
                 btn.layer.borderWidth = 0;
                 btn.layer.borderColor = [[UIColor clearColor]CGColor];
                 
                 //获取需要交换的两个view的frame，并交换
                 NSString * rect1 = self.frames[btn.tag];
                 NSString * rect2 = self.frames[recognizer.view.tag];
                 
                 //自动换
                 if (self.flag == 3)
                 {
                     
                     recognizer.view.frame = CGRectFromString(rect1);
                     
                     //并交换其tag值及在数组中得位置
                     recognizer.view.tag = tmptag;
                     //NSLog(@"%d  %d",pan.view.tag,btn.tag);
                     tmptag = 100;
                     
                 }
                 else
                 {
                     
                     recognizer.view.frame = CGRectFromString(rect1);
                     btn.frame = CGRectFromString(rect2);
                     
                     
                     //并交换其tag值及在数组中得位置
                     int tmp = recognizer.view.tag;
                     recognizer.view.tag = tmptag;
                     btn.tag = tmp;
                     tmptag = 100;
                     
                     
                     //NSLog(@"p %d  b %d",recognizer.view.tag,btn.tag);
                     
                 }
                 
                 
                 
                 [self.myRects exchangeObjectAtIndex:recognizer.view.tag withObjectAtIndex:btn.tag];
                 
                 
                 
                 
             } completion:^(BOOL finished)
             {
                 NSLog(@"已交换");
                 //完成动画后还原btn的状态
                 for (int i = 0; i< self.myRects.count; i++)
                 {
                     
                     UIButton * btn = self.myRects[i];
                     btn.layer.borderColor = [[UIColor clearColor]CGColor];
                     btn.layer.borderWidth = 0;
                     NSLog(@"ttttr%d",btn.tag);
                     [btn.layer removeAnimationForKey:@"long"];
                     
                 }
             }];

            
        }
        
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
