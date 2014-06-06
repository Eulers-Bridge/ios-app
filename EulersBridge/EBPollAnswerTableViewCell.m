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
    double votes = [self.result[@"votes"] doubleValue] + (self.voted ? 1 : 0);
    double totalVotes = [self.result[@"totalVotes"] doubleValue] + (self.voted ? 1 : 0);
    CGFloat percentage = votes/totalVotes;
 
    CGFloat width = percentage * 320;
    
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
    self.answerTitleLabel.text = self.answer[@"title"];
    self.answerSubtitleLabel.text = self.answer[@"subtitle"];
    self.progressView.backgroundColor = self.baseColor;
    self.colorView.backgroundColor = self.baseColor;
    self.answerTitleLabel.textColor = self.baseColor;
    self.answerSubtitleLabel.textColor = self.baseColor;
    self.resultNumberLabel.backgroundColor = self.baseColor;
    
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
