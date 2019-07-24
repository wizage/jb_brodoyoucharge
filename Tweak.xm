@interface _UIBatteryView : UIView

@property (nonatomic,retain) CAShapeLayer * bodyLayer; 
@property (nonatomic,retain) CAShapeLayer * pinLayer;

@end


%hook _UIBatteryView

-(void)layoutSubviews {
	%orig;
	[self.pinLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 10, 10)] CGPath]];
	self.bodyLayer.sublayers = nil;
	CGMutablePathRef thePath = CGPathCreateMutable();
	CGPathAddArc(thePath, NULL, 6.7, 6.5, 5, -M_PI_2, M_PI_2*3, NO);
	CGPathCloseSubpath(thePath);
	
	[self.bodyLayer setPath:thePath];
	CAShapeLayer *percentCharge = [[CAShapeLayer alloc] init];
	[percentCharge setPath:thePath];
	self.bodyLayer.lineWidth = 2;
	self.bodyLayer.fillColor = [UIColor clearColor].CGColor;
	self.bodyLayer.backgroundColor = [UIColor clearColor].CGColor;
	percentCharge.lineWidth = 2;
	percentCharge.fillColor = [UIColor clearColor].CGColor;
	percentCharge.backgroundColor = [UIColor clearColor].CGColor;
	percentCharge.strokeColor = [UIColor whiteColor].CGColor;
	percentCharge.strokeStart = 0;
	percentCharge.strokeEnd = 0.5;
	[self.bodyLayer addSublayer:percentCharge];
}

%end