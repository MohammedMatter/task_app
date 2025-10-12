import 'dart:io';

class NetworkManager {
  Future<bool> hasInternetConnection() async {
    try {
  
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
       
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
  
      return false;
    } on Exception catch (_) {
  
      return false;
    }
  }
}
