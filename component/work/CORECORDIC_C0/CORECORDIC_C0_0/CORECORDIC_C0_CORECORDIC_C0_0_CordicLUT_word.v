//****************************************************************
//Microsemi Corporation Proprietary and Confidential
//Copyright 2014 Microsemi Corporation.  All rights reserved
//
//ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
//ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE 
//APPROVED IN ADVANCE IN WRITING.
//
//Description: CoreCORDIC
//             CORDIC Word-serial Arctan LUT
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
// CORDIC constant angle (arctan) LUT
module CORECORDIC_C0_CORECORDIC_C0_0_word_cROM(iterCount, arctan, rcprGain_fx);
  localparam LOGITER	= 6;
  localparam BIT_WIDTH = 48;
  localparam IN_BITS = 32;

  input[LOGITER-1:0] iterCount;
  output[BIT_WIDTH-1:0] arctan;
  output[IN_BITS-1:0] rcprGain_fx;
  reg[BIT_WIDTH-1:0] arctan;

  always @ (iterCount) begin
    case (iterCount)
      6'd0:arctan=48'd17592186044416; 
      6'd1:arctan=48'd10385273835258; 
      6'd2:arctan=48'd5487293476722; 
      6'd3:arctan=48'd2785435848431; 
      6'd4:arctan=48'd1398123104044; 
      6'd5:arctan=48'd699743120514; 
      6'd6:arctan=48'd349956943380; 
      6'd7:arctan=48'd174989150442; 
      6'd8:arctan=48'd87495910248; 
      6'd9:arctan=48'd43748122008; 
      6'd10:arctan=48'd21874081865; 
      6'd11:arctan=48'd10937043540; 
      6'd12:arctan=48'd5468522096; 
      6'd13:arctan=48'd2734261089; 
      6'd14:arctan=48'd1367130549; 
      6'd15:arctan=48'd683565275; 
      6'd16:arctan=48'd341782638; 
      6'd17:arctan=48'd170891319; 
      6'd18:arctan=48'd85445659; 
      6'd19:arctan=48'd42722830; 
      6'd20:arctan=48'd21361415; 
      6'd21:arctan=48'd10680707; 
      6'd22:arctan=48'd5340354; 
      6'd23:arctan=48'd2670177; 
      6'd24:arctan=48'd1335088; 
      6'd25:arctan=48'd667544; 
      6'd26:arctan=48'd333772; 
      6'd27:arctan=48'd166886; 
      6'd28:arctan=48'd83443; 
      6'd29:arctan=48'd41722; 
      6'd30:arctan=48'd20861; 
      6'd31:arctan=48'd10430; 
      6'd32:arctan=48'd5215; 
      6'd33:arctan=48'd2608; 
      6'd34:arctan=48'd1304; 
      6'd35:arctan=48'd652; 
      6'd36:arctan=48'd326; 
      6'd37:arctan=48'd163; 
      6'd38:arctan=48'd81; 
      6'd39:arctan=48'd41; 
      6'd40:arctan=48'd20; 
      6'd41:arctan=48'd10; 
      6'd42:arctan=48'd5; 
      6'd43:arctan=48'd3; 
      6'd44:arctan=48'd1; 
      6'd45:arctan=48'd1; 
      6'd46:arctan=48'd0; 
      6'd47:arctan=48'd0; 
    default: arctan=48'bx;
    endcase
  end

  assign rcprGain_fx = 32'd652032874; 
endmodule
