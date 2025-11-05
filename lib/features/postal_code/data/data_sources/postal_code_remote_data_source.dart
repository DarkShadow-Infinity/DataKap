import 'package:datakap/core/error/exceptions.dart';
import 'package:datakap/core/network/api_endpoint.dart';
import 'package:datakap/core/network/api_provider.dart';
import 'package:datakap/features/postal_code/data/models/postal_code_models.dart';

abstract class PostalCodeRemoteDataSource {
  Future<PostalCodeInfoModel> getInfoByPostalCode(String postalCode);
}

class PostalCodeRemoteDataSourceImpl implements PostalCodeRemoteDataSource {
  PostalCodeRemoteDataSourceImpl();

  @override
  Future<PostalCodeInfoModel> getInfoByPostalCode(String postalCode) async {
    final response = await APIProvider.get(
      ApiEndPoint.getPostalCodeInfo,
      urlArgs: [postalCode],
      useAuth: false,
    ).request();

    if (response.success && response.data != null) {
      // The root of the response is the object we need, no need to access a 'data' field.
      return PostalCodeInfoModel.fromJson(response.data);
    } else {
      throw ServerException(response.message);
    }
  }
}
