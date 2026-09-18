import '../domain/stock.dart';

/// Illustrative catalogue of listed companies for the custom universe.
///
/// This is mock data. A production build must load live index constituents
/// from market data.
abstract final class StockCatalog {
  static const List<Stock> stocks = <Stock>[
    Stock(symbol: 'HDFCBANK', name: 'HDFC Bank'),
    Stock(symbol: 'INFY', name: 'Infosys'),
    Stock(symbol: 'RELIANCE', name: 'Reliance Industries'),
    Stock(symbol: 'TCS', name: 'Tata Consultancy Services'),
    Stock(symbol: 'ICICIBANK', name: 'ICICI Bank'),
    Stock(symbol: 'HINDUNILVR', name: 'Hindustan Unilever'),
    Stock(symbol: 'ITC', name: 'ITC'),
    Stock(symbol: 'SBIN', name: 'State Bank of India'),
    Stock(symbol: 'BHARTIARTL', name: 'Bharti Airtel'),
    Stock(symbol: 'KOTAKBANK', name: 'Kotak Mahindra Bank'),
    Stock(symbol: 'LT', name: 'Larsen & Toubro'),
    Stock(symbol: 'AXISBANK', name: 'Axis Bank'),
    Stock(symbol: 'ASIANPAINT', name: 'Asian Paints'),
    Stock(symbol: 'MARUTI', name: 'Maruti Suzuki'),
    Stock(symbol: 'TITAN', name: 'Titan Company'),
    Stock(symbol: 'SUNPHARMA', name: 'Sun Pharmaceutical'),
    Stock(symbol: 'BAJFINANCE', name: 'Bajaj Finance'),
    Stock(symbol: 'HCLTECH', name: 'HCL Technologies'),
    Stock(symbol: 'WIPRO', name: 'Wipro'),
    Stock(symbol: 'ULTRACEMCO', name: 'UltraTech Cement'),
    Stock(symbol: 'NESTLEIND', name: 'Nestlé India'),
    Stock(symbol: 'POWERGRID', name: 'Power Grid Corporation'),
    Stock(symbol: 'NTPC', name: 'NTPC'),
    Stock(symbol: 'ONGC', name: 'Oil & Natural Gas Corporation'),
    Stock(symbol: 'TATAMOTORS', name: 'Tata Motors'),
    Stock(symbol: 'TATASTEEL', name: 'Tata Steel'),
    Stock(symbol: 'JSWSTEEL', name: 'JSW Steel'),
    Stock(symbol: 'ADANIPORTS', name: 'Adani Ports & SEZ'),
    Stock(symbol: 'M&M', name: 'Mahindra & Mahindra'),
    Stock(symbol: 'BAJAJFINSV', name: 'Bajaj Finserv'),
    Stock(symbol: 'TECHM', name: 'Tech Mahindra'),
    Stock(symbol: 'DIVISLAB', name: 'Divi’s Laboratories'),
    Stock(symbol: 'DRREDDY', name: 'Dr. Reddy’s Laboratories'),
    Stock(symbol: 'CIPLA', name: 'Cipla'),
    Stock(symbol: 'GRASIM', name: 'Grasim Industries'),
    Stock(symbol: 'HDFCLIFE', name: 'HDFC Life Insurance'),
    Stock(symbol: 'SBILIFE', name: 'SBI Life Insurance'),
    Stock(symbol: 'BRITANNIA', name: 'Britannia Industries'),
    Stock(symbol: 'PIDILITIND', name: 'Pidilite Industries'),
    Stock(symbol: 'HAVELLS', name: 'Havells India'),
    Stock(symbol: 'DMART', name: 'Avenue Supermarts'),
    Stock(symbol: 'EICHERMOT', name: 'Eicher Motors'),
    Stock(symbol: 'HEROMOTOCO', name: 'Hero MotoCorp'),
    Stock(symbol: 'INDUSINDBK', name: 'IndusInd Bank'),
    Stock(symbol: 'COALINDIA', name: 'Coal India'),
    Stock(symbol: 'BPCL', name: 'Bharat Petroleum'),
    Stock(symbol: 'TATACONSUM', name: 'Tata Consumer Products'),
    Stock(symbol: 'APOLLOHOSP', name: 'Apollo Hospitals'),
  ];

  static Stock? bySymbol(String symbol) {
    for (final s in stocks) {
      if (s.symbol == symbol) return s;
    }
    return null;
  }

  static List<Stock> search(String query) =>
      stocks.where((s) => s.matches(query)).toList();
}
