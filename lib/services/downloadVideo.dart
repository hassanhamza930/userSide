

import 'package:dio/dio.dart';
import "dart:io";

import 'package:image_gallery_saver/image_gallery_saver.dart';



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

    final result = await ImageGallerySaver.saveFile(raf.path);

    return "ok";
  }
  catch (e) {
    return e.message;
  }
}