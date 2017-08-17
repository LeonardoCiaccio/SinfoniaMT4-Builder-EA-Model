
/*

   DISCLAIMER ( IT ) http://j.mp/2a9gqBw
   
   ATTENTION DO NOT DELETE/EDIT THIS FILE
   
   CHANGELOG : ( IT ) 
   
      Prima versione del nuovo builder.
   
*/



class Utility{

   private :
   
      // TODO
   
   public :
   
      // Costruttore
      Utility( void );
               
      // Distruttore
      ~Utility( void );
      
      // Splitta una stringa
      int Split
      ( // Restituisce il numero di stringhe splittate
               
        const string separator,    // Stringa o carattere che divide la stringa
              string tosplit,      // Testo da splittare
              string &splitted[]   // Contenitore che verrà riempito con le stringhe splittate
            
      );
               
       // Lo spread corrent
      double Spread( void );
      
      // Trasforma un intero nei corrispondenti pips indipendentemente dal Digit
      double IntPipsToDouble
      ( // Restituisce il valore dei pips 
       
         int pips                // Numeri di pips rappresentati in numero intero
         
      );
      
      int DoublePipsToInt
      ( 
      
         double pips 
      
      );
      
      // Restituisce la percentuale corrispondente di un double
      double PercentageToDouble
      ( 
         
         double sizeL,
         double percentage 
      
      );
      
      // Controlla se il prezzo si trova in un range
      bool InRange
      ( // Restituisce true se è nel range altrimenti false
     
          double price,
          double levelprice,
             int range 
     
      );
      
      // Controlla se si trova in una nuova barra
      bool IsNewBar( void );
            
      string ArrayToHex
      ( 
      
         uchar &arr[],
         int count = -1
      
      );
      
      // Crypta una stringa
      string EnCrypt
      (
         ENUM_CRYPT_METHOD method,
         string toKey,
         string toEnCrypt
      
      );
      
      string DeCrypt
      (
         ENUM_CRYPT_METHOD method,
         string toKey,
         string toDeCrypt
      
      );
      
      double GetSize
      (
         
         int Mode,
         int AccountMoney,
         double RiskPercentage,
         double RiskMoney,
         int StopLossPips,
         double MinLots,
         double MaxLots
      
      );
      
      double CloseAllSymbols
      (
      
         bool &timeouted
      
      );
      
      double CloseThisSymbol
      (
      
         bool &timeouted
      
      );
      
      bool ReadyFileTXT
      (
      
         string filename,
         string &content,
         string nline = "\r\n"   // Line Separator
      
      );
      
      bool WriteFileTXT
      (
      
         string filename,
         string text
      
      );
      
      int IndicatorExist
      (
      
         string indicatorShortname
      
      );
      
      void RemoveAllObject
      (
      
         void
      
      );
      
      double CurrentProfit
      (
      
         string simbol,
         int magician
      
      );
      
      int TotalOrders
      (
      
         string simbol,
         int magician
      
      );
      
      void RemoveWhiteSpace
      (
      
         string &mystring,
         string replacewith
      
      );
   
   protected :
   
      // TODO

};

// --> Private [

// <-- Private ]



// --> Public [

Utility::Utility( void ){ /* TODO */ };

Utility::~Utility( void ){ /* TODO */ };


int Utility::Split
( 

   const string separator, 
         string tosplit, 
         string &splitted[] 
){
   
   ushort u_sep = StringGetCharacter( separator, 0 );   
   
   return StringSplit( tosplit, u_sep , splitted );

};

double Utility::Spread
( 

   void
   
){

   double spread = 0.0;
   
   if( Digits == 3 || Digits == 5 ){
   
      spread = NormalizeDouble( MarketInfo( Symbol(), MODE_SPREAD ) / 10, 1 );
   
   }else{
   
      spread = NormalizeDouble( MarketInfo( Symbol(), MODE_SPREAD ), 0 );
   
   } 
   
   return( spread );

};

double Utility::IntPipsToDouble
( 

   int pips 

){

   double myPoint = Point;
   if( Digits == 3 || Digits == 5 )myPoint = Point * 10;
   
   return NormalizeDouble( pips * myPoint, Digits );

};

int Utility::DoublePipsToInt
( 

   double pips 

){

   double myPoint = Point;
   if( Digits == 3 || Digits == 5 )myPoint = Point * 10;
   
   int result = (int)MathRound( ( pips / myPoint ) );
   
   return result;

};

double Utility::PercentageToDouble
( 
   
   double sizeL,
   double percentage 

){
     
   return ( ( sizeL / 100 ) * percentage );

};

bool Utility::InRange
( 

   double price,
   double levelprice,
      int range 

){

   double doubleRange = IntPipsToDouble( range ); 
   
   return 
   (
    
      price + doubleRange > levelprice &&
      price - doubleRange < levelprice 
   
   );

};

