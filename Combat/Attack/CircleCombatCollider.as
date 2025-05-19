package Combat.Attack
{
   import Actor.ActorGameObject;
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Common.Math.b2Transform;
   import Box2D.Dynamics.b2World;
   import Facade.DBFacade;
   
   public class CircleCombatCollider extends CombatCollider
   {
      
      private var mRadius:Number;
      
      public function CircleCombatCollider(param1:DBFacade, param2:ActorGameObject, param3:b2World, param4:Number)
      {
         mRadius = param4 / 50;
         super(param1,param2,param3);
      }
      
      override protected function buildShape() : void
      {
         var _loc1_:b2CircleShape = new b2CircleShape(mRadius);
         mB2Shape = _loc1_;
         mB2Transform = new b2Transform();
         if(mParentGameObject.distributedDungeonFloor.debugVisualizer != null)
         {
            mParentGameObject.distributedDungeonFloor.debugVisualizer.reportCircleAttack(mB2Transform,_loc1_);
         }
      }
   }
}

