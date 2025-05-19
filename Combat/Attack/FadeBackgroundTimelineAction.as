package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Facade.DBFacade;
   import flash.geom.Vector3D;
   
   public class FadeBackgroundTimelineAction extends AttackTimelineAction
   {
      
      public static const TYPE:String = "fadebackground";
      
      private var mDuration:uint;
      
      private var mTransitionDuration:Number;
      
      private var mColor:Vector3D;
      
      private var mOffset:Number;
      
      private var mAlpha:Number;
      
      public function FadeBackgroundTimelineAction(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:uint, param5:Vector3D, param6:Number, param7:Number)
      {
         mDuration = param4;
         mTransitionDuration = param7;
         mColor = new Vector3D(param5.x,param5.y,param5.z);
         mAlpha = param6;
         mOffset = param6 / param7;
         super(param1,param2,param3);
      }
      
      public static function buildFromJson(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:Object) : FadeBackgroundTimelineAction
      {
         var _loc5_:uint = uint(param4.duration);
         var _loc6_:Vector3D = new Vector3D(param4.color_r,param4.color_g,param4.color_b);
         var _loc8_:Number = Number(param4.alpha);
         var _loc7_:Number = Number(param4.transitionDur);
         return new FadeBackgroundTimelineAction(param1,param2,param3,_loc5_,_loc6_,_loc8_,_loc7_);
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         if(!mActorGameObject.isOwner && !mDBFacade.camera.isPointOnScreen(mActorGameObject.position))
         {
            return;
         }
         super.execute(param1);
         var _loc2_:Array = [];
         _loc2_.push(mActorView.root);
         mDBFacade.camera.fadeBackground(_loc2_,mDuration,mTransitionDuration,mColor,mAlpha);
      }
      
      override public function stop() : void
      {
         mDBFacade.camera.killBackgroundFader();
      }
   }
}