bool Utility::IsNewBar
(

   void

){

   static datetime lastTimeBar = 0;
   
   if( lastTimeBar < iTime ( Symbol(), PERIOD_CURRENT, 0 ) ){
      
      lastTimeBar = iTime ( Symbol(), PERIOD_CURRENT, 0 ) ; 
      return( true ) ; 
   
   }else{
      
      return( false ) ; 
   
   } 
                                                             
};

string Utility::ArrayToHex
( 

   uchar &arr[],
   int count = -1

){

   string res = "";

   if( count < 0 || count > ArraySize( arr ) )count = ArraySize( arr );
   
   for( int i = 0; i < count; i++ ){
   
      res += StringFormat( "%.2X", arr[i] );
   
   }
   
   return( res );
   
};

string Utility::EnCrypt
(
   ENUM_CRYPT_METHOD method,
   string toKey,
   string toEnCrypt

){

   uchar src[],dst[],key[];
   
   StringToCharArray( toKey, key, 0, StringLen( toKey ) );
   StringToCharArray( toEnCrypt,src, 0, StringLen( toEnCrypt ) );

   int res = CryptEncode( method, src, key, dst );
   
   return ( res > 0 ) ? CharArrayToString( dst ) : "";

};

string Utility::DeCrypt
(
   ENUM_CRYPT_METHOD method,
   string toKey,
   string toDeCrypt

){

   uchar src[],dst[],key[];
   
   StringToCharArray( toKey, key, 0, StringLen( toKey ) );
   StringToCharArray( toDeCrypt, src, 0, StringLen( toDeCrypt ) );   

   int res = CryptDecode( method, src, key, dst );

   return ( res > 0 ) ? CharArrayToString( dst ) : "";

};

double Utility::GetSize
(
   
   int Mode,
   int AccountMoney,
   double RiskPercentage,
   double RiskMoney,
   int StopLossPips,
   double MinLots,
   double MaxLots

){
   
   // Se non ho una base su cui lavorare non posso fare altro
   if( StopLossPips < 1 )return MinLots;
   
   double size  = 0.0;
   
   switch( AccountMoney ){
   
      case 0 : 
         
         size  = AccountFreeMargin();
         break;
      
      case 1 : 
         
         size  = AccountBalance();
         break;
         
      case 2 : 
         
         size  = AccountEquity();
         break;
   
   }
   
   // Devo sapere se devo calcolare la percentuale o i soldi
   // mi serve solo sapere il capitale, i soldi.
   double riskMoney = ( Mode == 1 ) ? NormalizeDouble( ( size / 100 ) * RiskPercentage, 2 ) : NormalizeDouble( RiskMoney, 2 );
      
   double unitCost = MarketInfo( Symbol(), MODE_TICKVALUE );
   double tickSize = MarketInfo( Symbol(), MODE_TICKSIZE );
   double sSLdouble = IntPipsToDouble( StopLossPips );
  
   // Important for startup MT4, without generate an error
   //if( unitCost == 0 )return( 0 );   
   double positionSize = ( unitCost > 0 ) ? riskMoney / ( ( sSLdouble * unitCost ) / tickSize ) : 0 ;
   
   positionSize = NormalizeDouble( positionSize, 2 );
   
   if( positionSize < MinLots || positionSize == 0 )return MinLots;
   if( positionSize > MaxLots )return MaxLots;
   
   return positionSize;

};

double Utility::CloseAllSymbols
(

   bool &timeouted

){

   bool rescan = true;
   int timeout = 1000;   
   
   double totalProfit = 0;
   
   // Questo ciclo perché se cancello un oggetto devo ricalcolare
   while( rescan && OrdersTotal() > 0 && timeout > 0 ){
   
      rescan = false;
      timeout--;
            
      int allxOBJ = OrdersTotal();
      
      // Passo al setaccio tutti i tipi di ordini
      for( int ix = 0; ix < allxOBJ; ix++ ){
      
         if( OrderSelect( ix, SELECT_BY_POS, MODE_TRADES ) == false )continue; 
         
         double xxpPrice = 0;
         
         // Devo sapere di cosa si tratta
         if( OrderType() == OP_BUY ){
                           
            xxpPrice = MarketInfo( OrderSymbol(), MODE_BID );
         
         }else if( OrderType() == OP_SELL  ){
            
            xxpPrice = MarketInfo( OrderSymbol(), MODE_ASK );
         
         }
         
         // Ci portiamo il conto prima di chiuderlo
         totalProfit+= OrderProfit();
         
         // Chiudo         
         if( OrderClose( OrderTicket(), OrderLots(), xxpPrice, 0, clrLime ) ){
            
            // Ripeto, perché ho chiuso
            rescan = true;
            break;   
         
         }     
                    
         if( GetLastError() == 135 )RefreshRates();                        
         
      }// For

   }//While
   
   // Segno il time out
   timeouted = ( timeout < 1 );
   
   return totalProfit;
   
};



