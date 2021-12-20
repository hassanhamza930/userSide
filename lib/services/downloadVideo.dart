

import 'package:dio/dio.dart';
import "dart:io";



downloadVideo(Dio dio, String url, String savePath)async{
  try {
    Response response = await dio.get(
      url, //Received data with List<int>
      options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          }),
    );
    print(response.headers);
    File file = File(savePath);
    var raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();
    return "ok";
  }
  catch (e) {
    return e.message;
  }
}