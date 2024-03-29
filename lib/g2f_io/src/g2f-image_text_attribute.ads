------------------------------------------------------------------------------
--                              G2f_Io                                      --
--                                                                          --
--                         Copyright (C) 2004                               --
--                            Ali Bendriss                                  --
--                                                                          --
--  Author: Ali Bendriss                                                    --
--                                                                          --
--  This library is free software; you can redistribute it and/or modify    --
--  it under the terms of the GNU General Public License as published by    --
--  the Free Software Foundation; either version 2 of the License, or (at   --
--  your option) any later version.                                         --
--                                                                          --
--  This library is distributed in the hope that it will be useful, but     --
--  WITHOUT ANY WARRANTY; without even the implied warranty of              --
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU       --
--  General Public License for more details.                                --
--                                                                          --
--  You should have received a copy of the GNU General Public License       --
--  along with this library; if not, write to the Free Software Foundation, --
--  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.          --
--                                                                          --
--  As a special exception, if other files instantiate generics from this   --
--  unit, or you link this unit with other files to produce an executable,  --
--  this  unit  does not  by itself cause  the resulting executable to be   --
--  covered by the GNU General Public License. This exception does not      --
--  however invalidate any other reasons why the executable file  might be  --
--  covered by the  GNU Public License.                                     --
------------------------------------------------------------------------------

package G2F.Image_Text_Attribute is

   Attribute_Error, No_Attribute : exception;

   type Tag_Attribute is
     (DocumentName,
      ImageDescription,
      Make,
      Model,
      Software,
      DateTime,
      Artist,
      Copyright,
      ExposureTime,
      GPSInfo,
      ISOSpeedRatings,
      OECF,
      ExifVersion,
      DateTimeOriginal,
      DateTimeDigitized,
      UserComment,
      SubSecTime,
      SubSecTimeOriginal,
      SubSecTimeDigitized,
      SubjectLocation,
      ExposureIndex,
      FileSource,
      SceneType);

   procedure Set_Image_Text_Attribute
     (I     : in out Image_Ptr;
      Key   : in     Tag_Attribute;
      Value : in     String);
   --  Searches the list of image attributes and replaces the attribute value.
   --  If it is not found in the list, the attribute name and value is added to
   --  the list.

   procedure Set_Image_Text_Attribute
     (I          : in out Image_Ptr;
      Key, Value : in     String);
   --  Searches the list of image attributes and replaces the attribute value.
   --  If it is not found in the list, the attribute name and value is added to
   --  the list.

   function Get_Image_Text_Attribute
     (I    : in Image_Ptr;
      Key  : in Tag_Attribute) return String;
   --  Searches the list of image attributes and returns a pointer to the
   --  attribute if it exists otherwise NULL.

   function Get_Image_Text_Attribute
     (I    : in Image_Ptr;
      Key  : in String) return String;
   --  Searches the list of image attributes and returns a pointer to the
   --  attribute if it exists otherwise NULL.

end G2F.Image_Text_Attribute;
