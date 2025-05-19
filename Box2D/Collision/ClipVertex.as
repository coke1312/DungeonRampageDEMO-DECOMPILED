package Box2D.Collision
{
   import Box2D.Common.Math.b2Vec2;
   
   public class ClipVertex
   {
      
      public var v:b2Vec2 = new b2Vec2();
      
      public var id:b2ContactID = new b2ContactID();
      
      public function ClipVertex()
      {
         super();
      }
      
      public function Set(param1:ClipVertex) : void
      {
         this.v.SetV(param1.v);
         this.id.Set(param1.id);
      }
   }
}

