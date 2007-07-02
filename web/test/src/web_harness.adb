------------------------------------------------------------------------------
--                              Vision2Pixels                               --
--                                                                          --
--                           Copyright (C) 2006                             --
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

--  This is the main driver for the test suite(s)

with Ada.Text_IO;
with AUnit;

with Gwiad.Web;
with Gwiad.Plugins.Websites.Registry;
with V2P.Web_Server;

with Web_Suite;

procedure Web_Harness is

   use Ada;
   use Gwiad;

   procedure Run is new AUnit.Test_Runner (Web_Suite);

begin
   Text_IO.Put_Line ("(web_harness): Begin");

   Plugins.Websites.Registry.Register
     (Library_Path => "lib/websites/vision2pixels.so");

   Text_IO.Put_Line ("(web_harness): Start server");

   Web.Start;

   --  Run tests

   Text_IO.Put_Line ("(web_harness): run tests");
   Run;

   --  Exit now

   Web.Stop;

   Text_IO.Put_Line ("(web_harness): End");
end Web_Harness;
