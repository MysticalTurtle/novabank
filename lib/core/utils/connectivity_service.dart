import 'package:connectivity_plus/connectivity_plus.dart';

abstract class ConnectivityService {
  Future<bool> hasInternetConnection();
}

class ConnectivityServiceImpl implements ConnectivityService {
  final Connectivity _connectivity;

  ConnectivityServiceImpl({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  @override
  Future<bool> hasInternetConnection() async {
    try {
      final result = await _connectivity.checkConnectivity();

      // Check if any connectivity result indicates connection
      return result.any(
        (element) =>
            element == ConnectivityResult.mobile ||
            element == ConnectivityResult.wifi ||
            element == ConnectivityResult.ethernet,
      );
    } catch (e) {
      // If we can't check, assume no connection
      return false;
    }
  }
}
