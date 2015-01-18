//
//  toggleButtons.m
//  Marco Polo
//
//  Created by Daniel Nasello on 1/12/15.
//  Copyright (c) 2015 Combustion Innovation Group. All rights reserved.
//

#import "toggleButtons.h"

@implementation toggleButtons

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createTabs];
    }
    return self;
}

-(void)createTabs
{
    self.toggleButtons = [[NSMutableArray alloc]init];
    self.currentSelected = 1;
    
    UIImage *pressed = [self imageWithColor:[UIColor colorWithRed:0.188 green:0.678 blue:0.388 alpha:1] /*#30ad63*/];
    UIImage *pressedinter = [self imageWithColor:[UIColor colorWithRed:0.188 green:0.678 blue:0.388 alpha:1] /*#30ad63*/];
    UIImage *notpressed = [self imageWithColor:[UIColor colorWithRed:0.224 green:0.792 blue:0.455 alpha:1] /*#39ca74*/];
    
    NSArray *tabWords = [[NSArray alloc]init];
    tabWords = @[@"Kimoeters",@"Miles"];
    int i = 0;
    for(NSString *label in tabWords)
    {
     
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.frame = CGRectMake((self.frame.size.width/2) * i, 0, self.frame.size.width/2, self.frame.size.height);
    // [b setTitle:label forState:UIControlStateNormal];
        b.titleLabel.font = [UIFont systemFontOfSize:15];
        b.clipsToBounds = YES;
        b.tag = i;
        b.layer.cornerRadius = 0.0f;
        [b setAttributedTitle:[[NSAttributedString alloc] initWithString:[tabWords objectAtIndex:i] attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}]  forState:UIControlStateSelected];
        [b setAttributedTitle:[[NSAttributedString alloc] initWithString:[tabWords objectAtIndex:i] attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}]  forState:UIControlStateHighlighted];
        [b setAttributedTitle:[[NSAttributedString alloc] initWithString:[tabWords objectAtIndex:i] attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}]  forState:UIControlStateNormal];
        [b addTarget:self action:@selector(toogleTheButton:) forControlEvents:UIControlEventTouchUpInside];
        [b.titleLabel setFont:[UIFont fontWithName:@"GillSans" size:13.0]];
        [b setBackgroundImage:notpressed forState:UIControlStateNormal];
        [b setBackgroundImage:pressedinter forState:UIControlStateHighlighted];
        [b setBackgroundImage:pressed forState:UIControlStateSelected];
        
 
        b.layer.cornerRadius = 0.0f;
        
        [self addSubview:b];
        [self.toggleButtons addObject:b];
        i++;
    }
    
    UIButton *initial = [self.toggleButtons objectAtIndex:self.currentSelected];
    initial.selected = YES;
    
    
}

-(UIImage *)imageWithColor:(UIColor *)color {
    //makes an image out of a UI color
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



-(void)toogleTheButton:(id)sender
{
    UIButton *b = (UIButton*)sender;
    if(b.tag !=self.currentSelected)
    {
        UIButton *goButton = [self.toggleButtons objectAtIndex:self.currentSelected];
        goButton.selected = NO;
        b.selected = YES;
        self.currentSelected = b.tag;
        //do delegation to let the controller know that the index of the tab changed.
        [self.delegate tabWasChanged:b.tag];
    }
}

-(void)toggleMyButton:(NSInteger)selectedValue
{
    UIButton *b  = [self.toggleButtons objectAtIndex:selectedValue];
    if(selectedValue != self.currentSelected)
    {
        UIButton *goButton = [self.toggleButtons objectAtIndex:self.currentSelected];
        goButton.selected = NO;
        b.selected = YES;
        self.currentSelected = b.tag;
        //do delegation to let the controller know that the index of the tab changed.
        [self.delegate tabWasChanged:b.tag];
    }
    
}


@end