double Utility::CloseThisSymbol
(

   bool &timeouted

){

   bool rescan = true;
   int timeout = 1000;   
   
   double totalProfit = 0;
   
   // Questo ciclo perché se cancello un oggetto devo ricalcolare
   while( rescan && OrdersTotal() > 0 && timeout > 0 ){
   
      rescan = false;
      timeout--;
            
      int allxOBJ = OrdersTotal();
      
      // Passo al setaccio tutti i tipi di ordini
      for( int ix = 0; ix < allxOBJ; ix++ ){
      
         if( OrderSelect( ix, SELECT_BY_POS, MODE_TRADES ) == false )continue; 
         if( OrderSymbol() != Symbol() )continue;
         
         double xxpPrice = 0;
         
         // Devo sapere di cosa si tratta
         if( OrderType() == OP_BUY ){
                           
            xxpPrice = MarketInfo( OrderSymbol(), MODE_BID );
         
         }else if( OrderType() == OP_SELL  ){
            
            xxpPrice = MarketInfo( OrderSymbol(), MODE_ASK );
         
         }
         
         // Ci portiamo il conto prima di chiuderlo
         totalProfit+= OrderProfit();
         
         // Chiudo         
         if( OrderClose( OrderTicket(), OrderLots(), xxpPrice, 0, clrLime ) ){
            
            // Ripeto, perché ho chiuso
            rescan = true;
            break;   
         
         }     
                    
         if( GetLastError() == 135 )RefreshRates();                        
         
      }// For

   }//While
   
   // Segno il time out
   timeouted = ( timeout < 1 );
   
   return totalProfit;
   
};

bool Utility::ReadyFileTXT
(

   string filename,
   string &content,
   string nline = "\r\n"   // Line Separator

){
   
   bool result = false;
   
   // Provo ad aprire la nuova versione
   int filehandle = FileOpen( filename, FILE_READ|FILE_TXT );  
      
   if( filehandle != INVALID_HANDLE ){
   
      while( !FileIsEnding( filehandle ) ){
      
         content += FileReadString( filehandle ) + nline;
         
      }// while
      
      FileClose( filehandle );
      result = true;
      
   }// Invalid ? 
   
   return result;
   
};

bool Utility::WriteFileTXT
(

   string filename,
   string text

){
   
   bool result = false;
   
   // Provo ad aprire la nuova versione
   int filehandle = FileOpen( filename, FILE_WRITE|FILE_TXT );  
      
   if( filehandle != INVALID_HANDLE ){
   
      FileWrite( filehandle, text );
      
      FileClose( filehandle );
      result = true;
   
   }// Invalid ? 
   
   return result;
   
};

int Utility::IndicatorExist
(

   string indicatorShortname

){

   // Prelevo tutti gli indicatori
   int allIndi = ChartIndicatorsTotal( 0, 0 );
   int count  = 0;
   
   // Cernita
   for( int i = 0; i < allIndi; i++ ){
      
      // Prelevo lo shortname
      string shortname = ChartIndicatorName( 0, 0, i );

      if( indicatorShortname == shortname )count++;
         
   }   
   
   return count;

};

void Utility::RemoveAllObject
(

   void

){

   bool rescan = true;
   int timeOut = 10000;
   
   while( rescan && timeOut > 0 ){
      
      rescan = false;
      timeOut--;
      
      if( ObjectDelete( ObjectName( 0 ) ) )rescan = true;
   
   }// While

};      
      
double Utility::CurrentProfit
(

   string simbol,
   int magician

){

   double currentprofit = 0;
   int allorders = OrdersTotal();
                          
   for( int i = 0; i < allorders; i++ ){
   
      if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) == false )continue; 
   
      // Se il simbolo nn è il mio, continuo
      if( OrderSymbol() != simbol )continue;
      
      // Se non è il mio magic continuo
      if( OrderMagicNumber() != magician )continue;
      
      currentprofit += OrderProfit();
      
   }// for
   
   return currentprofit;

};

int Utility::TotalOrders
(

   string simbol,
   int magician

){
   
   int allmyorders = 0;
   int allorders = OrdersTotal();
                          
   for( int i = 0; i < allorders; i++ ){
   
      if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) == false )continue; 
   
      // Se il simbolo nn è il mio, continuo
      if( OrderSymbol() != simbol )continue;
      
      // Se non è il mio magic continuo
      if( OrderMagicNumber() != magician )continue;
      
      allmyorders++;
      
   }// for
   
   return allmyorders;
};
      
void Utility::RemoveWhiteSpace
(
   
   string &mystring,
   string replacewith

){

   StringReplace( mystring, " ", replacewith );

};

// <-- Public ]



// --> Protected [

// <-- Protected ]