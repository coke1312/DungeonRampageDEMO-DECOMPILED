package Box2D.Dynamics
{
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.*;
   import Box2D.Common.Math.*;
   import Box2D.Dynamics.Contacts.*;
   import flash.display.Sprite;
   
   use namespace b2internal;
   
   public class b2DebugDraw
   {
      
      public static var e_shapeBit:uint = 1;
      
      public static var e_jointBit:uint = 2;
      
      public static var e_aabbBit:uint = 4;
      
      public static var e_pairBit:uint = 8;
      
      public static var e_centerOfMassBit:uint = 16;
      
      public static var e_controllerBit:uint = 32;
      
      private var m_drawFlags:uint;
      
      b2internal var m_sprite:Sprite;
      
      private var m_drawScale:Number = 1;
      
      private var m_lineThickness:Number = 1;
      
      private var m_alpha:Number = 1;
      
      private var m_fillAlpha:Number = 1;
      
      private var m_xformScale:Number = 1;
      
      public function b2DebugDraw()
      {
         super();
         this.m_drawFlags = 0;
      }
      
      public function SetFlags(param1:uint) : void
      {
         this.m_drawFlags = param1;
      }
      
      public function GetFlags() : uint
      {
         return this.m_drawFlags;
      }
      
      public function AppendFlags(param1:uint) : void
      {
         this.m_drawFlags |= param1;
      }
      
      public function ClearFlags(param1:uint) : void
      {
         this.m_drawFlags &= ~param1;
      }
      
      public function SetSprite(param1:Sprite) : void
      {
         this.b2internal::m_sprite = param1;
      }
      
      public function GetSprite() : Sprite
      {
         return this.b2internal::m_sprite;
      }
      
      public function SetDrawScale(param1:Number) : void
      {
         this.m_drawScale = param1;
      }
      
      public function GetDrawScale() : Number
      {
         return this.m_drawScale;
      }
      
      public function SetLineThickness(param1:Number) : void
      {
         this.m_lineThickness = param1;
      }
      
      public function GetLineThickness() : Number
      {
         return this.m_lineThickness;
      }
      
      public function SetAlpha(param1:Number) : void
      {
         this.m_alpha = param1;
      }
      
      public function GetAlpha() : Number
      {
         return this.m_alpha;
      }
      
      public function SetFillAlpha(param1:Number) : void
      {
         this.m_fillAlpha = param1;
      }
      
      public function GetFillAlpha() : Number
      {
         return this.m_fillAlpha;
      }
      
      public function SetXFormScale(param1:Number) : void
      {
         this.m_xformScale = param1;
      }
      
      public function GetXFormScale() : Number
      {
         return this.m_xformScale;
      }
      
      public function DrawPolygon(param1:Array, param2:int, param3:b2Color) : void
      {
         this.b2internal::m_sprite.graphics.lineStyle(this.m_lineThickness,param3.color,this.m_alpha);
         this.b2internal::m_sprite.graphics.moveTo(param1[0].x * this.m_drawScale,param1[0].y * this.m_drawScale);
         var _loc4_:int = 1;
         while(_loc4_ < param2)
         {
            this.b2internal::m_sprite.graphics.lineTo(param1[_loc4_].x * this.m_drawScale,param1[_loc4_].y * this.m_drawScale);
            _loc4_++;
         }
         this.b2internal::m_sprite.graphics.lineTo(param1[0].x * this.m_drawScale,param1[0].y * this.m_drawScale);
      }
      
      public function DrawSolidPolygon(param1:Vector.<b2Vec2>, param2:int, param3:b2Color) : void
      {
         this.b2internal::m_sprite.graphics.lineStyle(this.m_lineThickness,param3.color,this.m_alpha);
         this.b2internal::m_sprite.graphics.moveTo(param1[0].x * this.m_drawScale,param1[0].y * this.m_drawScale);
         this.b2internal::m_sprite.graphics.beginFill(param3.color,this.m_fillAlpha);
         var _loc4_:int = 1;
         while(_loc4_ < param2)
         {
            this.b2internal::m_sprite.graphics.lineTo(param1[_loc4_].x * this.m_drawScale,param1[_loc4_].y * this.m_drawScale);
            _loc4_++;
         }
         this.b2internal::m_sprite.graphics.lineTo(param1[0].x * this.m_drawScale,param1[0].y * this.m_drawScale);
         this.b2internal::m_sprite.graphics.endFill();
      }
      
      public function DrawCircle(param1:b2Vec2, param2:Number, param3:b2Color) : void
      {
         this.b2internal::m_sprite.graphics.lineStyle(this.m_lineThickness,param3.color,this.m_alpha);
         this.b2internal::m_sprite.graphics.drawCircle(param1.x * this.m_drawScale,param1.y * this.m_drawScale,param2 * this.m_drawScale);
      }
      
      public function DrawSolidCircle(param1:b2Vec2, param2:Number, param3:b2Vec2, param4:b2Color) : void
      {
         this.b2internal::m_sprite.graphics.lineStyle(this.m_lineThickness,param4.color,this.m_alpha);
         this.b2internal::m_sprite.graphics.moveTo(0,0);
         this.b2internal::m_sprite.graphics.beginFill(param4.color,this.m_fillAlpha);
         this.b2internal::m_sprite.graphics.drawCircle(param1.x * this.m_drawScale,param1.y * this.m_drawScale,param2 * this.m_drawScale);
         this.b2internal::m_sprite.graphics.endFill();
         this.b2internal::m_sprite.graphics.moveTo(param1.x * this.m_drawScale,param1.y * this.m_drawScale);
         this.b2internal::m_sprite.graphics.lineTo((param1.x + param3.x * param2) * this.m_drawScale,(param1.y + param3.y * param2) * this.m_drawScale);
      }
      
      public function DrawSegment(param1:b2Vec2, param2:b2Vec2, param3:b2Color) : void
      {
         this.b2internal::m_sprite.graphics.lineStyle(this.m_lineThickness,param3.color,this.m_alpha);
         this.b2internal::m_sprite.graphics.moveTo(param1.x * this.m_drawScale,param1.y * this.m_drawScale);
         this.b2internal::m_sprite.graphics.lineTo(param2.x * this.m_drawScale,param2.y * this.m_drawScale);
      }
      
      public function DrawTransform(param1:b2Transform) : void
      {
         this.b2internal::m_sprite.graphics.lineStyle(this.m_lineThickness,16711680,this.m_alpha);
         this.b2internal::m_sprite.graphics.moveTo(param1.position.x * this.m_drawScale,param1.position.y * this.m_drawScale);
         this.b2internal::m_sprite.graphics.lineTo((param1.position.x + this.m_xformScale * param1.R.col1.x) * this.m_drawScale,(param1.position.y + this.m_xformScale * param1.R.col1.y) * this.m_drawScale);
         this.b2internal::m_sprite.graphics.lineStyle(this.m_lineThickness,65280,this.m_alpha);
         this.b2internal::m_sprite.graphics.moveTo(param1.position.x * this.m_drawScale,param1.position.y * this.m_drawScale);
         this.b2internal::m_sprite.graphics.lineTo((param1.position.x + this.m_xformScale * param1.R.col2.x) * this.m_drawScale,(param1.position.y + this.m_xformScale * param1.R.col2.y) * this.m_drawScale);
      }
   }
}

