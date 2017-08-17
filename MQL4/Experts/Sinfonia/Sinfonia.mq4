
/*

   DISCLAIMER ( IT ) http://j.mp/2a9gqBw
   
   ATTENTION DO NOT DELETE/EDIT THIS FILE
   
   CHANGELOG : ( IT ) 
   
      Prima versione del nuovo builder.
   
*/



#property copyright     "Copyright 2017, Leonardo Ciaccio"
#property link          "https://www.facebook.com/sinfonia.mt4/"
#property version       "2.03"
#property description   "Sinfonia Builder | /*NAME*/"
#property icon          "\\Include\\Sinfonia\\Images\\Sinfonia-Logo.ico"
#property strict

#include <Sinfonia\\Master.mqh>
Master Sinfonia;


string myuniquue = "/*NAME*/";

enum __YesNo{

   _Yes = 1,      // Yes
   _No  = -1      // No

};

/*VARIABLE*/
extern             string s0         = "";             // [ Trade ]------------------------------
extern                int ID         = 173;            // Magic Number
extern            __YesNo useStealth = _No;            // Stealth Mode ?
extern             double maxSpread  = 0.7;            // Max Spread
extern                int slippage   = 2;              // Slippage
extern             string s1         = "";             // [ Money Management ]-------------------
extern             double minLots    = 0.01;           // Min Size  
extern             double maxLots    = 0.5;            // Max Size
extern             double risk       = 0.5;            // Risk %
extern             string s2         = "";             // [ Setup ]------------------------------ 
extern                int maxTrade   = 1;              // Max Trade  
extern            __YesNo useNB      = _Yes;           // One Trade For Bar ?
extern                int SL         = 15;             // Stop Loss
extern                int TP         = 15;             // Take Profit
extern                int beFrom     = 5;              // Break Even From
extern                int beAt       = 0;              // Break Even At
extern                int trlFrom    = 7;              // Trailing From
extern                int trlFor     = 5;              // Trailing For



bool stealth = false;
bool onetrade = false;

// Inizializziamo
int OnInit(){ 

   stealth = ( useStealth == _Yes );
   onetrade = ( useNB == _Yes );
   
   // Pulizia Generale prima di iniziare
   Comment( "" );
   
   // Segnamo il territorio
   Sinfonia.CreateVersion( myuniquue );
  
   // Inseriamo la label dello spread
   Sinfonia.CreateSpread(); 
   
   // Il Profitto corrente
   Sinfonia.CreateProfit( ID );
                  
   return( INIT_SUCCEEDED );

};

// Chiusura
void OnDeinit(const int reason){
   
   // Facciamo pulizia
   Sinfonia.DestroyVersion();
   Sinfonia.DestroySpread();
   Sinfonia.DestroyProfit();
   
   Comment( "" );
   
}

