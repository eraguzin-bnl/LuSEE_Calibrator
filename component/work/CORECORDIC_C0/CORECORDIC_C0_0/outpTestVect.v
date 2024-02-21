//****************************************************************
//Microsemi Corporation Proprietary and Confidential
//Copyright 2014 Microsemi Corporation.  All rights reserved
//
//ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
//ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE 
//APPROVED IN ADVANCE IN WRITING.
//
//Description: CoreCORDIC
//             Output test vector
//
//Rev:
//v4.0 12/2/2014  Porting in TGI framework
//
//SVN Revision Information:
//SVN$Revision:$
//SVN$Date:$
//
//Resolved SARS
//
//
//
//Notes:
//
//****************************************************************

// CORDIC Output test vector for mode:  Rotation (0)

//             In Rotation Mode    In Vectoring Mode
// goldSample1  XN=gain*R*cosA    XN=gain*sqrt(X^2+Y^2)
// goldSample2  YN=gain*R*sinA    AN=arctan(Y/X) 

module cordic_bhvOutpVect (count, goldSample1, goldSample2);
    input [3:0] count;
    output[31:0] goldSample1, goldSample2;

    reg [31:0] goldSample1, goldSample2;

    always @ (count)
      case (count)
      0:  begin 
            goldSample1 = 32'b11100000000000000000000000000000; //-536870912
            goldSample2 = 32'b00000000000000000000000000000000; //0
          end 
      1:  begin 
            goldSample1 = 32'b11100010011011111001010000110001; //-496004047
            goldSample2 = 32'b11110011110000010000111010101101; //-205451603
          end 
      2:  begin 
            goldSample1 = 32'b11101001010111110110000110011010; //-379625062
            goldSample2 = 32'b11101001010111110110000110011010; //-379625062
          end 
      3:  begin 
            goldSample1 = 32'b11110011110000010000111010101101; //-205451603
            goldSample2 = 32'b11100010011011111001010000110001; //-496004047
          end 
      4:  begin 
            goldSample1 = 32'b00000000000000000000000000000000; //0
            goldSample2 = 32'b11100000000000000000000000000000; //-536870912
          end 
      5:  begin 
            goldSample1 = 32'b00001100001111101111000101010011; //205451603
            goldSample2 = 32'b11100010011011111001010000110001; //-496004047
          end 
      6:  begin 
            goldSample1 = 32'b00010110101000001001111001100110; //379625062
            goldSample2 = 32'b11101001010111110110000110011010; //-379625062
          end 
      7:  begin 
            goldSample1 = 32'b00011101100100000110101111001111; //496004047
            goldSample2 = 32'b11110011110000010000111010101101; //-205451603
          end 
      8:  begin 
            goldSample1 = 32'b00100000000000000000000000000000; //536870912
            goldSample2 = 32'b00000000000000000000000000000000; //0
          end 
      9:  begin 
            goldSample1 = 32'b00011101100100000110101111001111; //496004047
            goldSample2 = 32'b00001100001111101111000101010011; //205451603
          end 
     10:  begin 
            goldSample1 = 32'b00010110101000001001111001100110; //379625062
            goldSample2 = 32'b00010110101000001001111001100110; //379625062
          end 
     11:  begin 
            goldSample1 = 32'b00001100001111101111000101010011; //205451603
            goldSample2 = 32'b00011101100100000110101111001111; //496004047
          end 
     12:  begin 
            goldSample1 = 32'b00000000000000000000000000000000; //0
            goldSample2 = 32'b00100000000000000000000000000000; //536870912
          end 
     13:  begin 
            goldSample1 = 32'b11110011110000010000111010101101; //-205451603
            goldSample2 = 32'b00011101100100000110101111001111; //496004047
          end 
     14:  begin 
            goldSample1 = 32'b11101001010111110110000110011010; //-379625062
            goldSample2 = 32'b00010110101000001001111001100110; //379625062
          end 
     15:  begin 
            goldSample1 = 32'b11100010011011111001010000110001; //-496004047
            goldSample2 = 32'b00001100001111101111000101010011; //205451603
          end 
      default: begin
           goldSample1 = 32'dx;
           goldSample2 = 32'dx;
      end 
    endcase
  endmodule
