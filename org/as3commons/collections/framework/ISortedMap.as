package org.as3commons.collections.framework
{
   public interface ISortedMap extends IMap, ISortOrder
   {
      
      function higherKey(param1:*) : *;
      
      function lesserKey(param1:*) : *;
      
      function equalKeys(param1:*) : Array;
   }
}