// Si comimncia
int start(){

   // Segnamo il territorio
   Sinfonia.CreateVersion( myuniquue );
  
   // Inseriamo la label dello spread
   Sinfonia.CreateSpread();
   
   // Il Profitto corrente
   Sinfonia.CreateProfit( ID );
   
   // Devo determinare lo stoplevel
   double stoplevel = ( MarketInfo( Symbol(), MODE_STOPLEVEL ) / 10 );
   
   // Aggiungo un pip per sicurezza
   if( stoplevel > 0 )stoplevel++;
   
   if( !stealth && ( stoplevel > SL || ( beFrom > 0 && ( stoplevel > ( beFrom - beAt ) ) ) || ( trlFrom > 0 && ( stoplevel > trlFor ) ) ) ){
   
      Comment( StringFormat( MX_STL, DoubleToString( stoplevel, 2 ) ) );
      
      return( 0 );
      
   }
   
   if( Sinfonia.AU.TotalOrders( Symbol(), ID ) < maxTrade && Sinfonia.AU.Spread() <= maxSpread ){
      
      double mySL = Sinfonia.AU.IntPipsToDouble( SL );
      double myTP = Sinfonia.AU.IntPipsToDouble( TP );          
      
      int result = 0;
      
      HideTestIndicators(true);
      
      // Per il calcolo della size utilizziamo lo Stoploss oppure il TakeProfit
      int calcsize = ( SL > 0 ) ? SL : TP ;
      double nextSize = ( risk > 0 && calcsize > 0 ) ? Sinfonia.AU.GetSize( 1, 1, risk, 0, calcsize, minLots, maxLots ) : minLots;
      
      bool logicBuy  = /*LOGICBUY*/;
      bool logicSell = /*LOGICSELL*/;
      
      if( logicBuy ){
         
         // Meglio dopo la convalida
         if( onetrade && !Sinfonia.AU.IsNewBar() )return( 0 );
         
         result = OrderSend( Symbol(), OP_BUY, nextSize, Ask, slippage, 0, 0, myuniquue, ID, 0, clrBlue );
         RefreshRates();
         
         if( result > 0 ){         
            
            double myOrderSL = ( mySL > 0 ) ? ( Ask - mySL ) : 0;
            double myOrderTP = ( myTP > 0 ) ? ( Ask + myTP ) : 0;
         
            if( stealth ){
         
               if( myOrderSL > 0 )Sinfonia.CreateSLline( STEALTH_SL_SIGNATURE + IntegerToString( result ), myOrderSL );
               if( myOrderTP > 0 )Sinfonia.CreateTPline( STEALTH_TP_SIGNATURE + IntegerToString( result ), myOrderTP );
               
            }else{
            
               result = OrderSelect( result, SELECT_BY_TICKET );
               result = OrderModify( OrderTicket(), OrderOpenPrice(), myOrderSL, myOrderTP, 0, clrBlue );
            
            }
         
         }
                  
         return( 0 );
        
     }else if( logicSell ){
         
         if( onetrade && !Sinfonia.AU.IsNewBar() )return( 0 );
         
         result = OrderSend( Symbol(), OP_SELL, nextSize, Bid, slippage, 0, 0, myuniquue, ID, 0, clrRed );
         RefreshRates();
         
         if( result > 0 ){
         
            double myOrderSL = ( mySL > 0 ) ? ( Bid + mySL ) : 0;
            double myOrderTP = ( myTP > 0 ) ? ( Bid - myTP ) : 0;
         
            if( stealth ){
            
               if( myOrderSL > 0 )Sinfonia.CreateSLline( STEALTH_SL_SIGNATURE + IntegerToString( result ), myOrderSL );
               if( myOrderTP > 0 )Sinfonia.CreateTPline( STEALTH_TP_SIGNATURE + IntegerToString( result ), myOrderTP );
            
            }else{
            
               result = OrderSelect( result, SELECT_BY_TICKET );
               result = OrderModify( OrderTicket(), OrderOpenPrice(), myOrderSL, myOrderTP, 0, clrRed);
            }  
         
         }
         
         return(0);
     
     }// signals
   
   }// Max Trade
   
   
   for( int x = 0; x < OrdersTotal() ; x++ ){
   
      int result = OrderSelect( x, SELECT_BY_POS, MODE_TRADES );
      int error = 0;
      
      if( OrderType() > OP_SELL || OrderSymbol() != Symbol() || OrderMagicNumber() != ID )continue;
      
      double breakFrom = Sinfonia.AU.IntPipsToDouble( beFrom );
      double breakAt   = Sinfonia.AU.IntPipsToDouble( beAt );
      
      double trailingFrom = Sinfonia.AU.IntPipsToDouble( trlFrom );
      double trailingFor  = Sinfonia.AU.IntPipsToDouble( trlFor );
      
      if( OrderType() == OP_BUY ){
         
         // Devo controllare se chiudere l'operazione in stealth
         if( stealth ){
         
            // Prelevo i due valori
            double stealthSL = Sinfonia.GetLevelStealthline( STEALTH_SL_SIGNATURE + IntegerToString( OrderTicket() ) );
            double stealthTP = Sinfonia.GetLevelStealthline( STEALTH_TP_SIGNATURE + IntegerToString( OrderTicket() ) );
                       
            // Devo chiudere e cancellare le linee
            if( ( stealthSL > 0 && Bid <= stealthSL ) || ( stealthTP > 0 && Bid >= stealthTP ) ){
            
               double price = MarketInfo( OrderSymbol(), MODE_BID );
               int oldticket = OrderTicket();
                              
               if( OrderClose( OrderTicket(), OrderLots(), price, 0, clrOrange ) ){
               
                  // Devo cancellare tutto
                  Sinfonia.DestroyStealthline( STEALTH_SL_SIGNATURE + IntegerToString( oldticket ) );
                  Sinfonia.DestroyStealthline( STEALTH_TP_SIGNATURE + IntegerToString( oldticket ) );
                                 
                  error = GetLastError();
                  if( error == 135 )RefreshRates();
                  
                  return( 0 );
               
               } 
               
            }
            
         }// chiudo
         
         // Break Even
         if( beFrom > 0 ){
            
            double breakeven = ( OrderOpenPrice() + breakAt ); 
            breakeven = NormalizeDouble( breakeven, Digits );
               
            if( Bid > ( OrderOpenPrice() + breakFrom ) && ( OrderStopLoss() == 0 || ( breakeven > OrderStopLoss() ) ) ){              
            
               // BE che potrebbe generare errori
               if( stealth ){
                  
                  if( breakeven > Sinfonia.GetLevelStealthline( STEALTH_SL_SIGNATURE + IntegerToString( OrderTicket() ) ) ){
                  
                     Sinfonia.MoveStealthline( STEALTH_SL_SIGNATURE + IntegerToString( OrderTicket() ), breakeven );
                     
                     // Inutile proseguire
                     return( 0 );
                  }
                  
               }else{
               
                  result = OrderModify( OrderTicket(), OrderOpenPrice(), breakeven, OrderTakeProfit(), 0, clrBlue );
                  RefreshRates();
                  
                  // Inutile proseguire
                  return( 0 );
               
               }
               
            }
         
         }// BE
         
         // Trailing
         if( trlFrom > 0 ){
            
            double trailing = ( Bid - trailingFor );            
            trailing = NormalizeDouble( trailing, Digits );
            
            if( Bid > ( OrderOpenPrice() + trailingFrom ) && ( OrderStopLoss() == 0 || ( trailing > OrderStopLoss() ) ) ){              
               
               if( stealth ){
                  
                  if( trailing > Sinfonia.GetLevelStealthline( STEALTH_SL_SIGNATURE + IntegerToString( OrderTicket() ) ) ){
                  
                     Sinfonia.MoveStealthline( STEALTH_SL_SIGNATURE + IntegerToString( OrderTicket() ), trailing );
                     
                     // Inutile proseguire
                     return( 0 );
                     
                  }
               
               }else{
               
                  result = OrderModify( OrderTicket(), OrderOpenPrice(), trailing, OrderTakeProfit(), 0, clrBlue );
                  RefreshRates();
                  
                  // Inutile proseguire
                  return( 0 );
               
               } 
               
            }
             
         }// trailing
      
      }else{
         
         // Devo controllare se chiudere l'operazione in stealth
         if( stealth ){
         
            // Prelevo i due valori
            double stealthSL = Sinfonia.GetLevelStealthline( STEALTH_SL_SIGNATURE + IntegerToString( OrderTicket() ) );
            double stealthTP = Sinfonia.GetLevelStealthline( STEALTH_TP_SIGNATURE + IntegerToString( OrderTicket() ) );
                       
            // Devo chiudere e cancellare le linee
            if( ( stealthSL > 0 && Ask >= stealthSL ) || ( stealthTP > 0 && Ask <= stealthTP ) ){
            
               double price = MarketInfo( OrderSymbol(), MODE_ASK );
               int oldticket = OrderTicket();
                              
               if( OrderClose( OrderTicket(), OrderLots(), price, 0, clrOrange ) ){
               
                  // Devo cancellare tutto
                  Sinfonia.DestroyStealthline( STEALTH_SL_SIGNATURE + IntegerToString( oldticket ) );
                  Sinfonia.DestroyStealthline( STEALTH_TP_SIGNATURE + IntegerToString( oldticket ) );
                                 
                  error = GetLastError();
                  if( error == 135 )RefreshRates();
                  
                  return( 0 );
               
               } 
               
            }
            
         }// chiudo
         
         // Break Even
         if( beFrom > 0 ){
            
            double breakeven = ( OrderOpenPrice() - breakAt ); 
            breakeven = NormalizeDouble( breakeven, Digits );
            
            if( Ask < ( OrderOpenPrice() - breakFrom ) && ( OrderStopLoss() == 0 || ( breakeven < OrderStopLoss() ) ) ){
                          
               if( stealth ){
                  
                  if( breakeven < Sinfonia.GetLevelStealthline( STEALTH_SL_SIGNATURE + IntegerToString( OrderTicket() ) ) ){
                  
                     Sinfonia.MoveStealthline( STEALTH_SL_SIGNATURE + IntegerToString( OrderTicket() ), breakeven );
                     
                     // Inutile proseguire
                     return( 0 );
                     
                  }
               
               }else{
               
                  result = OrderModify( OrderTicket(), OrderOpenPrice(), breakeven, OrderTakeProfit(), 0, clrBlue );
                  RefreshRates();
                  
                  // Inutile proseguire
                  return( 0 );
               
               } 
               
            }
         
         }// BE        
         
         // Trailing
         if( trlFrom > 0 ){
            
            double trailing = ( Ask + trailingFor );            
            trailing = NormalizeDouble( trailing, Digits );
            
            if( Ask < ( OrderOpenPrice() - trailingFrom ) && ( OrderStopLoss() == 0 || ( trailing < OrderStopLoss() ) ) ){
               
               if( stealth ){
                  
                  if( trailing < Sinfonia.GetLevelStealthline( STEALTH_SL_SIGNATURE + IntegerToString( OrderTicket() ) ) ){
                              
                     Sinfonia.MoveStealthline( STEALTH_SL_SIGNATURE + IntegerToString( OrderTicket() ), trailing );
                  
                     // Inutile proseguire
                     return( 0 );
                        
                  }
               
               }else{
                    
                  result = OrderModify( OrderTicket(), OrderOpenPrice(), trailing, OrderTakeProfit() , 0 , clrRed );
                  RefreshRates();
                  
                  // Inutile proseguire
                  return( 0 );
               
               }
              
            }
           
         }// trailing
        
      }// else
        
   }// for

   return( 0 );

};