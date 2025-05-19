package GeneratedCode
{
   import NetworkCode.DcNetworkPacket;
   
   public class InfiniteRewardData
   {
      
      public var dooberId:uint;
      
      public var floorNumber:uint;
      
      public var status:int;
      
      public function InfiniteRewardData()
      {
         super();
      }
      
      public static function readFromPacket(param1:DcNetworkPacket) : InfiniteRewardData
      {
         var _loc2_:InfiniteRewardData = new InfiniteRewardData();
         _loc2_.dooberId = param1.readUnsignedInt();
         _loc2_.floorNumber = param1.readUnsignedShort();
         _loc2_.status = param1.readByte();
         return _loc2_;
      }
      
      public function writeToPacket(param1:DcNetworkPacket) : void
      {
         param1.writeUnsignedInt(dooberId);
         param1.writeShort(floorNumber);
         param1.writeByte(status);
      }
   }
}

