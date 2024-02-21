//****************************************************************
//Microsemi Corporation Proprietary and Confidential
//Copyright 2014 Microsemi Corporation.  All rights reserved
//
//ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
//ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE 
//APPROVED IN ADVANCE IN WRITING.
//
//Description: CoreCORDIC
//             Input test vector
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

// This is an automatically generated file

// CORDIC Input test vector for MODE 3
//  ----------------------  Conventions  -----------------------------------  
//        Mode    |     Inputs         |           Outputs                    
//  --------------|--------------------|------------------------------------  
//                    R O T A T I O N  M O D E S                              
//  General       | DIN_X: Abscissa X  | DOUT_X = K*(DIN_X*cosA - DIN_Y*sinA) 
//  Rotation      | DIN_Y: Ordinate Y  | DOUT_Y = K*(DIN_Y*cosA + DIN_X*sinA) 
//  (by Givens)   | DIN_A: Phase A     | DOUT_A   -                           
                                                                              
//  Polar to      | DIN_X: Magnitude R | DOUT_X = K*R*cosA                    
//  Rectangular   | DIN_Y: 0           | DOUT_Y = K*R*sinA                    
//                | DIN_A: Phase A     | DOUT_A   -                           
                                                                              
//  Sin, Cos  | DIN_X: 0 (1/g applies internally) | DOUT_X = sinA             
//            | DIN_Y: 0                          | DOUT_Y = cosA             
//            | DIN_A: Phase A                    | DOUT_A   -                
                                                                              
//                    V E C T O R I N G  M O D E S                            
//  Rectangular | DIN_X: Abscissa X  | DOUT_X = K*sqrt(X^2+Y^2)'Magnitude R' 
//  to Polar    | DIN_Y: Ordinate Y  | DOUT_Y     -                           
//              | DIN_A: 0           | DOUT_A = arctan(Y/X)'Phase A'         
                                                                              
//  Arctan        | DIN_X: Abscissa X  | DOUT_X     -                         
//                | DIN_Y: Ordinate Y  | DOUT_Y     -                         
//                | DIN_A: 0           | DOUT_A = arctan(Y/X)'Phase A'       
                                                                              
//  K - CORDIC gain                                                           
module cordic_bhvInpVect (count, xin, yin, ain);
    input [3:0] count;
    output[31:0] xin, yin, ain;

    reg[31:0] xin, yin, ain;

    always @ (count)
      case (count)
      0:  begin 
            xin = 32'b00100110110111010011101101101010; //652032874
            yin = 32'b00000000000000000000000000000000; //0
            ain = 32'b11000000000000000000000000000000; //-1073741824
          end 
      1:  begin 
            xin = 32'b00100110110111010011101101101010; //652032874
            yin = 32'b00000000000000000000000000000000; //0
            ain = 32'b11001000000000000000000000000000; //-939524096
          end 
      2:  begin 
            xin = 32'b00100110110111010011101101101010; //652032874
            yin = 32'b00000000000000000000000000000000; //0
            ain = 32'b11010000000000000000000000000000; //-805306368
          end 
      3:  begin 
            xin = 32'b00100110110111010011101101101010; //652032874
            yin = 32'b00000000000000000000000000000000; //0
            ain = 32'b11011000000000000000000000000000; //-671088640
          end 
      4:  begin 
            xin = 32'b00100110110111010011101101101010; //652032874
            yin = 32'b00000000000000000000000000000000; //0
            ain = 32'b11100000000000000000000000000000; //-536870912
          end 
      5:  begin 
            xin = 32'b00100110110111010011101101101010; //652032874
            yin = 32'b00000000000000000000000000000000; //0
            ain = 32'b11101000000000000000000000000000; //-402653184
          end 
      6:  begin 
            xin = 32'b00100110110111010011101101101010; //652032874
            yin = 32'b00000000000000000000000000000000; //0
            ain = 32'b11110000000000000000000000000000; //-268435456
          end 
      7:  begin 
            xin = 32'b00100110110111010011101101101010; //652032874
            yin = 32'b00000000000000000000000000000000; //0
            ain = 32'b11111000000000000000000000000000; //-134217728
          end 
      8:  begin 
            xin = 32'b00100110110111010011101101101010; //652032874
            yin = 32'b00000000000000000000000000000000; //0
            ain = 32'b00000000000000000000000000000000; //0
          end 
      9:  begin 
            xin = 32'b00100110110111010011101101101010; //652032874
            yin = 32'b00000000000000000000000000000000; //0
            ain = 32'b00001000000000000000000000000000; //134217728
          end 
     10:  begin 
            xin = 32'b00100110110111010011101101101010; //652032874
            yin = 32'b00000000000000000000000000000000; //0
            ain = 32'b00010000000000000000000000000000; //268435456
          end 
     11:  begin 
            xin = 32'b00100110110111010011101101101010; //652032874
            yin = 32'b00000000000000000000000000000000; //0
            ain = 32'b00011000000000000000000000000000; //402653184
          end 
     12:  begin 
            xin = 32'b00100110110111010011101101101010; //652032874
            yin = 32'b00000000000000000000000000000000; //0
            ain = 32'b00100000000000000000000000000000; //536870912
          end 
     13:  begin 
            xin = 32'b00100110110111010011101101101010; //652032874
            yin = 32'b00000000000000000000000000000000; //0
            ain = 32'b00101000000000000000000000000000; //671088640
          end 
     14:  begin 
            xin = 32'b00100110110111010011101101101010; //652032874
            yin = 32'b00000000000000000000000000000000; //0
            ain = 32'b00110000000000000000000000000000; //805306368
          end 
     15:  begin 
            xin = 32'b00100110110111010011101101101010; //652032874
            yin = 32'b00000000000000000000000000000000; //0
            ain = 32'b00111000000000000000000000000000; //939524096
          end 
      default: begin
           xin = 32'dx;
           yin = 32'dx;
           ain = 32'dx;
      end 
    endcase
  endmodule
