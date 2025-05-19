package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Facade.DBFacade;
   import com.greensock.TweenMax;
   
   public class GlowTimelineAction extends AttackTimelineAction
   {
      
      public static const TYPE:String = "glow";
      
      private var mDuration:Number;
      
      private var mGlowColor:String;
      
      private var mBlurX:uint;
      
      private var mBlurY:uint;
      
      private var mGlowStrength:Number;
      
      private var mAlpha:Number;
      
      public function GlowTimelineAction(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:Number, param5:String, param6:uint, param7:uint, param8:uint, param9:Number)
      {
         mDuration = param4;
         mGlowColor = param5;
         mBlurX = param6;
         mBlurY = param7;
         mGlowStrength = param8;
         mAlpha = param9;
         super(param1,param2,param3);
      }
      
      public static function buildFromJson(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:Object) : GlowTimelineAction
      {
         var _loc5_:Number = Number(param4.duration);
         var _loc6_:String = param4.color;
         var _loc9_:uint = uint(param4.blurX);
         var _loc8_:uint = uint(param4.blurY);
         var _loc7_:uint = uint(param4.strength);
         var _loc10_:Number = Number(param4.alpha);
         return new GlowTimelineAction(param1,param2,param3,_loc5_,_loc6_,_loc9_,_loc8_,_loc7_,_loc10_);
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         super.execute(param1);
         TweenMax.to(mActorView.body,mDuration,{"glowFilter":{
            "color":mGlowColor,
            "blurX":mBlurX,
            "blurY":mBlurY,
            "strength":mGlowStrength,
            "alpha":mAlpha,
            "quality":3,
            "remove":true
         }});
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
   }
}

