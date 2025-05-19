package GeneratedCode
{
   import DistributedObjects.DistributedTownFloor;
   import NetworkCode.DcNetworkClass;
   import NetworkCode.DcNetworkInterface;
   import NetworkCode.DcNetworkPacket;
   
   public class DistributedTownFloorNetworkComponent extends DcNetworkClass implements DcNetworkInterface
   {
      
      private var the_instance:DistributedTownFloor;
      
      public const FLID_tileLibrary:uint = 205;
      
      public const FLID_tiles:uint = 206;
      
      public function DistributedTownFloorNetworkComponent(param1:DistributedTownFloor, param2:GeneratedDcSocket, param3:uint)
      {
         super(param1,param2,param3);
         the_instance = param1;
      }
      
      public static function netFactory(param1:DcNetworkPacket, param2:GeneratedDcSocket, param3:uint) : DistributedTownFloorNetworkComponent
      {
         var _loc5_:DistributedTownFloor = new DistributedTownFloor(param2.facade,param3);
         var _loc4_:DistributedTownFloorNetworkComponent = new DistributedTownFloorNetworkComponent(_loc5_,param2,param3);
         _loc4_.generate(param1);
         _loc5_.setNetworkComponentDistributedTownFloor(_loc4_);
         _loc5_.postGenerate();
         return _loc4_;
      }
      
      override public function recvById(param1:DcNetworkPacket, param2:uint) : void
      {
         switch(int(param2) - 205)
         {
            case 0:
               recv_tileLibrary(param1);
               break;
            case 1:
               recv_tiles(param1);
               break;
            default:
               super.recvById(param1,param2);
         }
      }
      
      override public function generate(param1:DcNetworkPacket) : void
      {
         recv_tileLibrary(param1);
         recv_tiles(param1);
         recvByIdLoop(param1);
      }
      
      override public function destroy() : void
      {
         the_instance.destroy();
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
   }
}

