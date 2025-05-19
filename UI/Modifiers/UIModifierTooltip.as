package UI.Modifiers
{
   import Brain.AssetRepository.SwfAsset;
   import Brain.SceneGraph.SceneGraphComponent;
   import Facade.DBFacade;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class UIModifierTooltip extends MovieClip
   {
      
      public var mRoot:MovieClip;
      
      private var mSceneGraphComponent:SceneGraphComponent;
      
      public function UIModifierTooltip(param1:DBFacade, param2:MovieClip, param3:SwfAsset, param4:String, param5:String)
      {
         super();
         var _loc6_:Class = param3.getClass("modifier_tooltip");
         mRoot = new _loc6_() as MovieClip;
         mRoot.title_label.text = param4.toUpperCase();
         mRoot.title_description.text = param5;
         mRoot.mouseChildren = false;
         mRoot.mouseEnabled = false;
         param2.addChild(mRoot);
         var _loc7_:Point = param2.localToGlobal(new Point());
         mRoot.x = _loc7_.x;
         mRoot.y = _loc7_.y + 20;
         mSceneGraphComponent = new SceneGraphComponent(param1);
         mSceneGraphComponent.addChild(mRoot,107);
      }
      
      public function show() : void
      {
         mRoot.visible = true;
      }
      
      public function hide() : void
      {
         mRoot.visible = false;
      }
      
      public function destroy() : void
      {
         mSceneGraphComponent.destroy();
         mSceneGraphComponent = null;
         mRoot = null;
      }
   }
}

