
/*

   DISCLAIMER ( IT ) http://j.mp/2a9gqBw
   
   ATTENTION DO NOT DELETE/EDIT THIS FILE
   
   CHANGELOG : ( IT ) 
   
      Prima versione del nuovo builder.
   
*/



#define SIGNATURE_NAME                                "Sinfonia-Signature"
#define SIGNATURE_CORNER                              1
#define SIGNATURE_X                                   15
#define SIGNATURE_Y                                   30
#define SIGNATURE_SIZE                                32
#define SIGNATURE_FONT                                "Impact"
#define SIGNATURE_COLOR                               2552556

#define SPREAD_NAME                                   "Sinfonia-Spread"
#define SPREAD_CORNER                                 1
#define SPREAD_X                                      35
#define SPREAD_Y                                      40
#define SPREAD_SIZE                                   20
#define SPREAD_FONT                                   "Impact"
#define SPREAD_COLOR                                  clrRed

#define PROFIT_NAME                                   "Sinfonia-Updating"
#define PROFIT_CORNER                                 3
#define PROFIT_X                                      15
#define PROFIT_Y                                      15
#define PROFIT_SIZE                                   16
#define PROFIT_FONT                                   "Impact"
#define PROFIT_COLOR                                  clrDodgerBlue

#define STEALTH_SL_SIGNATURE                          "SSL"
#define STEALTH_TP_SIGNATURE                          "STP"

#define HLINE_SL_STYLE                                STYLE_SOLID
#define HLINE_SL_COLOR                                clrRed
#define HLINE_SL_WIDTH                                1

#define HLINE_TP_STYLE                                STYLE_SOLID
#define HLINE_TP_COLOR                                clrDodgerBlue
#define HLINE_TP_WIDTH                                1

#define MX_STL                                        "\r\n\r\n\r\nSinfonia : Minimum StopLoss/Break Even/Trailing required for this Broker %s.\r\nPlease use 'Stealth Mode' !"



// Dipendenza per funzioni accessorie globali
#include <Sinfonia\\Utility.mqh>



class Master{

   private:
        
      // TODO
      
   public:
      
      // Costruttore
      Master( void );
               
      // Distruttore
      ~Master( void ); 
      
      // Mettiamo a disposizione di tutta la classe le funzioni accessorie      
      Utility AU;
      
      void CreateVersion
      (
      
         string currentversion
      
      );
      
      void CreateSpread
      (
      
         void
      
      );   
   
      void CreateProfit
      (
      
         int magician
         
      );
      
      void CreateSLline
      (
      
         string name,
         double level
         
      );
      
      void CreateTPline
      (
      
         string name,
         double level
         
      );
      
      void MoveStealthline
      (
      
         string name,
         double level
         
      );
      
      void DestroyStealthline
      (
      
         string name
         
      );
      
      double GetLevelStealthline
      (
      
         string name
         
      );
      
      void DestroyVersion
      (
      
         void
      
      );
      
      void DestroySpread
      (
      
         void
      
      );
      
      void DestroyProfit
      (
      
         void
      
      );
                     
   protected:
      
      // TODO
  
};

// --> Private [

// <-- Private ]



// --> Public [

Master::Master( void ){ /* TODO */ };

Master::~Master( void ){ /* TODO */ };


void Master::CreateVersion
(

   string currentversion

){

   
   // Creo l'intestazione
   ObjectCreate ( SIGNATURE_NAME, OBJ_LABEL, 0, 0, 0 );
   ObjectSet    ( SIGNATURE_NAME, OBJPROP_CORNER, SIGNATURE_CORNER );  
   ObjectSet    ( SIGNATURE_NAME, OBJPROP_XDISTANCE, SIGNATURE_X );
   ObjectSet    ( SIGNATURE_NAME, OBJPROP_YDISTANCE, SIGNATURE_Y );
   ObjectSet    ( SIGNATURE_NAME, OBJPROP_SELECTABLE, false );
   ObjectSetText( SIGNATURE_NAME, currentversion, SIGNATURE_SIZE, SIGNATURE_FONT, SIGNATURE_COLOR );

};
      
