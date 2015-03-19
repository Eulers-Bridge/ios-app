//
//  EBPollAnswerTableViewCell.m
//  Isegoria
//
//  Created by Alan Gao on 6/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBPollAnswerTableViewCell.h"

@implementation EBPollAnswerTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    
}

- (void)showResult
{
    if (self.voted) {
        self.tickImageView.image = [UIImage imageNamed:@"Tick"];
    } else {
        self.tickImageView.image = [UIImage imageNamed:@"Tick Disabled"];
    }
    double votes = [self.result[@"votes"] doubleValue];
    double totalVotes = [self.result[@"totalVotes"] doubleValue];
    CGFloat percentage = votes/totalVotes;
 
    CGFloat width = percentage * self.progressViewFrame.bounds.size.width;
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.progressView.frame;
        frame.size.width = width;
        self.progressView.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.voted) {
                // Another animation
            }

        }
    }];
    
    // Add transition (must be called after myLabel has been displayed)
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.type = kCATransitionFade;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.resultNumberLabel.layer addAnimation:animation forKey:@"changeTextTransition"];
    
    
    self.resultNumberLabel.text = [NSString stringWithFormat:@"%ld, %ld",
                                   (long)votes,
                                   (long)totalVotes];

}

- (void)refreshData
{
    self.answerTitleLabel.text = self.answer;
    self.progressViewFrame.backgroundColor = [UIColor clearColor];
    self.progressViewFrame.layer.borderWidth = 1.0;
    self.progressViewFrame.layer.borderColor = [self.baseColor CGColor];
    self.progressView.backgroundColor = self.baseColor;
    
}

//-(id)awakeAfterUsingCoder:(NSCoder *)aDecoder
//{
//    
//    
//    return [super awakeAfterUsingCoder:aDecoder];
//}

-(void)prepareForReuse
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
