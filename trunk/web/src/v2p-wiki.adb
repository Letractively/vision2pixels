------------------------------------------------------------------------------
--                              Vision2Pixels                               --
--                                                                          --
--                           Copyright (C) 2007                             --
--                      Pascal Obry - Olivier Ramonat                       --
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
--  Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.       --
------------------------------------------------------------------------------

with Ada.Text_IO;
with Ada.Exceptions;

with Settings;

with Wiki_Interface;
with Gwiad.Services.Register;

package body V2P.Wiki is

   use Ada;
   use Gwiad.Services.Register;

   Wiki_Id : Service_Id := Null_Service_Id;

   function Get return Wiki_Interface.GW_Service'Class;
   --  Returns the service

   ---------
   -- Get --
   ---------

   function Get return Wiki_Interface.GW_Service'Class
   is
      use Wiki_Interface;
   begin

      if Wiki_Id = Null_Service_Id then
         declare
            Wiki_World_Service_Access : constant GW_Service_Access
              := GW_Service_Access (Gwiad.Services.Register.Get
                                    (Settings.Wiki_Service_Name));
            Get_Service               : GW_Service'Class :=
                                          Wiki_World_Service_Access.all;
         begin
            Initialize
              (S              =>
                 GW_Service'Class (Wiki_World_Service_Access.all),
               Base_URL       => "/",
               Img_Base_URL   => Settings.Images_Source_Prefix,
               Text_Directory => "");

            Wiki_Id := Gwiad.Services.Register.Set
              (Settings.Wiki_Service_Name,
               Gwiad.Services.Service_Access (Wiki_World_Service_Access));

            return Get_Service;
         end;
      else
         declare
            Wiki_World_Service_Access : constant GW_Service_Access :=
                                          GW_Service_Access
                                            (Gwiad.Services.Register.Get
                                               (Settings.Wiki_Service_Name,
                                                Wiki_Id));
            Get_Service               : GW_Service'Class :=
                                          Wiki_World_Service_Access.all;
         begin
            return Get_Service;
         end;
      end if;
   exception
      when E : others => Text_IO.Put_Line
           (Exceptions.Exception_Information (E));
         raise;
   end Get;

   ------------------
   -- Wiki_To_HTML --
   ------------------

   function Wiki_To_HTML (S : in String) return String is
   begin

      if not Gwiad.Services.Register.Exists (Settings.Wiki_Service_Name) then
         return "";
      end if;

      declare
         Get_Service : Wiki_Interface.GW_Service'Class := Get;
      begin
         return Wiki_Interface.HTML_Preview (Get_Service, S);
      end;
   end Wiki_To_HTML;


end V2P.Wiki;
