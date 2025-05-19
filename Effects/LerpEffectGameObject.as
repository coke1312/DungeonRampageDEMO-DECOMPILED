package Effects
{
   import Actor.ActorGameObject;
   import Brain.Event.EventComponent;
   import Facade.DBFacade;
   import com.greensock.TimelineMax;
   import com.greensock.TweenMax;
   import com.greensock.easing.Circ;
   import com.greensock.easing.Sine;
   import flash.events.Event;
   import flash.geom.Vector3D;
   
   public class LerpEffectGameObject extends EffectGameObject
   {
      
      private var mLerpTargetActor:ActorGameObject;
      
      private var mLerpSpeed:Number;
      
      public var mLerpTempSpeed:Number;
      
      private var mLerpTimeline:TimelineMax;
      
      private var mLerpTargetPositionVector:Vector3D;
      
      private var mLerpGlowColor:uint;
      
      private var mEventComponent:EventComponent;
      
      public function LerpEffectGameObject(param1:DBFacade, param2:String, param3:String, param4:Number, param5:uint = 0, param6:Function = null, param7:ActorGameObject = null, param8:Number = 1, param9:uint = 13369344)
      {
         var facade:DBFacade = param1;
         var swfPath:String = param2;
         var className:String = param3;
         var playRate:Number = param4;
         var remoteId:uint = param5;
         var assetLoadedCallback:Function = param6;
         var lerpToActor:ActorGameObject = param7;
         var lerpSpeed:Number = param8;
         var lerpGlowColor:uint = param9;
         super(facade,swfPath,className,playRate,remoteId,assetLoadedCallback);
         mLerpTargetActor = lerpToActor;
         mLerpSpeed = lerpSpeed + Math.random() * lerpSpeed / 2;
         mLerpGlowColor = lerpGlowColor;
         mLerpTargetPositionVector = new Vector3D(0,-50,0);
         mEventComponent = new EventComponent(facade);
         mEventComponent.addListener("enterFrame",update);
         mLerpTempSpeed = 0;
         mLerpTimeline = new TimelineMax();
         mLerpTimeline.append(new TweenMax(this,0.1,{
            "mLerpTempSpeed":-mLerpSpeed,
            "onComplete":function():void
            {
               mLerpTempSpeed = 0;
            }
         }));
         mLerpTimeline.append(new TweenMax(this,0.65,{
            "mLerpTempSpeed":mLerpSpeed,
            "ease":Circ.easeIn
         }));
         mLerpTimeline.play();
      }
      
      private function update(param1:Event) : void
      {
         var _loc3_:Vector3D = null;
         var _loc4_:Vector3D = null;
         var _loc2_:Number = NaN;
         if(mLerpTargetActor && mLerpTargetActor.position)
         {
            _loc3_ = mLerpTargetActor.position.add(mLerpTargetPositionVector);
            _loc4_ = _loc3_.subtract(mEffectView.position);
            _loc2_ = _loc4_.length;
            _loc4_.normalize();
            _loc4_.scaleBy(mLerpTempSpeed);
            mEffectView.position = mEffectView.position.add(_loc4_);
            if(_loc2_ < 15)
            {
               TweenMax.to(mLerpTargetActor.actorView.body,0.05,{"glowFilter":{
                  "color":mLerpGlowColor,
                  "alpha":1,
                  "blurX":15,
                  "blurY":15,
                  "remove":true,
                  "ease":Sine.easeInOut
               }});
               destroy();
            }
         }
         else
         {
            destroy();
         }
      }
      
      override public function destroy() : void
      {
         mEventComponent.removeListener("enterFrame");
         super.destroy();
      }
   }
}

