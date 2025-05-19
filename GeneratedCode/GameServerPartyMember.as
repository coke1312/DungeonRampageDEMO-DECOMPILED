package GeneratedCode
{
   import NetworkCode.DcNetworkPacket;
   
   public class GameServerPartyMember
   {
      
      public var id:uint;
      
      public var status:int;
      
      public function GameServerPartyMember()
      {
         super();
      }
      
      public static function readFromPacket(param1:DcNetworkPacket) : GameServerPartyMember
      {
         var _loc2_:GameServerPartyMember = new GameServerPartyMember();
         _loc2_.id = param1.readUnsignedInt();
         _loc2_.status = param1.readByte();
         return _loc2_;
      }
      
      public function writeToPacket(param1:DcNetworkPacket) : void
      {
         param1.writeUnsignedInt(id);
         param1.writeByte(status);
      }
   }
}

