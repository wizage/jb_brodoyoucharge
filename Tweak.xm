@interface _UIBatteryView : UIView

@property (nonatomic,retain) CAShapeLayer * bodyLayer; 
@property (nonatomic,retain) CAShapeLayer * pinLayer;
@property (nonatomic,retain) CALayer * fillLayer; 
@property (nonatomic,retain) CAShapeLayer * batteryLayer;
@property (assign,nonatomic) double chargePercent; 

-(UIColor *)_batteryFillColor;

@end


%hook _UIBatteryView
%property (nonatomic, retain) CAShapeLayer * batteryLayer;

-(void)_commonInit{
	%orig;
	/*
	Init our battery layer and add it to the stack!
	*/
	self.batteryLayer = [[CAShapeLayer alloc] init];
	[self.bodyLayer addSublayer:self.batteryLayer];
}


-(void)_updateFillColor{
	/*
	Hide our fill layer. Can't remove it form the superview due to the bolt somehow requiring it.
	*/
	self.fillLayer.backgroundColor = [UIColor clearColor].CGColor;
	self.batteryLayer.strokeColor = [self _batteryFillColor].CGColor;
}

-(UIColor *) _batteryFillColor{
	/*
	Make it look better on white backgrounds
	*/
	UIColor *original = %orig;
	if ([original isEqual:[UIColor blackColor]]){
		return [UIColor whiteColor];
	} else {
		return original;
	}
}

-(UIColor *) bodyColor {
	/*
	Make it look better on white backgrounds
	*/
	UIColor *original = %orig;
	if ([original isEqual:[[UIColor blackColor] colorWithAlphaComponent:0.4]]){
		return [original colorWithAlphaComponent:1.0];
	} else {
		return original;
	}
}

-(void)layoutSubviews {
	/*
	Setup our path for drawing a circle.
	TODO: Add other shapes ;)
	*/

	CGMutablePathRef thePath = CGPathCreateMutable();
	CGPathAddArc(thePath, NULL, 6.7, 6.5, 5, -M_PI_2, M_PI_2*3, NO);
	CGPathCloseSubpath(thePath);

	%orig;
	/*
	Remove the pin layer
	*/
	[self.pinLayer removeFromSuperlayer];
	/*
	Setup the body layer
	*/
	[self.bodyLayer setPath:thePath];
	self.bodyLayer.lineWidth = 3;
	self.bodyLayer.fillColor = [UIColor clearColor].CGColor;
	self.bodyLayer.backgroundColor = [UIColor clearColor].CGColor;

	/*
	Setup the battery layer
	*/
	[self.batteryLayer setPath:thePath];
	self.batteryLayer.lineWidth = 2;
	self.batteryLayer.fillColor = [UIColor clearColor].CGColor;
	self.batteryLayer.backgroundColor = [UIColor clearColor].CGColor;
	self.batteryLayer.strokeColor = [self _batteryFillColor].CGColor;
	self.batteryLayer.strokeStart = 0;
	self.batteryLayer.strokeEnd = float(self.chargePercent);
	
	/*
	Don't forget to release!
	*/
	CGPathRelease(thePath);
}

%end