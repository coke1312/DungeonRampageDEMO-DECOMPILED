package GeneratedCode
{
   import DistributedObjects.DistributedDungeonFloor;
   import NetworkCode.DcNetworkClass;
   import NetworkCode.DcNetworkInterface;
   import NetworkCode.DcNetworkPacket;
   
   public class DistributedDungeonFloorNetworkComponent extends DcNetworkClass implements DcNetworkInterface
   {
      
      private var the_instance:DistributedDungeonFloor;
      
      public const FLID_mapNodeId:uint = 192;
      
      public const FLID_coliseumTierConstant:uint = 193;
      
      public const FLID_tileLibrary:uint = 194;
      
      public const FLID_tiles:uint = 195;
      
      public const FLID_baseLining:uint = 196;
      
      public const FLID_introMovieSwfFilePath:uint = 197;
      
      public const FLID_introMovieAssetClassName:uint = 198;
      
      public const FLID_currentFloorNum:uint = 199;
      
      public const FLID_activeDungeonModifiers:uint = 200;
      
      public const FLID_show_text:uint = 201;
      
      public const FLID_play_sound:uint = 202;
      
      public const FLID_trigger_camera_zoom:uint = 203;
      
      public const FLID_trigger_camera_shake:uint = 204;
      
      public function DistributedDungeonFloorNetworkComponent(param1:DistributedDungeonFloor, param2:GeneratedDcSocket, param3:uint)
      {
         super(param1,param2,param3);
         the_instance = param1;
      }
      
      public static function netFactory(param1:DcNetworkPacket, param2:GeneratedDcSocket, param3:uint) : DistributedDungeonFloorNetworkComponent
      {
         var _loc5_:DistributedDungeonFloor = new DistributedDungeonFloor(param2.facade,param3);
         var _loc4_:DistributedDungeonFloorNetworkComponent = new DistributedDungeonFloorNetworkComponent(_loc5_,param2,param3);
         _loc4_.generate(param1);
         _loc5_.setNetworkComponentDistributedDungeonFloor(_loc4_);
         _loc5_.postGenerate();
         return _loc4_;
      }
      
      override public function recvById(param1:DcNetworkPacket, param2:uint) : void
      {
         switch(int(param2) - 192)
         {
            case 0:
               recv_mapNodeId(param1);
               break;
            case 1:
               recv_coliseumTierConstant(param1);
               break;
            case 2:
               recv_tileLibrary(param1);
               break;
            case 3:
               recv_tiles(param1);
               break;
            case 4:
               recv_baseLining(param1);
               break;
            case 5:
               recv_introMovieSwfFilePath(param1);
               break;
            case 6:
               recv_introMovieAssetClassName(param1);
               break;
            case 7:
               recv_currentFloorNum(param1);
               break;
            case 8:
               recv_activeDungeonModifiers(param1);
               break;
            case 9:
               recv_show_text(param1);
               break;
            case 10:
               recv_play_sound(param1);
               break;
            case 11:
               recv_trigger_camera_zoom(param1);
               break;
            case 12:
               recv_trigger_camera_shake(param1);
               break;
            default:
               super.recvById(param1,param2);
         }
      }
      
      override public function generate(param1:DcNetworkPacket) : void
      {
         recv_mapNodeId(param1);
         recv_coliseumTierConstant(param1);
         recv_tileLibrary(param1);
         recv_tiles(param1);
         recv_baseLining(param1);
         recv_introMovieSwfFilePath(param1);
         recv_introMovieAssetClassName(param1);
         recv_currentFloorNum(param1);
         recv_activeDungeonModifiers(param1);
         recvByIdLoop(param1);
      }
      
      override public function destroy() : void
      {
         the_instance.destroy();
      }
      
      public function recv_mapNodeId(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedInt();
         the_instance.mapNodeId = _loc2_;
      }
      
      public function recv_coliseumTierConstant(param1:DcNetworkPacket) : void
      {
         var _loc2_:String = param1.readUTF();
         the_instance.coliseumTierConstant = _loc2_;
      }
      
      public function recv_tileLibrary(param1:DcNetworkPacket) : void
      {
         var _loc2_:String = param1.readUTF();
         the_instance.tileLibrary(_loc2_);
      }
      
      public function recv_tiles(param1:DcNetworkPacket) : void
      {
         var packet:DcNetworkPacket = param1;
         var tiles:Vector.<DungeonTileUsage> = (function(param1:DcNetworkPacket):Vector.<DungeonTileUsage>
         {
            var _loc5_:DungeonTileUsage = null;
            var _loc3_:Vector.<DungeonTileUsage> = new Vector.<DungeonTileUsage>();
            var _loc2_:uint = param1.readUnsignedShort();
            var _loc4_:uint = _loc2_ + param1.position;
            while(param1.position < _loc4_)
            {
               _loc5_ = DungeonTileUsage.readFromPacket(param1);
               _loc3_.push(_loc5_);
            }
            return _loc3_;
         })(packet);
         the_instance.tiles(tiles);
      }
      
      public function recv_baseLining(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedByte();
         the_instance.baseLining = _loc2_;
      }
      
      public function recv_introMovieSwfFilePath(param1:DcNetworkPacket) : void
      {
         var _loc2_:String = param1.readUTF();
         the_instance.introMovieSwfFilePath = _loc2_;
      }
      
      public function recv_introMovieAssetClassName(param1:DcNetworkPacket) : void
      {
         var _loc2_:String = param1.readUTF();
         the_instance.introMovieAssetClassName = _loc2_;
      }
      
      public function recv_currentFloorNum(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedShort();
         the_instance.currentFloorNum = _loc2_;
      }
      
      public function recv_activeDungeonModifiers(param1:DcNetworkPacket) : void
      {
         var packet:DcNetworkPacket = param1;
         var v_activeDungeonModifiers:Vector.<DungeonModifier> = (function(param1:DcNetworkPacket):Vector.<DungeonModifier>
         {
            var _loc5_:DungeonModifier = null;
            var _loc3_:Vector.<DungeonModifier> = new Vector.<DungeonModifier>();
            var _loc2_:uint = param1.readUnsignedShort();
            var _loc4_:uint = _loc2_ + param1.position;
            while(param1.position < _loc4_)
            {
               _loc5_ = DungeonModifier.readFromPacket(param1);
               _loc3_.push(_loc5_);
            }
            return _loc3_;
         })(packet);
         the_instance.activeDungeonModifiers = v_activeDungeonModifiers;
      }
      
      public function recv_show_text(param1:DcNetworkPacket) : void
      {
         var _loc2_:String = param1.readUTF();
         the_instance.show_text(_loc2_);
      }
      
      public function recv_play_sound(param1:DcNetworkPacket) : void
      {
         var _loc2_:String = param1.readUTF();
         the_instance.play_sound(_loc2_);
      }
      
      public function recv_trigger_camera_zoom(param1:DcNetworkPacket) : void
      {
         var _loc2_:Number = param1.readFloat();
         the_instance.trigger_camera_zoom(_loc2_);
      }
      
      public function recv_trigger_camera_shake(param1:DcNetworkPacket) : void
      {
         var _loc2_:Number = param1.readFloat();
         var _loc3_:Number = param1.readFloat();
         var _loc4_:uint = param1.readUnsignedByte();
         the_instance.trigger_camera_shake(_loc2_,_loc3_,_loc4_);
      }
   }
}

