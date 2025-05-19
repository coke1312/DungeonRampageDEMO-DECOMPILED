package GeneratedCode
{
   import NetworkCode.DcNetworkPacket;
   
   public class DungeonTileUsage
   {
      
      public var x:int;
      
      public var y:int;
      
      public var tileId:String;
      
      public function DungeonTileUsage()
      {
         super();
      }
      
      public static function readFromPacket(param1:DcNetworkPacket) : DungeonTileUsage
      {
         var _loc2_:DungeonTileUsage = new DungeonTileUsage();
         _loc2_.x = param1.readInt();
         _loc2_.y = param1.readInt();
         _loc2_.tileId = param1.readUTF();
         return _loc2_;
      }
      
      public function writeToPacket(param1:DcNetworkPacket) : void
      {
         param1.writeInt(x);
         param1.writeInt(y);
         param1.writeUTF(tileId);
      }
   }
}

