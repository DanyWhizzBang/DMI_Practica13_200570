import 'package:dmi_practica11_200070/common/MediaProvider.dart';
import 'package:dmi_practica11_200070/model/Media.dart';

class Cast()
int id;
String name;
String profilePath;
factory Cast(Map jsonMap, MediaType mediaType){
try{
  return new Cast.deserialize(jsonMap, mediaType);
  }catch(ex){
    throw ex;
  }
}
Cast.deserialize(Map jsonMap, MediaType mediaType):
id=jsonMap["Cast_id"].toInt(),
name=jsonMap["cast_id"],
profilePath=jsonMap["profile_path"];