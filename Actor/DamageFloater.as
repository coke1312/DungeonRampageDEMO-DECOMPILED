package Actor
{
   import Facade.DBFacade;
   import GameMasterDictionary.GMBuffColorType;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   
   public class DamageFloater extends FloatingMessage
   {
      
      private static const FLOAT_HEIGHT:Number = 80;
      
      private static const DEFAULT_SCALE:Number = 1;
      
      private static const SFX_SWF:String = "Resources/Art2D/FX/db_fx_library.swf";
      
      private static const BEST_MC:String = "db_fx_hit_sweet";
      
      private static const BETTER_MC:String = "db_fx_hit_super";
      
      private static const NORMAL_MC:String = "db_fx_hit_bang";
      
      private static const WORSE_MC:String = "db_fx_hit_weak";
      
      private static const WORST_MC:String = "db_fx_hit_fail";
      
      private static const BEST_HEX_VALUE:uint = 16750592;
      
      private static const BETTER_HEX_VALUE:uint = 16737536;
      
      private static const NORMAL_HEX_VALUE:uint = 16777113;
      
      private static const CRITICAL_HEX_VALUE:uint = 16750848;
      
      private static const HEAL_HEX_VALUE:uint = 2293538;
      
      private static const MANA_HEX_VALUE:uint = 9065403;
      
      private static const WORSE_HEX_VALUE:uint = 15029422;
      
      private static const WORST_HEX_VALUE:uint = 11613062;
      
      private static const CRIT_FILTER:GlowFilter = new GlowFilter(16777062,1,0.4,0.4,30,1);
      
      private var mActor:ActorGameObject;
      
      private var mFloaterText:MovieClip;
      
      private var mBmp:Bitmap;
      
      private var mBmpData:BitmapData;
      
      private var mType:uint;
      
      public function DamageFloater(param1:DBFacade, param2:Number, param3:ActorGameObject, param4:uint, param5:uint, param6:Number, param7:Number, param8:Function, param9:Boolean, param10:Boolean, param11:Boolean = true, param12:Boolean = false, param13:int = 0, param14:uint = 0, param15:String = "DAMAGE_MOVEMENT_TYPE")
      {
         mActor = param3;
         mDBFacade = param1;
         mType = param14;
         setup(param12,param2,param9,param10,param11,param13);
         var _loc16_:DisplayObject = param11 ? mBmp : mFloaterText;
         super(_loc16_,param1,param4,param5,param6,param7,mFloatDirection,param8,param15);
         mDBFacade.sceneGraphManager.addChild(mRoot,30);
      }
      
      private function showEffectivenessFX(param1:int) : void
      {
         var _loc6_:String = null;
         if(mActor.isHeroType || mActor.effectivenessShown == false)
         {
            mActor.effectivenessShown = true;
            var _loc3_:String = DBFacade.buildFullDownloadPath("Resources/Art2D/FX/db_fx_library.swf");
            switch(param1 - -2)
            {
               case 0:
                  _loc6_ = "db_fx_hit_fail";
                  break;
               case 1:
                  _loc6_ = "db_fx_hit_weak";
                  break;
               case 2:
                  _loc6_ = "db_fx_hit_bang";
                  break;
               case 3:
                  _loc6_ = "db_fx_hit_super";
                  break;
               case 4:
                  _loc6_ = "db_fx_hit_sweet";
            }
            var _loc2_:Vector3D = new Vector3D(mActor.view.root.x,mActor.view.root.y - 80,0);
            var _loc4_:Number = 1;
            var _loc5_:Number = 0;
            mActor.distributedDungeonFloor.effectManager.playEffect(_loc3_,_loc6_,_loc2_,null,false,_loc4_,_loc5_,0,0,0,false,"foreground");
            return;
         }
      }
      
      private function getEffectivenessTextColor(param1:int) : uint
      {
         switch(param1 - -2)
         {
            case 0:
               return 11613062;
            case 1:
               return 15029422;
            case 2:
               return 16777113;
            case 3:
               return 16737536;
            case 4:
               return 16750592;
            default:
               return 16777113;
         }
      }
      
      private function setup(param1:Boolean, param2:Number, param3:Boolean, param4:Boolean, param5:Boolean, param6:int) : void
      {
         var _loc9_:* = 0;
         var _loc15_:String = null;
         var _loc10_:Vector3D = null;
         var _loc14_:GMBuffColorType = null;
         var _loc13_:Rectangle = null;
         var _loc7_:Matrix = null;
         mFloaterText = new mDBFacade.hud.floaterTextClass() as MovieClip;
         var _loc11_:Number = 1;
         var _loc12_:Number = 1;
         if(param2 < 0)
         {
            if(param3 || param4)
            {
               if(param4)
               {
                  _loc11_ = _loc12_ = 1;
               }
               else
               {
                  _loc11_ = _loc12_ = param1 ? 1 * 1.8 : 1;
               }
            }
            if(param1)
            {
               _loc15_ = param2.toString() + "!";
            }
            else
            {
               _loc15_ = param2.toString();
            }
            if(param4)
            {
               _loc9_ = 16711680;
               switch(int(mType) - 1)
               {
                  case 0:
                     _loc9_ = 65280;
                     break;
                  case 1:
                     _loc9_ = 9065403;
               }
            }
            else
            {
               _loc9_ = param1 ? 16750848 : getEffectivenessTextColor(param6);
            }
            if(mType > 10)
            {
               _loc14_ = mDBFacade.gameMaster.buffColorTypeById.itemFor(mType);
               _loc9_ = _loc14_.ColorHex;
            }
            _loc10_ = new Vector3D((Math.random() - 0.5) * 0.5,-1,0);
         }
         else
         {
            _loc15_ = "+" + param2.toString();
            _loc9_ = 9502608;
            if(param4)
            {
               _loc11_ = _loc12_ = 1 * 1.1;
               _loc9_ = 2293538;
               switch(int(mType) - 2)
               {
                  case 0:
                     _loc9_ = 9065403;
               }
            }
            _loc10_ = new Vector3D(0,-1,0);
         }
         mFloatDirection = _loc10_;
         mFloatDirection.normalize();
         var _loc8_:Number = Math.atan2(mFloatDirection.y,mFloatDirection.x) * 180 / 3.141592653589793 + 90;
         if(param6 != 0)
         {
            this.showEffectivenessFX(param6);
         }
         mFloaterText.label.text = _loc15_;
         mFloaterText.label.textColor = _loc9_;
         if(param1)
         {
            mFloaterText.filters = [CRIT_FILTER];
         }
         if(param5)
         {
            mBmpData = new BitmapData(mFloaterText.width,mFloaterText.height,true,0);
            _loc13_ = mFloaterText.getBounds(mFloaterText);
            _loc7_ = new Matrix();
            _loc7_.translate(-_loc13_.x,-_loc13_.y);
            mBmpData.draw(mFloaterText,_loc7_);
            mBmp = new Bitmap(mBmpData,"auto",true);
            mBmp.scaleX = _loc11_;
            mBmp.scaleY = _loc12_;
            mBmp.x = mActor.view.root.x - mBmp.width * 0.5;
            mBmp.y = mActor.view.root.y - 80;
            mBmp.rotation = _loc8_;
         }
         else
         {
            mFloaterText.scaleX = _loc11_;
            mFloaterText.scaleY = _loc12_;
            mFloaterText.x = mActor.view.root.x + mFloatDirection.x * 100;
            mFloaterText.y = mActor.view.root.y - 80;
            mFloaterText.rotation = _loc8_;
         }
      }
      
      override public function destroy() : void
      {
         if(mActor.view)
         {
            mDBFacade.sceneGraphManager.removeChild(mRoot);
         }
         if(mBmpData)
         {
            mBmpData.dispose();
         }
         mBmpData = null;
         mBmp = null;
         mActor = null;
         mFloaterText = null;
         super.destroy();
      }
   }
}