void Master::CreateSpread
(

   void

){

   // Creo la label dello spread
   ObjectCreate ( SPREAD_NAME, OBJ_LABEL, 0, 0, 0 );
   ObjectSet    ( SPREAD_NAME, OBJPROP_CORNER, SPREAD_CORNER );  
   ObjectSet    ( SPREAD_NAME, OBJPROP_XDISTANCE, SPREAD_X );
   ObjectSet    ( SPREAD_NAME, OBJPROP_YDISTANCE, SIGNATURE_Y + SPREAD_Y );
   ObjectSet    ( SPREAD_NAME, OBJPROP_SELECTABLE, false );
   ObjectSetText( SPREAD_NAME, "Spread " + DoubleToString( AU.Spread(), 1 ), SPREAD_SIZE, SPREAD_FONT, SPREAD_COLOR );   

};   
   
void Master::CreateProfit
(

   int magician
   
){

   // Creo la label dell updateing
   ObjectCreate ( PROFIT_NAME, OBJ_LABEL, 0, 0, 0 );
   ObjectSet    ( PROFIT_NAME, OBJPROP_CORNER, PROFIT_CORNER );  
   ObjectSet    ( PROFIT_NAME, OBJPROP_XDISTANCE, PROFIT_X );
   ObjectSet    ( PROFIT_NAME, OBJPROP_YDISTANCE, PROFIT_Y );
   ObjectSet    ( PROFIT_NAME, OBJPROP_SELECTABLE, false );
   ObjectSetText( PROFIT_NAME, "Current Profit " + DoubleToString( AU.CurrentProfit( Symbol(), magician ), 2 ), PROFIT_SIZE, PROFIT_FONT, PROFIT_COLOR );

};   
    
void Master::CreateSLline
(

   string name,
   double level
   
){

   // Creo la linea orizontale per lo stealth mode
   if( ObjectCreate( 0, name, OBJ_HLINE, 0, 0, level ) ){
   
      ObjectSetInteger( 0, name, OBJPROP_STYLE, HLINE_SL_STYLE );
      ObjectSetInteger( 0, name, OBJPROP_COLOR, HLINE_SL_COLOR );
      ObjectSetInteger( 0, name, OBJPROP_WIDTH, HLINE_SL_WIDTH );
   
   }
   
};   
   
void Master::CreateTPline
(

   string name,
   double level
   
){

   // Creo la linea orizontale per lo stealth mode
   if( ObjectCreate( 0, name, OBJ_HLINE, 0, 0, level ) ){
   
      ObjectSetInteger( 0, name, OBJPROP_STYLE, HLINE_TP_STYLE );
      ObjectSetInteger( 0, name, OBJPROP_COLOR, HLINE_TP_COLOR );
      ObjectSetInteger( 0, name, OBJPROP_WIDTH, HLINE_TP_WIDTH );
   
   }
   
};

void Master::MoveStealthline
(

   string name,
   double level
   
){

   // Creo la linea orizontale per lo stealth mode
   ObjectMove( 0, name, 0, 0, level );
   
};

void Master::DestroyStealthline
(

   string name
   
){

   // Creo la linea orizontale per lo stealth mode
   ObjectDelete( name );
   
}; 

double Master::GetLevelStealthline
(

   string name
   
){

   return ObjectGet( name, OBJPROP_PRICE1 );
   
}; 

void Master::DestroyVersion
(

   void

){

   ObjectDelete( SIGNATURE_NAME );

};

void Master::DestroySpread
(

   void

){

   ObjectDelete( SPREAD_NAME );

};

void Master::DestroyProfit
(

   void

){

   ObjectDelete( PROFIT_NAME );

};

// <-- Public ]


// --> Protected [

// <-- Protected ]