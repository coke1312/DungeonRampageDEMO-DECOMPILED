package GeneratedCode
{
   import NetworkCode.DcNetworkPacket;
   
   public class DungeonModifier
   {
      
      public var id:uint;
      
      public var new_this_floor:uint;
      
      public function DungeonModifier()
      {
         super();
      }
      
      public static function readFromPacket(param1:DcNetworkPacket) : DungeonModifier
      {
         var _loc2_:DungeonModifier = new DungeonModifier();
         _loc2_.id = param1.readUnsignedInt();
         _loc2_.new_this_floor = param1.readUnsignedByte();
         return _loc2_;
      }
      
      public function writeToPacket(param1:DcNetworkPacket) : void
      {
         param1.writeUnsignedInt(id);
         param1.writeByte(new_this_floor);
      }
   }
}

