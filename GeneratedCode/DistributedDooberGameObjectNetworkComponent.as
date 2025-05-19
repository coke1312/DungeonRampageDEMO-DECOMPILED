package GeneratedCode
{
   import Doobers.DistributedDooberGameObject;
   import NetworkCode.DcNetworkClass;
   import NetworkCode.DcNetworkInterface;
   import NetworkCode.DcNetworkPacket;
   import flash.geom.Vector3D;
   
   public class DistributedDooberGameObjectNetworkComponent extends DcNetworkClass implements DcNetworkInterface
   {
      
      private var the_instance:DistributedDooberGameObject;
      
      public const FLID_type:uint = 286;
      
      public const FLID_position:uint = 287;
      
      public const FLID_layer:uint = 288;
      
      public const FLID_spawnFrom:uint = 289;
      
      public const FLID_collectedBy:uint = 290;
      
      public function DistributedDooberGameObjectNetworkComponent(param1:DistributedDooberGameObject, param2:GeneratedDcSocket, param3:uint)
      {
         super(param1,param2,param3);
         the_instance = param1;
      }
      
      public static function netFactory(param1:DcNetworkPacket, param2:GeneratedDcSocket, param3:uint) : DistributedDooberGameObjectNetworkComponent
      {
         var _loc5_:DistributedDooberGameObject = new DistributedDooberGameObject(param2.facade,param3);
         var _loc4_:DistributedDooberGameObjectNetworkComponent = new DistributedDooberGameObjectNetworkComponent(_loc5_,param2,param3);
         _loc4_.generate(param1);
         _loc5_.setNetworkComponentDistributedDooberGameObject(_loc4_);
         _loc5_.postGenerate();
         return _loc4_;
      }
      
      override public function recvById(param1:DcNetworkPacket, param2:uint) : void
      {
         switch(int(param2) - 286)
         {
            case 0:
               recv_type(param1);
               break;
            case 1:
               recv_position(param1);
               break;
            case 2:
               recv_layer(param1);
               break;
            case 3:
               recv_spawnFrom(param1);
               break;
            case 4:
               recv_collectedBy(param1);
               break;
            default:
               super.recvById(param1,param2);
         }
      }
      
      override public function generate(param1:DcNetworkPacket) : void
      {
         recv_type(param1);
         recv_position(param1);
         recv_layer(param1);
         recvByIdLoop(param1);
      }
      
      override public function destroy() : void
      {
         the_instance.destroy();
      }
      
      public function recv_type(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedInt();
         the_instance.type = _loc2_;
      }
      
      public function recv_position(param1:DcNetworkPacket) : void
      {
         var packet:DcNetworkPacket = param1;
         var v_position:Vector3D = (function(param1:DcNetworkPacket):Vector3D
         {
            var _loc2_:Vector3D = new Vector3D();
            _loc2_.x = param1.readFloat();
            _loc2_.y = param1.readFloat();
            return _loc2_;
         })(packet);
         the_instance.position = v_position;
      }
      
      public function recv_layer(param1:DcNetworkPacket) : void
      {
         var _loc2_:int = param1.readByte();
         the_instance.layer = _loc2_;
      }
      
      public function recv_spawnFrom(param1:DcNetworkPacket) : void
      {
         var packet:DcNetworkPacket = param1;
         var loc:Vector3D = (function(param1:DcNetworkPacket):Vector3D
         {
            var _loc2_:Vector3D = new Vector3D();
            _loc2_.x = param1.readFloat();
            _loc2_.y = param1.readFloat();
            return _loc2_;
         })(packet);
         the_instance.spawnFrom(loc);
      }
      
      public function recv_collectedBy(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedInt();
         the_instance.collectedBy(_loc2_);
      }
   }
}

