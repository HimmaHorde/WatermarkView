//
//  WatermarkView.m
//  Demo
//
//  Created by yanglin on 2018/8/14.
//  Copyright © 2018 yanglin. All rights reserved.
//

#import "WatermarkView.h"

#define HORIZONTAL_SPACE 30//水平间距
#define VERTICAL_SPACE 50//竖直间距
#define CG_TRANSFORM_ROTATION (M_PI_2 / 3)//旋转角度(正旋45度 || 反旋45度)

@implementation WatermarkView

- (instancetype)initWithFrame:(CGRect)frame WithText:(NSString *)markText{
    if(self = [super initWithFrame:frame]){
        
        UIFont *font = [UIFont systemFontOfSize:14];
        
        UIColor *color = [UIColor colorWithRed:152./255.f green:152./255.f blue:152./255.f alpha:.15];
        
        //原始image的宽高
        CGFloat viewWidth = frame.size.width;
        CGFloat viewHeight = frame.size.height;
        
        //为了防止图片失真，绘制区域宽高和原始图片宽高一样
        UIGraphicsBeginImageContext(CGSizeMake(viewWidth, viewHeight));
        
        //sqrtLength：原始image的对角线length。在水印旋转矩阵中只要矩阵的宽高是原始image的对角线长度，无论旋转多少度都不会有空白。
        CGFloat sqrtLength = sqrt(viewWidth*viewWidth + viewHeight*viewHeight);
        //文字的属性
        NSDictionary *attr = @{
                               //设置字体大小
                               NSFontAttributeName: font,
                               //设置文字颜色
                               NSForegroundColorAttributeName :color,
                               };
        NSString* mark = markText;
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:mark attributes:attr];
        //绘制文字的宽高
        CGFloat strWidth = attrStr.size.width;
        CGFloat strHeight = attrStr.size.height;
        
        //开始旋转上下文矩阵，绘制水印文字
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //将绘制原点（0，0）调整到原image的中心
        CGContextConcatCTM(context, CGAffineTransformMakeTranslation(viewWidth/2, viewHeight/2));
        //以绘制原点为中心旋转
        CGContextConcatCTM(context, CGAffineTransformMakeRotation(CG_TRANSFORM_ROTATION));
        //将绘制原点恢复初始值，保证当前context中心和源image的中心处在一个点(当前context已经旋转，所以绘制出的任何layer都是倾斜的)
        CGContextConcatCTM(context, CGAffineTransformMakeTranslation(-viewWidth/2, -viewHeight/2));
        
        //计算需要绘制的列数和行数
        int horCount = sqrtLength / (strWidth + HORIZONTAL_SPACE) + 1;
        int verCount = sqrtLength / (strHeight + VERTICAL_SPACE) + 1;
        
        //此处计算出需要绘制水印文字的起始点，由于水印区域要大于图片区域所以起点在原有基础上移
        CGFloat orignX = -(sqrtLength-viewWidth)/2;
        CGFloat orignY = -(sqrtLength-viewHeight)/2;
        
        //在每列绘制时X坐标叠加
        CGFloat tempOrignX = orignX;
        //在每行绘制时Y坐标叠加
        CGFloat tempOrignY = orignY;
        for (int i = 0; i < horCount * verCount; i++) {
            [mark drawInRect:CGRectMake(tempOrignX, tempOrignY, strWidth, strHeight) withAttributes:attr];
            if (i % horCount == 0 && i != 0) {
                tempOrignX = orignX;
                tempOrignY += (strHeight + VERTICAL_SPACE);
            }else{
                tempOrignX += (strWidth + HORIZONTAL_SPACE);
            }
        }
        //根据上下文制作成图片
        UIImage *finalImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGContextRestoreGState(context);
        
        self.image = finalImg;
    }
    
    return self;
}

@end
